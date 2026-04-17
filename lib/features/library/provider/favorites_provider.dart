import 'package:mythica/config/app_config.dart';
import 'package:mythica/features/book/model/book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FavoritesProvider extends ChangeNotifier {
  FavoritesProvider({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  bool _isLoading = false;
  String? _error;

  final List<BookModel> _favoriteBooks = [];

  bool get isLoading => _isLoading;
  String? get error => _error;

  List<BookModel> get favoriteBooks => List.unmodifiable(_favoriteBooks);

  /// check if book is favorite
  bool isFavorite(String bookId) {
    return _favoriteBooks.any((book) => book.id == bookId);
  }

  /// load favorites
  Future<void> loadFavorites({String userId = 'reader_1'}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final books = isDummyMode
          ? await _loadDummyFavorites()
          : await _loadFirestoreFavorites(userId: userId);

      _favoriteBooks
        ..clear()
        ..addAll(books);
    } catch (e) {
      _error = "Failed to load favorites";
    }

    _isLoading = false;
    notifyListeners();
  }

  /// refresh favorites
  Future<void> refreshFavorites({String userId = 'reader_1'}) async {
    try {
      final books = isDummyMode
          ? await _loadDummyFavorites()
          : await _loadFirestoreFavorites(userId: userId);

      _favoriteBooks
        ..clear()
        ..addAll(books);

      notifyListeners();
    } catch (e) {
      _error = "Refresh failed";
      notifyListeners();
    }
  }

  /// toggle favorite
  Future<void> toggleFavorite(BookModel book,
      {String userId = 'reader_1'}) async {
    if (isFavorite(book.id)) {
      await removeFromFavorites(book.id, userId: userId);
    } else {
      await addToFavorites(book, userId: userId);
    }
  }

  /// add favorite
  Future<void> addToFavorites(BookModel book,
      {String userId = 'reader_1'}) async {
    if (isFavorite(book.id)) return;

    final newBook = book.copyWith(
      isBookmarked: true,
      savedAt: DateTime.now(),
    );

    /// optimistic UI update
    _favoriteBooks.insert(0, newBook);
    notifyListeners();

    try {
      if (!isDummyMode) {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('bookmarks')
            .doc(book.id)
            .set({
          "savedAt": Timestamp.now(),
        });
      }
    } catch (e) {
      /// rollback
      _favoriteBooks.removeWhere((b) => b.id == book.id);
      _error = "Failed to add favorite";
      notifyListeners();
    }
  }

  /// remove favorite
  Future<void> removeFromFavorites(String bookId,
      {String userId = 'reader_1'}) async {
    final index = _favoriteBooks.indexWhere((b) => b.id == bookId);

    if (index == -1) return;

    final removedBook = _favoriteBooks[index];

    /// optimistic update
    _favoriteBooks.removeAt(index);
    notifyListeners();

    try {
      if (!isDummyMode) {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('bookmarks')
            .doc(bookId)
            .delete();
      }
    } catch (e) {
      /// rollback
      _favoriteBooks.insert(index, removedBook);
      _error = "Failed to remove favorite";
      notifyListeners();
    }
  }

  /// FIRESTORE LOAD

  Future<List<BookModel>> _loadFirestoreFavorites(
      {required String userId}) async {
    final bookmarks = await _fetchBookmarkedIds(userId: userId);

    if (bookmarks.isEmpty) return [];

    final details = await _fetchBooksByIds(bookmarks.keys.toList());

    final merged = <BookModel>[];

    for (final entry in bookmarks.entries) {
      final book = details[entry.key];
      if (book == null) continue;

      merged.add(
        book.copyWith(
          savedAt: entry.value,
          isBookmarked: true,
        ),
      );
    }

    merged.sort((a, b) =>
        (b.savedAt ?? DateTime(0)).compareTo(a.savedAt ?? DateTime(0)));

    return merged;
  }

  Future<Map<String, DateTime>> _fetchBookmarkedIds(
      {required String userId}) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('bookmarks')
        .get();

    final result = <String, DateTime>{};

    for (final doc in snapshot.docs) {
      final savedAtRaw = doc.data()['savedAt'];

      final savedAt = savedAtRaw is Timestamp
          ? savedAtRaw.toDate()
          : DateTime.fromMillisecondsSinceEpoch(0);

      result[doc.id] = savedAt;
    }

    return result;
  }

  Future<Map<String, BookModel>> _fetchBooksByIds(
      List<String> bookIds) async {
    final result = <String, BookModel>{};

    for (final id in bookIds) {
      final doc = await _firestore.collection('books').doc(id).get();

      if (!doc.exists) continue;

      result[id] = BookModel.fromFirestore(doc);
    }

    return result;
  }

  /// Dummy mode

  Future<List<BookModel>> _loadDummyFavorites() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return _dummyBooks
        .where((book) => book.isBookmarked)
        .toList()
      ..sort((a, b) =>
          (b.savedAt ?? DateTime(0)).compareTo(a.savedAt ?? DateTime(0)));
  }
}

final List<BookModel> _dummyBooks = [
  BookModel(
    id: "book_1",
    title: "The Midnight Library",
    description: "Life choices story",
    authorName: "Matt Haig",
    coverUrl: "assets/books/Book1.png",
    genre: "Fiction",
    rating: 4.6,
    reviewCount: 1320,
    isPaid: false,
    price: 0,
    viewsCount: 20000,
    isBookmarked: true,
    savedAt: DateTime(2026, 1, 18),
  ),
  BookModel(
    id: "book_2",
    title: "Project Hail Mary",
    description: "Sci-fi survival story",
    authorName: "Andy Weir",
    coverUrl: "assets/books/Book2.png",
    genre: "Sci-Fi",
    rating: 4.8,
    reviewCount: 900,
    isPaid: true,
    price: 149,
    viewsCount: 18000,
    isBookmarked: true,
    savedAt: DateTime(2026, 1, 15),
  ),
];