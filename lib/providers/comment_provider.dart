import 'package:mythica/config/app_config.dart';
import 'package:mythica/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'notification_provider.dart';

class BookComment {
  BookComment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userProfilePic,
    required this.commentText,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String userName;
  final String userProfilePic;
  final String commentText;
  final DateTime createdAt;
}

class CommentProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  final NotificationProvider _notificationProvider;

  CommentProvider({
    FirebaseFirestore? firestore,
    required NotificationProvider notificationProvider,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _notificationProvider = notificationProvider;

  final Map<String, List<BookComment>> _dummyComments = {};

  List<BookComment> commentsForBook(String bookId) => _dummyComments[bookId] ?? const [];

  Stream<QuerySnapshot<Map<String, dynamic>>> commentsStream(String bookId) {
    if (isDummyMode) {
      return const Stream.empty();
    }
    return _firestore.collection('books').doc(bookId).collection('comments').orderBy('createdAt', descending: true).snapshots();
  }

  Future<void> loadComments(String bookId) async {
    try {
      if (isDummyMode) {
        await Future.delayed(const Duration(milliseconds: 500));
        _dummyComments[bookId] = _buildDummyComments(bookId);
        notifyListeners();
        return;
      }

      final snapshot = await _firestore.collection('books').doc(bookId).collection('comments').orderBy('createdAt', descending: true).get();
      _dummyComments[bookId] = snapshot.docs
          .map((doc) => BookComment(
                id: doc.id,
                userId: doc.data()['userId']?.toString() ?? '',
                userName: doc.data()['userName']?.toString() ?? 'Reader',
                userProfilePic: doc.data()['userProfilePic']?.toString() ?? 'assets/profile/male.png',
                commentText: doc.data()['commentText']?.toString() ?? '',
                createdAt: (doc.data()['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
              ))
          .toList();
      notifyListeners();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> addComment({
    required String bookId,
    required String authorId,
    required AppUser user,
    required String commentText,
  }) async {
    if (user.uid.isEmpty) throw Exception('Please login to comment.');
    final trimmed = commentText.trim();
    if (trimmed.isEmpty) throw Exception('Comment cannot be empty.');

    try {
      if (isDummyMode) {
        final list = _dummyComments[bookId] ?? _buildDummyComments(bookId);
        list.insert(
          0,
          BookComment(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            userId: user.uid,
            userName: user.name,
            userProfilePic: user.photoUrl ?? user.profileImageUrl ?? 'assets/profile/male.png',
            commentText: trimmed,
            createdAt: DateTime.now(),
          ),
        );
        _dummyComments[bookId] = list;
        notifyListeners();
      } else {
        await _firestore.collection('books').doc(bookId).collection('comments').add({
          'userId': user.uid,
          'userName': user.name,
          'userProfilePic': user.photoUrl ?? user.profileImageUrl ?? '',
          'commentText': trimmed,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      if (authorId != user.uid) {
        await _notificationProvider.createNotification(
          userId: authorId,
          type: 'comment',
          title: 'New comment',
          body: '${user.name} commented on your book.',
        );
      }
    } catch (_) {
      rethrow;
    }
  }

  List<BookComment> _buildDummyComments(String bookId) {
    final now = DateTime.now();
    return List.generate(4, (index) {
      final names = ['Ananya', 'Rahul', 'Mihir', 'Sana', 'Rakesh'];
      final texts = [
        'Loved the pacing in the opening chapter!',
        'The ending felt so cinematic. Great work 👏',
        'Can’t wait for the next part.',
        'The dialogue between characters felt very real.',
        'This deserves a higher rating for sure.',
      ];
      return BookComment(
        id: '${bookId}_$index',
        userId: 'reader_$index',
        userName: names[(bookId.hashCode + index) % names.length],
        userProfilePic: 'assets/profile/male.png',
        commentText: texts[(bookId.hashCode + index) % texts.length],
        createdAt: now.subtract(Duration(minutes: 22 * (index + 1))),
      );
    });
  }
}
