import 'dart:convert';
import 'package:mythica/features/reader/models/reader_book_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ReaderThemeMode { light, dark, sepia }

class ReaderProvider extends ChangeNotifier {
  static const String _progressStoreKey = 'reader_provider_progress';
  static const String _settingsStoreKey = 'reader_provider_settings';
  static const String _bookmarksStoreKey = 'reader_provider_bookmarks';
  static const String _highlightsStoreKey = 'reader_provider_highlights';
  static const String _notesStoreKey = 'reader_provider_notes';
  static const String _downloadsStoreKey = 'reader_provider_downloads';
  static const String _pdfPageStoreKey = 'reader_provider_pdf_pages';

  /// PAGE CONTROLLER
  final PageController pageController = PageController();

  SharedPreferences? _prefs;

  /// BOOK
  ReaderBookModel? _currentBook;
  String _currentBookContent = "";

  ReaderBookModel? get currentBook => _currentBook;
  String get currentBookContent => _currentBookContent;

  /// CHAPTER
  int _currentChapter = 0;
  int _totalChapters = 0;

  int get currentChapter => _currentChapter;
  int get totalChapters => _totalChapters;

  /// UI
  bool _showControls = true;
  bool get showControls => _showControls;

  /// TTS
  bool _isSpeaking = false;
  bool get isSpeaking => _isSpeaking;

  /// SETTINGS
  double _fontSize = 18;
  bool _darkMode = false;
  bool _sepiaMode = false;

  double get fontSize => _fontSize;

  /// STORAGE
  final Map<String, double> _readingProgress = {};
  final Map<String, Set<String>> _bookmarks = {};
  final Map<String, List<String>> _highlights = {};
  final Map<String, List<String>> _notes = {};
  final Set<String> _downloads = {};
  final Map<String, int> _pdfPages = {};

  /// THEME
  ReaderThemeMode get themeMode {
    if (_darkMode) return ReaderThemeMode.dark;
    if (_sepiaMode) return ReaderThemeMode.sepia;
    return ReaderThemeMode.light;
  }

  /// PROGRESS
  double get progress {
    final id = _currentBook?.id;
    if (id == null) return 0;
    return _readingProgress[id] ?? 0;
  }

  double get progressNormalized => (progress / 100).clamp(0, 1);

  get currentBookProgress => null;

  ValueChanged<int>? get setChapter => null;

  VoidCallback? get goToPreviousChapter => null;

  int getPdfSavedPage(String bookId) => _pdfPages[bookId] ?? 0;

  /// INITIALIZE
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();

