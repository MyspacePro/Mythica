import 'package:mythica/config/app_config.dart';
import 'package:mythica/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'notification_provider.dart';

class MonetizationProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  final NotificationProvider _notificationProvider;

  MonetizationProvider({FirebaseFirestore? firestore, required NotificationProvider notificationProvider})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _notificationProvider = notificationProvider;

  double _dummyBalance = 4800;
  double _dummyTotalEarnings = 16240;
  final List<Map<String, dynamic>> _dummyTransactions = [
    {'title': 'Book Sale - Shadow of the Valley', 'amount': 199.0, 'isCredit': true},
    {'title': 'Book Sale - The Last Archive', 'amount': 149.0, 'isCredit': true},
    {'title': 'Writer Wallet Withdrawal', 'amount': 1000.0, 'isCredit': false},
  ];

  double get dummyBalance => _dummyBalance;
  double get dummyTotalEarnings => _dummyTotalEarnings;
  List<Map<String, dynamic>> get transactions => _dummyTransactions;

  Stream<DocumentSnapshot<Map<String, dynamic>>> writerEarningsStream(String writerId) {
    return _firestore.collection('users').doc(writerId).snapshots();
  }

  Future<void> publishBook({required AppUser writer, required String title, required bool isPaid, required double price}) async {
    if (title.trim().isEmpty) throw Exception('Book title is required.');
    if (writer.role != UserRole.writer) {
      throw Exception('Switch to Writer account from Profile to access this feature');
    }
    if (isPaid && !writer.isPremium) throw Exception('Upgrade to Premium to publish paid books');
    if (isPaid && price <= 0) throw Exception('Price must be greater than zero for paid books.');

    if (isDummyMode) return;

    await _firestore.collection('books').add({
      'title': title.trim(),
      'authorId': writer.uid,
      'isPaid': isPaid,
      'price': isPaid ? price : 0,
      'totalEarnings': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> purchaseBook({required String buyerId, required String buyerName, required String bookId}) async {
    if (isDummyMode) {
      _dummyBalance = (_dummyBalance - 149).clamp(0, double.infinity).toDouble();
      _dummyTotalEarnings += 149;
      _dummyTransactions.insert(0, {'title': 'Book Sale - $bookId', 'amount': 149.0, 'isCredit': true});
      await _notificationProvider.createNotification(
        userId: 'writer_1',
        type: 'earning',
        title: 'Earning credited',
        body: '$buyerName purchased your book.',
      );
      notifyListeners();
      return;
    }

    final bookRef = _firestore.collection('books').doc(bookId);
    final purchaseRef = _firestore.collection('users').doc(buyerId).collection('purchases').doc(bookId);

    await _firestore.runTransaction((tx) async {
      final bookDoc = await tx.get(bookRef);
      if (!bookDoc.exists || bookDoc.data() == null) throw Exception('Book not found.');
      final bookData = bookDoc.data()!;
      final isPaid = bookData['isPaid'] == true;
      final price = (bookData['price'] as num?)?.toDouble() ?? 0;
      final writerId = bookData['authorId']?.toString() ?? '';

      if (!isPaid) {
        tx.set(purchaseRef, {'bookId': bookId, 'isFree': true, 'createdAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
        return;
      }

      final purchaseDoc = await tx.get(purchaseRef);
      if (purchaseDoc.exists) throw Exception('Book already purchased.');

      final buyerRef = _firestore.collection('users').doc(buyerId);
      final writerRef = _firestore.collection('users').doc(writerId);
      final buyerDoc = await tx.get(buyerRef);
      final buyerBalance = (buyerDoc.data()?['availableBalance'] as num?)?.toDouble() ?? 0;
      if (buyerBalance < price) throw Exception('Insufficient balance.');

      tx.set(purchaseRef, {'bookId': bookId, 'writerId': writerId, 'price': price, 'createdAt': FieldValue.serverTimestamp()});
      tx.update(buyerRef, {'availableBalance': buyerBalance - price});
      tx.update(writerRef, {'availableBalance': FieldValue.increment(price), 'totalEarnings': FieldValue.increment(price)});
      tx.update(bookRef, {'totalEarnings': FieldValue.increment(price)});
    });
  }

  Future<void> handlePremiumExpiry(String uid) async {
    if (isDummyMode) return;
    final userRef = _firestore.collection('users').doc(uid);
    final userDoc = await userRef.get();
    final expiry = userDoc.data()?['premiumExpiry'];
    final expiryDate = expiry is Timestamp ? expiry.toDate() : null;
    if (expiryDate != null && expiryDate.isBefore(DateTime.now())) {
      await userRef.update({'isPremium': false});
    }
  }

  Future<void> notifyPremiumActivated(String uid) async {
    await _notificationProvider.createNotification(userId: uid, type: 'premium', title: 'Premium activated', body: 'Your premium writer plan is active now.');
  }
}
