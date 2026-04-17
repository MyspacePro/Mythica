import 'package:mythica/config/app_config.dart';
import 'package:mythica/data/dummy_books.dart';
import 'package:mythica/models/writer_book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DiscoverProvider extends ChangeNotifier {
  DiscoverProvider({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  bool _isLoading = false;
  String? _error;
  String _selectedGenre = 'All';
  String _searchQuery = '';

  List<Book> _allBooks = [];
  List<Book> _visibleBooks = [];
  List<Book> _trendingBooks = [];
  List<Book> _popularBooks = [];
  List<Book> _newArrivalsBooks = [];
  List<Book> _topRatedBooks = [];

  // ---------------- GETTERS ----------------

  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedGenre => _selectedGenre;
  String get searchQuery => _searchQuery;

  List<Book> get allBooks => List.unmodifiable(_allBooks);
  List<Book> get visibleBooks => List.unmodifiable(_visibleBooks);
  List<Book> get trendingBooks => List.unmodifiable(_trendingBooks);
  List<Book> get popularBooks => List.unmodifiable(_popularBooks);
  List<Book> get newArrivalsBooks => List.unmodifiable(_newArrivalsBooks);
  List<Book> get topRatedBooks => List.unmodifiable(_topRatedBooks);

  List<String> get genres {
    final set = <String>{'All'};
    for (final book in _allBooks) {
      final genre = book.genre.trim();
      if (genre.isNotEmpty) {
        set.add(genre);
      }
    }
    final list = set.toList();
    list.sort();
    return list;
  }

  // ---------------- LOAD DATA ----------------

  Future<void> loadDiscoverData() async {
    _setLoading(true);

    try {
      _allBooks = isDummyMode
          ? await _loadDummyBooks()
          : await _loadFirestoreBooks();

      _applyFilters();
      _calculateSections();
    } catch (e) {
      _error = 'Failed to load Discover data.';
      _clearAll();
    }

    _setLoading(false);
  }

  Future<void> refreshData() async {
    await loadDiscoverData();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    if (value) _error = null;
    notifyListeners();
  }

  void _clearAll() {
    _allBooks = [];
    _visibleBooks = [];
    _trendingBooks = [];
    _popularBooks = [];
    _newArrivalsBooks = [];
    _topRatedBooks = [];
  }

  // ---------------- DATA SOURCES ----------------

  Future<List<Book>> _loadDummyBooks() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return dummyBooks;
  }

  Future<List<Book>> _loadFirestoreBooks() async {
    final snapshot = await _firestore.collection('books').get();
    return snapshot.docs.map(_mapFromFirestore).toList();
  }

  Book _mapFromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data() ?? {};

    return Book(
      id: doc.id,
      title: map['title']?.toString() ?? '',
      author: map['authorName']?.toString() ?? 'Unknown',
      authorName: map['authorName']?.toString() ?? 'Unknown',
      coverImage:
          map['coverImage']?.toString() ?? 'assets/books/Book1.png',
      summary: map['description']?.toString() ?? '',
      genre: map['genre']?.toString() ?? 'General',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (map['reviewCount'] as num?)?.toInt() ?? 0,
      viewsCount: (map['viewsCount'] as num?)?.toInt() ?? 0,
      totalEarnings: (map['totalEarnings'] as num?)?.toDouble() ?? 0.0,
      isPaid: map['isPaid'] == true,
      isPremium: map['isPaid'] == true,
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      createdAt: _parseCreatedAt(map['createdAt']),
    );
  }

  DateTime _parseCreatedAt(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.now();
  }

  // ---------------- FILTERING ----------------

  void filterByGenre(String genre) {
    _selectedGenre = genre;
    _applyFilters();
    _calculateSections();
    notifyListeners();
  }

  void searchBooks(String query) {
    _searchQuery = query;
    _applyFilters();
    _calculateSections();
    notifyListeners();
  }

  void _applyFilters() {
    List<Book> books = List.from(_allBooks);

    if (_selectedGenre != 'All') {
      books = books
          .where((book) =>
              book.genre.toLowerCase() ==
              _selectedGenre.toLowerCase())
          .toList();
    }

    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.trim().toLowerCase();
      books = books.where((book) {
        return book.title.toLowerCase().contains(query) ||
            book.authorName.toLowerCase().contains(query);
      }).toList();
    }

    _visibleBooks = books;
  }

  // ---------------- SECTIONS ----------------

  void _calculateSections() {
    _trendingBooks = _sortAndLimit(
      _visibleBooks,
      (a, b) => b.viewsCount.compareTo(a.viewsCount),
    );

    _popularBooks = _sortAndLimit(
      _visibleBooks,
      (a, b) => b.totalEarnings.compareTo(a.totalEarnings),
    );

    _newArrivalsBooks = _sortAndLimit(
      _visibleBooks,
      (a, b) => b.createdAt.compareTo(a.createdAt),
    );

    _topRatedBooks = _sortAndLimit(
      _visibleBooks.where((b) => b.rating >= 4).toList(),
      (a, b) => b.rating.compareTo(a.rating),
    );
  }

  List<Book> _sortAndLimit(
    List<Book> list,
    int Function(Book a, Book b) compare,
  ) {
    final sorted = List<Book>.from(list)..sort(compare);
    return sorted.take(10).toList();
  }
}