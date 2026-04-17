import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reader_book_model.dart';

class ReaderController extends ChangeNotifier {

  /// Storage Keys
  static const _statsKey = "reader_stats";
  static const _bookProgressKey = "reader_book_progress";
  static const _streakDateKey = "reader_last_streak_date";

  late SharedPreferences _prefs;

  /// Current Book
  ReaderBookModel? _currentBook;
  String? _currentBookContent;

  String? get currentBookContent => _currentBookContent;
  set currentBookContent(String? content) {
    _currentBookContent = content;
    notifyListeners();
  }

  /// Stats
  int _pagesRead = 0;
  int _booksCompleted = 0;
  int _readingStreak = 1;
  int _readingMinutes = 0;

  /// Progress
  double _progress = 0;

  /// Last streak day
  DateTime? _lastStreakDate;

  /// Book progress map
  final Map<String, double> _bookProgress = {};

  bool _initialized = false;

  /// -------------------------
  /// Getters
  /// -------------------------

  ReaderBookModel? get currentBook => _currentBook;

  int get pagesRead => _pagesRead;

  int get booksCompleted => _booksCompleted;

  int get readingStreak => _readingStreak;

  int get readingMinutes => _readingMinutes;

  double get progress => _progress;

  Map<String, double> get bookProgress => Map.unmodifiable(_bookProgress);

  /// -------------------------
  /// Init
  /// -------------------------

  Future<void> init() async {
    if (_initialized) return;

    _prefs = await SharedPreferences.getInstance();

    await _loadStats();
    await _loadBookProgress();

    _initialized = true;
  }

  /// -------------------------
  /// Open Book
  /// -------------------------

  Future<void> openBook(ReaderBookModel book) async {
    if (!_initialized) {
      await init();
    }

    _currentBook = book;
    _progress = _bookProgress[book.id] ?? book.progress;

    notifyListeners();
  }

  /// -------------------------
  /// Update Reading Progress (Direct)
  /// -------------------------

  Future<void> updateReadingProgress({
    required String bookId,
    required double progress,
    required int pagesRead,
  }) async {

    final newProgress = progress.clamp(0.0, 100.0);

    _progress = newProgress;
    _bookProgress[bookId] = _progress;

    _pagesRead += pagesRead;

    if (_progress >= 100) _booksCompleted += 1;

    await _updateStreak();
    await _saveBookProgress();
    await _saveStats();

    notifyListeners();
  }

  /// -------------------------
  /// Update Progress (Auto)
  /// -------------------------

  Future<void> updateProgress(double progress) async {

    if (_currentBook == null) return;

    final newProgress = progress.clamp(0.0, 100.0);

    if (newProgress == _progress) return;

    final previous = _progress;

    _progress = newProgress;
    _bookProgress[_currentBook!.id] = _progress;

    /// Estimate pages
    const estimatedPages = 300;

    final prevPages = (previous / 100 * estimatedPages).floor();
    final newPages = (_progress / 100 * estimatedPages).floor();

    if (newPages > prevPages) {
      _pagesRead += (newPages - prevPages);
    }

    if (_progress >= 100 && previous < 100) {
      _booksCompleted += 1;
    }

    await _updateStreak();
    await _saveBookProgress();
    await _saveStats();

    notifyListeners();
  }

  /// -------------------------
  /// Reading Streak
  /// -------------------------

  Future<void> _updateStreak() async {

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    if (_lastStreakDate == null) {
      _readingStreak = 1;
      _lastStreakDate = todayDate;

      await _prefs.setString(
        _streakDateKey,
        todayDate.toIso8601String(),
      );
      return;
    }

    final last = DateTime(
      _lastStreakDate!.year,
      _lastStreakDate!.month,
      _lastStreakDate!.day,
    );

    final diff = todayDate.difference(last).inDays;

    if (diff == 0) return;

    if (diff == 1) {
      _readingStreak += 1;
    } else {
      _readingStreak = 1;
    }

    _lastStreakDate = todayDate;

    await _prefs.setString(
      _streakDateKey,
      todayDate.toIso8601String(),
    );
  }

  /// -------------------------
  /// Reset Stats
  /// -------------------------

  Future<void> resetStats() async {

    _pagesRead = 0;
    _booksCompleted = 0;
    _readingMinutes = 0;
    _readingStreak = 1;
    _progress = 0;

    _bookProgress.clear();

    await _prefs.remove(_statsKey);
    await _prefs.remove(_bookProgressKey);
    await _prefs.remove(_streakDateKey);

    notifyListeners();
  }

  /// -------------------------
  /// Save Stats
  /// -------------------------

  Future<void> _saveStats() async {

    final data = {
      "pagesRead": _pagesRead,
      "booksCompleted": _booksCompleted,
      "readingStreak": _readingStreak,
      "readingMinutes": _readingMinutes,
    };

    await _prefs.setString(
      _statsKey,
      jsonEncode(data),
    );
  }

  /// -------------------------
  /// Load Stats
  /// -------------------------

  Future<void> _loadStats() async {

    final raw = _prefs.getString(_statsKey);

    if (raw != null) {
      try {
        final data = jsonDecode(raw);

        _pagesRead = data["pagesRead"] ?? 0;
        _booksCompleted = data["booksCompleted"] ?? 0;
        _readingStreak = data["readingStreak"] ?? 1;
        _readingMinutes = data["readingMinutes"] ?? 0;

      } catch (_) {}
    }

    final dateRaw = _prefs.getString(_streakDateKey);

    if (dateRaw != null) {
      try {
        _lastStreakDate = DateTime.parse(dateRaw);
      } catch (_) {}
    }
  }

  /// -------------------------
  /// Save Book Progress
  /// -------------------------

  Future<void> _saveBookProgress() async {

    await _prefs.setString(
      _bookProgressKey,
      jsonEncode(_bookProgress),
    );
  }

  /// -------------------------
  /// Load Book Progress
  /// -------------------------

  Future<void> _loadBookProgress() async {

    final raw = _prefs.getString(_bookProgressKey);

    if (raw == null) return;

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;

      _bookProgress.clear();

      decoded.forEach((key, value) {
        _bookProgress[key] = (value as num).toDouble();
      });

    } catch (_) {}
  }
}