    await Future.wait([
      _loadProgress(),
      _loadSettings(),
      _loadDataStore(),
    ]);
  }

  /// LOAD BOOK
  void loadBook({
    required String bookId,
    required int totalChapters,
    int lastReadChapter = 0,
  }) {
    _totalChapters = totalChapters;

    _currentChapter =
        lastReadChapter.clamp(0, totalChapters > 0 ? totalChapters - 1 : 0);

    notifyListeners();
  }

  /// OPEN BOOK
  Future<void> openBook({
    required ReaderBookModel book,
    required String content,
  }) async {
    _currentBook = book;
    _currentBookContent = content;

    _readingProgress.putIfAbsent(book.id, () => book.progressPercent);

    final progress = _readingProgress[book.id] ?? 0;

    if (_totalChapters > 0) {
      _currentChapter =
          ((progress / 100) * _totalChapters).floor().clamp(0, _totalChapters - 1);
    }

    if (pageController.hasClients) {
      try {
        pageController.jumpToPage(_currentChapter);
      } catch (_) {}
    }

    notifyListeners();
  }

  /// PAGE CHANGE
  Future<void> onPageChanged(int index) async {
    if (index == _currentChapter) return;

    _currentChapter = index;

    final book = _currentBook;
    if (book != null) {
      await saveProgress(book.id);
    }

    notifyListeners();
  }

  /// SAVE PROGRESS
  Future<void> saveProgress(String bookId) async {
    if (_totalChapters == 0) return;

    final percent = ((_currentChapter + 1) / _totalChapters) * 100;

    _readingProgress[bookId] = percent.clamp(0, 100);

    await _saveProgress();
  }

  /// NEXT CHAPTER
  Future<void> nextChapter() async {
    if (_currentChapter >= _totalChapters - 1) return;

    _currentChapter++;

    if (pageController.hasClients) {
      pageController.jumpToPage(_currentChapter);
    }

    final book = _currentBook;
    if (book != null) {
      await saveProgress(book.id);
    }

    notifyListeners();
  }

  /// PREVIOUS CHAPTER
  Future<void> previousChapter() async {
    if (_currentChapter <= 0) return;

    _currentChapter--;

    if (pageController.hasClients) {
      pageController.jumpToPage(_currentChapter);
    }

    final book = _currentBook;
    if (book != null) {
      await saveProgress(book.id);
    }

    notifyListeners();
  }

  /// TOGGLE CONTROLS
  void toggleControls() {
    _showControls = !_showControls;
    notifyListeners();
  }

  /// BOOKMARK
  bool isBookmarked(String location) {
    final id = _currentBook?.id;
    if (id == null) return false;

    return _bookmarks[id]?.contains(location) ?? false;
  }

  Future<void> toggleBookmark(String location) async {
    final id = _currentBook?.id;
    if (id == null) return;

    final set = _bookmarks.putIfAbsent(id, () => <String>{});

    if (!set.remove(location)) {
      set.add(location);
    }

    await _saveDataStore();
    notifyListeners();
  }

  /// HIGHLIGHT
  Future<void> addHighlight(String text) async {
    final id = _currentBook?.id;
    if (id == null) return;

    final list = _highlights.putIfAbsent(id, () => []);

    if (!list.contains(text)) {
      list.add(text);
      await _saveDataStore();
      notifyListeners();
    }
  }

  /// NOTE
  Future<void> addNote(String note) async {
    final id = _currentBook?.id;
    if (id == null) return;

    final list = _notes.putIfAbsent(id, () => []);

    list.add(note);

    await _saveDataStore();
    notifyListeners();
  }

  /// DOWNLOAD
  Future<void> markDownloaded(String bookId) async {
    if (_downloads.contains(bookId)) return;

    _downloads.add(bookId);

    await _saveDataStore();
    notifyListeners();
  }

  Future<void> savePdfProgress({
    required String bookId,
    required int currentPage,
    required int totalPages,
  }) async {
    final maxPage = totalPages > 0 ? totalPages - 1 : 0;
    _pdfPages[bookId] = currentPage.clamp(0, maxPage);
    await _saveDataStore();
  }

  /// TTS
  void setSpeaking(bool value) {
    if (_isSpeaking == value) return;

    _isSpeaking = value;
    notifyListeners();
  }

  /// THEME
  Future<void> changeTheme(ReaderThemeMode mode) async {
    switch (mode) {
      case ReaderThemeMode.dark:
        _darkMode = true;
        _sepiaMode = false;
        break;

      case ReaderThemeMode.sepia:
        _sepiaMode = true;
        _darkMode = false;
        break;

      case ReaderThemeMode.light:
        _darkMode = false;
        _sepiaMode = false;
        break;
    }

    await _saveSettings();
    notifyListeners();
  }

  /// FONT
  Future<void> increaseFont() async {
    if (_fontSize >= 32) return;

    _fontSize += 2;

    await _saveSettings();
    notifyListeners();
  }

  Future<void> decreaseFont() async {
    if (_fontSize <= 14) return;

    _fontSize -= 2;

    await _saveSettings();
    notifyListeners();
  }

  /// LOAD PROGRESS
  Future<void> _loadProgress() async {
    final raw = _prefs?.getString(_progressStoreKey);

    if (raw == null || raw.isEmpty) return;

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;

      _readingProgress
        ..clear()
        ..addAll(decoded.map(
          (k, v) => MapEntry(k, (v as num).toDouble()),
        ));
    } catch (_) {}
  }

  Future<void> _saveProgress() async {
    await _prefs?.setString(
      _progressStoreKey,
      jsonEncode(_readingProgress),
    );
  }

  /// SETTINGS
  Future<void> _loadSettings() async {
    final raw = _prefs?.getString(_settingsStoreKey);

    if (raw == null || raw.isEmpty) return;

    try {
      final decoded = jsonDecode(raw);

      _fontSize = ((decoded['fontSize'] ?? 18) as num).toDouble();
      _darkMode = decoded['darkMode'] ?? false;
      _sepiaMode = decoded['sepiaMode'] ?? false;
    } catch (_) {}
  }

  Future<void> _saveSettings() async {
    await _prefs?.setString(
      _settingsStoreKey,
      jsonEncode({
        'fontSize': _fontSize,
        'darkMode': _darkMode,
        'sepiaMode': _sepiaMode,
      }),
    );
  }

  /// DATA STORE
  Future<void> _loadDataStore() async {
    try {
      final bookmarksRaw = _prefs?.getString(_bookmarksStoreKey);

      if (bookmarksRaw != null) {
        final decoded = jsonDecode(bookmarksRaw);

        _bookmarks
          ..clear()
          ..addAll(decoded.map(
            (k, v) => MapEntry(
              k,
              (v as List).map((e) => e.toString()).toSet(),
            ),
          ));
      }

      final highlightsRaw = _prefs?.getString(_highlightsStoreKey);

      if (highlightsRaw != null) {
        final decoded = jsonDecode(highlightsRaw);

        _highlights
          ..clear()
          ..addAll(decoded.map(
            (k, v) => MapEntry(
              k,
              (v as List).map((e) => e.toString()).toList(),
            ),
          ));
      }

      final notesRaw = _prefs?.getString(_notesStoreKey);

      if (notesRaw != null) {
        final decoded = jsonDecode(notesRaw);

        _notes
          ..clear()
          ..addAll(decoded.map(
            (k, v) => MapEntry(
              k,
              (v as List).map((e) => e.toString()).toList(),
            ),
          ));
      }

      final downloadsRaw = _prefs?.getString(_downloadsStoreKey);

      if (downloadsRaw != null) {
        _downloads
          ..clear()
          ..addAll(
            (jsonDecode(downloadsRaw) as List).map((e) => e.toString()),
          );
      }

      final pdfPagesRaw = _prefs?.getString(_pdfPageStoreKey);
      if (pdfPagesRaw != null) {
        _pdfPages
          ..clear()
          ..addAll(
            (jsonDecode(pdfPagesRaw) as Map<String, dynamic>).map(
              (key, value) => MapEntry(key, (value as num).toInt()),
            ),
          );
      }
    } catch (_) {}
  }

  Future<void> _saveDataStore() async {
    await _prefs?.setString(
      _bookmarksStoreKey,
      jsonEncode(_bookmarks.map((k, v) => MapEntry(k, v.toList()))),
    );

    await _prefs?.setString(
      _highlightsStoreKey,
      jsonEncode(_highlights),
    );

    await _prefs?.setString(
      _notesStoreKey,
      jsonEncode(_notes),
    );

    await _prefs?.setString(
      _downloadsStoreKey,
      jsonEncode(_downloads.toList()),
    );

    await _prefs?.setString(
      _pdfPageStoreKey,
      jsonEncode(_pdfPages),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
