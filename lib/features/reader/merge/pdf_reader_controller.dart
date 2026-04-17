import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PdfReaderController extends ChangeNotifier {
  static const String _pdfProgressKey = 'reader_pdf_progress';
  static const String _bookmarkKey = 'reader_pdf_bookmarks';

  String _bookId = '';
  int _currentPage = 0;
  int _totalPages = 0;

  late SharedPreferences _prefs;

  final Map<String, int> _pdfPageProgress = {};
  final Map<String, List<int>> _bookmarks = {};

  bool _initialized = false;
  Timer? _debounce;

  /// ---------------------------
  /// GETTERS
  /// ---------------------------

  String get bookId => _bookId;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;

  double get progressPercentage {
    if (_totalPages == 0) return 0;
    return (_currentPage + 1) / _totalPages;
  }

  List<int> get currentBookmarks =>
      _bookmarks[_bookId] ?? [];

  bool get isInitialized => _initialized;

  /// ---------------------------
  /// INIT
  /// ---------------------------

  Future<void> init({
    required String bookId,
    required int totalPages,
  }) async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      await _loadAllData();
      _initialized = true;
    }

    _bookId = bookId;
    _totalPages = totalPages;

    _currentPage = _pdfPageProgress[_bookId] ?? 0;

    notifyListeners();
  }

  Future<void> openPdf({
    required String bookId,
    required int totalPages,
  }) async {
    await init(bookId: bookId, totalPages: totalPages);
  }

  /// ---------------------------
  /// PAGE TRACKING (DEBOUNCED)
  /// ---------------------------

  void onPageChanged(int page) {
    final lastPage = _totalPages > 0 ? _totalPages - 1 : 0;
    final newPage = page.clamp(0, lastPage);

    if (newPage == _currentPage) return;

    _currentPage = newPage;
    _pdfPageProgress[_bookId] = _currentPage;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _saveProgress();
    });

    notifyListeners();
  }

  /// ---------------------------
  /// BOOKMARK SYSTEM
  /// ---------------------------

  Future<void> addBookmark(String bookId) async {
    final list = _bookmarks[bookId] ?? [];

    if (!list.contains(_currentPage)) {
      list.add(_currentPage);
      list.sort();
      _bookmarks[bookId] = list;

      await _saveBookmarks();
      notifyListeners();
    }
  }

  Future<void> removeBookmark(int page) async {
    final list = _bookmarks[_bookId];
    if (list == null) return;

    list.remove(page);

    await _saveBookmarks();
    notifyListeners();
  }

  bool isBookmarked(int page) {
    return _bookmarks[_bookId]?.contains(page) ?? false;
  }

  /// ---------------------------
  /// STORAGE SAVE
  /// ---------------------------

  Future<void> _saveProgress() async {
    try {
      final encoded = jsonEncode(_pdfPageProgress);
      await _prefs.setString(_pdfProgressKey, encoded);
    } catch (e) {
      debugPrint("Save progress error: $e");
    }
  }

  Future<void> _saveBookmarks() async {
    try {
      final encoded = jsonEncode(_bookmarks);
      await _prefs.setString(_bookmarkKey, encoded);
    } catch (e) {
      debugPrint("Save bookmark error: $e");
    }
  }

  /// ---------------------------
  /// STORAGE LOAD
  /// ---------------------------

  Future<void> _loadAllData() async {
    try {
      /// Progress
      final rawProgress = _prefs.getString(_pdfProgressKey);

      if (rawProgress != null && rawProgress.isNotEmpty) {
        final decoded = jsonDecode(rawProgress);

        _pdfPageProgress
          ..clear()
          ..addAll(
            (decoded as Map<String, dynamic>).map(
              (k, v) => MapEntry(k, (v as num).toInt()),
            ),
          );
      }

      /// Bookmarks
      final rawBookmarks = _prefs.getString(_bookmarkKey);

      if (rawBookmarks != null && rawBookmarks.isNotEmpty) {
        final decoded = jsonDecode(rawBookmarks);

        _bookmarks
          ..clear()
          ..addAll(
            (decoded as Map<String, dynamic>).map(
              (k, v) => MapEntry(
                k,
                List<int>.from((v as List).map((e) => e as int)),
              ),
            ),
          );
      }
    } catch (e) {
      debugPrint("Load error: $e");
    }
  }

  /// ---------------------------
  /// RESET
  /// ---------------------------

  Future<void> resetProgress() async {
    if (_bookId.isEmpty) return;

    _pdfPageProgress.remove(_bookId);
    _bookmarks.remove(_bookId);

    _currentPage = 0;

    await _saveProgress();
    await _saveBookmarks();

    notifyListeners();
  }

  /// ---------------------------
  /// DISPOSE
  /// ---------------------------

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}