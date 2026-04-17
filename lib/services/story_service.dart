import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mythica/services/role_service.dart';

class StoryService {
  StoryService._();
  static final StoryService instance = StoryService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RoleService _roleService = RoleService.instance;

  CollectionReference<Map<String, dynamic>> get _stories =>
      _firestore.collection('stories');

  Future<String> createStory({
    required String uid,
    required String title,
    required String content,
    required String genre,
    String description = '',
    String coverImageUrl = '', required bool isPremium, required String authorName,
  }) async {
    if (title.trim().isEmpty) {
      throw ArgumentError('Title is required');
    }
    if (content.trim().isEmpty) {
      throw ArgumentError('Content is required');
    }
    if (genre.trim().isEmpty) {
      throw ArgumentError('Genre is required');
    }

    final profile = await _roleService.fetchUserProfile(uid);
    final role = profile?['role']?.toString();

    if (!_roleService.isWriterOrAdmin(role)) {
      throw FirebaseException(
        plugin: 'cloud_firestore',
        code: 'permission-denied',
        message: 'Only writer/admin can create stories',
      );
    }

    final doc = await _stories.add({
      'title': title.trim(),
      'description': description.trim(),
      'content': content.trim(),
      'genre': genre.trim(),
      'coverImageUrl': coverImageUrl,
      'authorId': uid,
      'authorName': profile?['name']?.toString() ?? 'Unknown Writer',
      'status': 'draft',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'likesCount': 0,
      'viewsCount': 0,
    });

    return doc.id;
  }

  Future<void> updateStory({
    required String uid,
    required String storyId,
    required Map<String, dynamic> updates,
  }) async {
    await _assertCanModifyStory(uid: uid, storyId: storyId);

    await _stories.doc(storyId).update({
      ...updates,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteStory({
    required String uid,
    required String storyId,
  }) async {
    await _assertCanModifyStory(uid: uid, storyId: storyId);
    await _stories.doc(storyId).delete();
  }

  Future<void> togglePublish({
    required String uid,
    required String storyId,
  }) async {
    await _assertCanModifyStory(uid: uid, storyId: storyId);

    final snapshot = await _stories.doc(storyId).get();
    final data = snapshot.data();
    if (data == null) {
      throw FirebaseException(
        plugin: 'cloud_firestore',
        code: 'not-found',
        message: 'Story not found',
      );
    }

    final currentStatus = data['status']?.toString() ?? 'draft';
    final nextStatus = currentStatus == 'draft' ? 'published' : 'draft';

    await _stories.doc(storyId).update({
      'status': nextStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _assertCanModifyStory({
    required String uid,
    required String storyId,
  }) async {
    final role = await _roleService.fetchRole(uid);
    final snapshot = await _stories.doc(storyId).get();
    final data = snapshot.data();

    if (data == null) {
      throw FirebaseException(
        plugin: 'cloud_firestore',
        code: 'not-found',
        message: 'Story not found',
      );
    }

    final isOwner = data['authorId'] == uid;
    final isAdmin = role == 'admin';

    if (!isOwner && !isAdmin) {
      throw FirebaseException(
        plugin: 'cloud_firestore',
        code: 'permission-denied',
        message: 'You do not have permission for this action',
      );
    }
  }
}
