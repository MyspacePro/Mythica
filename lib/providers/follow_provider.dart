import 'package:mythica/config/app_config.dart';
import 'package:mythica/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'notification_provider.dart';

class FollowProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  final NotificationProvider _notificationProvider;

  FollowProvider({FirebaseFirestore? firestore, required NotificationProvider notificationProvider})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _notificationProvider = notificationProvider;

  final Map<String, Set<String>> _dummyFollowersByWriter = {
    'writer_1': {'reader_2', 'reader_3', 'reader_5'},
    'writer_2': {'reader_1', 'reader_6'},
  };

  final Map<String, Set<String>> _dummyFollowingByReader = {
    'reader_1': {'writer_2'},
    'reader_2': {'writer_1'},
  };

  bool isFollowing({required String readerId, required String writerId}) {
    return _dummyFollowingByReader[readerId]?.contains(writerId) ?? false;
  }

  int followersCount(String writerId) {
    return _dummyFollowersByWriter[writerId]?.length ?? 0;
  }

  int followingCount(String readerId) {
    return _dummyFollowingByReader[readerId]?.length ?? 0;
  }

  Stream<bool> isFollowingStream({required String readerId, required String writerId}) {
    if (isDummyMode) return Stream.value(isFollowing(readerId: readerId, writerId: writerId));
    return _firestore.collection('users').doc(writerId).collection('followers').doc(readerId).snapshots().map((doc) => doc.exists);
  }

  Stream<int> followersCountStream(String writerId) {
    if (isDummyMode) return Stream.value(followersCount(writerId));
    return _firestore.collection('users').doc(writerId).snapshots().map((event) => (event.data()?['followersCount'] as num?)?.toInt() ?? 0);
  }

  Stream<int> followingCountStream(String readerId) {
    if (isDummyMode) return Stream.value(followingCount(readerId));
    return _firestore.collection('users').doc(readerId).snapshots().map((event) => (event.data()?['followingCount'] as num?)?.toInt() ?? 0);
  }

  Future<void> toggleFollow({required AppUser currentUser, required String writerId, required String writerName}) async {
    if (currentUser.uid == writerId) throw Exception('Writers cannot follow themselves.');
    if (currentUser.role != UserRole.reader) {
      throw Exception('Switch to Writer account from Profile to access this feature');
    }

    if (isDummyMode) {
      final followerSet = _dummyFollowersByWriter.putIfAbsent(writerId, () => <String>{});
      final followingSet = _dummyFollowingByReader.putIfAbsent(currentUser.uid, () => <String>{});
      if (followerSet.contains(currentUser.uid)) {
        followerSet.remove(currentUser.uid);
        followingSet.remove(writerId);
      } else {
        followerSet.add(currentUser.uid);
        followingSet.add(writerId);
        await _notificationProvider.createNotification(
          userId: writerId,
          type: 'follow',
          title: 'New follower',
          body: '${currentUser.name} started following you.',
        );
      }
      notifyListeners();
      return;
    }

    final writerFollowerRef = _firestore.collection('users').doc(writerId).collection('followers').doc(currentUser.uid);
    final readerFollowingRef = _firestore.collection('users').doc(currentUser.uid).collection('following').doc(writerId);
    final writerRef = _firestore.collection('users').doc(writerId);
    final readerRef = _firestore.collection('users').doc(currentUser.uid);

    await _firestore.runTransaction((transaction) async {
      final existing = await transaction.get(writerFollowerRef);
      if (existing.exists) {
        transaction.delete(writerFollowerRef);
        transaction.delete(readerFollowingRef);
        transaction.update(writerRef, {'followersCount': FieldValue.increment(-1)});
        transaction.update(readerRef, {'followingCount': FieldValue.increment(-1)});
      } else {
        transaction.set(writerFollowerRef, {'followerId': currentUser.uid, 'createdAt': FieldValue.serverTimestamp()});
        transaction.set(readerFollowingRef, {'writerId': writerId, 'createdAt': FieldValue.serverTimestamp()});
        transaction.update(writerRef, {'followersCount': FieldValue.increment(1)});
        transaction.update(readerRef, {'followingCount': FieldValue.increment(1)});
      }
    });
  }
}
