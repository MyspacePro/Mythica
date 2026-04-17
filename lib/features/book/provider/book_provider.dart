import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mythica/config/app_config.dart';
import 'package:mythica/data/dummy_books.dart';
import 'package:mythica/models/writer_book_model.dart';

class BookProvider extends ChangeNotifier {
  BookProvider({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  bool _isLoading = false;
  String? _error;

  List<Book> _books = [];

  StreamSubscription? _booksSubscription;

  /// =============================
  /// GETTERS
  /// =============================

  bool get isLoading => _isLoading;

  String? get error => _error;

  List<Book> get books => List.unmodifiable(_books);

  /// =============================
  /// LOAD BOOKS
  /// =============================

  Future<void> loadBooks() async {
    _setLoading(true);
    _error = null;

    try {
      if (isDummyMode) {
        _books = await _loadDummyBooks();
      } else {
        _books = await _loadFirebaseBooks();
      }
    } catch (e) {
      debugPrint("Load books error: $e");
      _error = 'Unable to load books right now.';
    }

    _setLoading(false);
  }

  /// =============================
  /// DUMMY DATA
  /// =============================

  Future<List<Book>> _loadDummyBooks() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return dummyBooks;
  }

  /// =============================
  /// FIREBASE DATA
  /// =============================

  Future<List<Book>> _loadFirebaseBooks() async {
    final snapshot = await _firestore.collection('books').get();

    return snapshot.docs.map((doc) => _bookFromMap(doc)).toList();
  }

  /// =============================
  /// REALTIME LISTENER
  /// =============================

  void listenToBooks() {
    if (isDummyMode) {
      _books = dummyBooks;
      notifyListeners();
      return;
    }

    _booksSubscription?.cancel();

    _booksSubscription = _firestore
        .collection('books')
        .snapshots()
        .listen((snapshot) {
      _books = snapshot.docs.map((doc) => _bookFromMap(doc)).toList();
      notifyListeners();
    }, onError: (error) {
      debugPrint("Books stream error: $error");
      _error = "Unable to sync books.";
      notifyListeners();
    });
  }

  /// =============================
  /// FIRESTORE → BOOK MODEL
  /// =============================

  Book _bookFromMap(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data() ?? {};

    return Book(
      id: doc.id,
      title: map['title']?.toString() ?? '',
      author: map['authorName']?.toString() ?? 'Unknown',
      authorName: map['authorName']?.toString() ?? 'Unknown',
      authorId: map['authorId']?.toString() ?? '',
      coverImage: map['coverImage']?.toString() ??
          map['coverUrl']?.toString() ??
          'assets/books/Book1.png',
      summary: map['description']?.toString() ??
          map['summary']?.toString() ??
          '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (map['reviewCount'] as num?)?.toInt() ?? 0,
      isPaid: map['isPaid'] == true,
      isPremium: map['isPaid'] == true,
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      totalEarnings: (map['totalEarnings'] as num?)?.toDouble() ?? 0.0,
      genre: map['genre']?.toString() ?? 'General',
      viewsCount: (map['viewsCount'] as num?)?.toInt() ?? 0,
      pdfPath: map['pdfPath']?.toString() ?? 'assets/original/book1.pdf',
      status: map['status']?.toString(),
    );
  }

  /// =============================
  /// BOOK HELPERS
  /// =============================

  Book? getBookById(String id) {
    try {
      return _books.firstWhere((book) => book.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Book> searchBooks(String query) {
    final q = query.toLowerCase();

    return _books.where((book) {
      return book.title.toLowerCase().contains(q) ||
          book.authorName.toLowerCase().contains(q);
    }).toList();
  }

  /// =============================
  /// VIEW COUNTER
  /// =============================

  Future<void> incrementViews(String bookId) async {
    if (isDummyMode) return;

    try {
      await _firestore.collection('books').doc(bookId).update({
        'viewsCount': FieldValue.increment(1),
      });
    } catch (e) {
      debugPrint("Increment view error: $e");
    }
  }

  /// =============================
  /// ERROR HANDLING
  /// =============================

  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// =============================
  /// LOADING HELPER
  /// =============================

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// =============================
  /// DISPOSE
  /// =============================

  @override
  void dispose() {
    _booksSubscription?.cancel();
    super.dispose();
  }
}
