import 'package:mythica/config/app_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppNotification {
  AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String type;
  final String title;
  final String body;
  bool isRead;
  final DateTime createdAt;
}

class NotificationProvider extends ChangeNotifier {
  NotificationProvider({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  final Map<String, List<AppNotification>> _dummyNotificationsByUser = {};

  CollectionReference<Map<String, dynamic>> _userNotifications(String userId) {
    return _firestore.collection('users').doc(userId).collection('notifications');
  }

  List<AppNotification> notificationsForUser(String userId) {
    return _dummyNotificationsByUser[userId] ?? const [];
  }

  int unreadCount(String userId) {
    return notificationsForUser(userId).where((e) => !e.isRead).length;
  }

  Future<void> loadNotifications(String userId) async {
    if (!isDummyMode) return;
    await Future.delayed(const Duration(milliseconds: 400));
    _dummyNotificationsByUser[userId] = _dummyNotifications(userId);
    notifyListeners();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> notificationsStream(String userId) {
    return _userNotifications(userId).orderBy('createdAt', descending: true).snapshots();
  }

  Stream<int> unreadCountStream(String userId) {
    if (isDummyMode) return Stream.value(unreadCount(userId));
    return _userNotifications(userId).where('isRead', isEqualTo: false).snapshots().map((event) => event.docs.length);
  }

  Future<void> createNotification({required String userId, required String type, required String title, required String body}) async {
    try {
      if (isDummyMode) {
        final list = _dummyNotificationsByUser.putIfAbsent(userId, () => _dummyNotifications(userId));
        list.insert(
          0,
          AppNotification(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            userId: userId,
            type: type,
            title: title,
            body: body,
            isRead: false,
            createdAt: DateTime.now(),
          ),
        );
        notifyListeners();
        return;
      }

      await _userNotifications(userId).add({'type': type, 'title': title, 'body': body, 'isRead': false, 'createdAt': FieldValue.serverTimestamp()});
    } catch (_) {
      rethrow;
    }
  }

  Future<void> markAsRead({required String userId, required String notificationId}) async {
    try {
      if (isDummyMode) {
        for (final n in _dummyNotificationsByUser[userId] ?? <AppNotification>[]) {
          if (n.id == notificationId) {
            n.isRead = true;
          }
        }
        notifyListeners();
        return;
      }
      await _userNotifications(userId).doc(notificationId).update({'isRead': true});
    } catch (_) {
      rethrow;
    }
  }

  List<AppNotification> _dummyNotifications(String userId) {
    final now = DateTime.now();
    return [
      AppNotification(id: 'n1', userId: userId, type: 'comment', title: 'New comment', body: 'Aanya commented on “Neon Skies”.', isRead: false, createdAt: now.subtract(const Duration(minutes: 14))),
      AppNotification(id: 'n2', userId: userId, type: 'follow', title: 'New follower', body: 'Rohit started following you.', isRead: false, createdAt: now.subtract(const Duration(hours: 1))),
      AppNotification(id: 'n3', userId: userId, type: 'premium', title: 'Premium active', body: 'Your writer premium plan is now active.', isRead: true, createdAt: now.subtract(const Duration(hours: 3))),
      AppNotification(id: 'n4', userId: userId, type: 'earning', title: 'Earning credited', body: '₹149 added from a paid book purchase.', isRead: false, createdAt: now.subtract(const Duration(hours: 6))),
      AppNotification(id: 'n5', userId: userId, type: 'comment', title: 'Discussion started', body: 'Readers are discussing chapter 3.', isRead: true, createdAt: now.subtract(const Duration(days: 1))),
      AppNotification(id: 'n6', userId: userId, type: 'follow', title: 'Follower milestone', body: 'You crossed 1,200 followers.', isRead: false, createdAt: now.subtract(const Duration(days: 2))),
    ];
  }
}
