import 'dart:async';
import 'package:flutter/material.dart';
import '../engine/progress_engine.dart';

class ReadingSessionController extends ChangeNotifier {

  final ProgressEngine _progressEngine = ProgressEngine();

  /// Current book
  String? _bookId;

  /// Reading progress (0 → 1)
  double _progress = 0;

  /// Session timer
  Timer? _sessionTimer;

  /// Total reading seconds
  int _readingSeconds = 0;

  /// Scroll values
  double _scroll = 0;
  double _maxScroll = 1;

  /// ===============================
  /// GETTERS
  /// ===============================

  double get progress => _progress;
  int get readingSeconds => _readingSeconds;
  String? get bookId => _bookId;

  /// ===============================
  /// START READING SESSION
  /// ===============================

  void startSession(String bookId) {

    /// If same book already active, ignore
    if (_bookId == bookId && _sessionTimer != null) return;

    endSession();

    _bookId = bookId;
    _readingSeconds = 0;

    _sessionTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        _readingSeconds++;
      },
    );
  }

  /// ===============================
  /// UPDATE SCROLL
  /// ===============================

  void updateScroll(double scroll, double maxScroll) {

    _scroll = scroll;
    _maxScroll = maxScroll <= 0 ? 1 : maxScroll;

    final double calculated = _progressEngine.calculateScrollProgress(
  scroll: _scroll,
  maxScroll: _maxScroll,);

    final double newProgress = (calculated).clamp(0.0, 1.0).toDouble();

    /// Avoid unnecessary rebuilds
    if (newProgress == _progress) return;

    _progress = newProgress;

    notifyListeners();
  }

  /// ===============================
  /// END SESSION
  /// ===============================

  void endSession() {
    _sessionTimer?.cancel();
    _sessionTimer = null;
  }

  /// ===============================
  /// RESET SESSION
  /// ===============================

  void resetSession() {

    endSession();

    _progress = 0;
    _readingSeconds = 0;
    _scroll = 0;
    _maxScroll = 1;
    _bookId = null;

    notifyListeners();
  }

  /// ===============================
  /// SESSION DATA
  /// ===============================

  Map<String, dynamic> getSessionData() {
    return {
      "bookId": _bookId,
      "progress": _progress,
      "readingSeconds": _readingSeconds,
      "scroll": _scroll,
      "maxScroll": _maxScroll,
    };
  }

  /// ===============================
  /// DISPOSE
  /// ===============================

  @override
  void dispose() {
    endSession();
    super.dispose();
  }
}

extension on Object {
}