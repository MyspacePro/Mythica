import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ReaderProgressService {
  static const _storageKey = "reader_progress";

  final Map<String, double> _progressMap = {}; // bookId -> progress %
  SharedPreferences? _prefs;
  bool _initialized = false;

  /// ===============================
  /// INITIALIZE SERVICE
  /// ===============================
  Future<void> init() async {
    if (_initialized) return;

    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs!.getString(_storageKey);

    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        _progressMap.clear();
        decoded.forEach((bookId, value) {
          _progressMap[bookId] = (value as num).toDouble();
        });
      } catch (_) {
        _progressMap.clear();
      }
    }

    _initialized = true;
  }

  /// ===============================
  /// GET PROGRESS
  /// ===============================
  double getProgress(String bookId) {
    return _progressMap[bookId] ?? 0.0;
  }

  double getProgressNormalized(String bookId) {
    return (getProgress(bookId) / 100).clamp(0.0, 1.0);
  }

  /// ===============================
  /// UPDATE PROGRESS
  /// ===============================
  Future<void> updateProgress(String bookId, double progress) async {
    if (bookId.isEmpty) return;

    final clamped = progress.clamp(0.0, 100.0).toDouble();

    if (_progressMap[bookId] == clamped) return;

    _progressMap[bookId] = clamped;
    await _save();
  }

  /// ===============================
  /// INCREMENT / NEXT CHAPTER OR PAGE
  /// ===============================
  Future<void> incrementProgress(String bookId, double increment) async {
    final current = getProgress(bookId);
    await updateProgress(bookId, current + increment);
  }

  /// ===============================
  /// CHECK COMPLETION
  /// ===============================
  bool isBookCompleted(String bookId) {
    return getProgress(bookId) >= 100.0;
  }

  /// ===============================
  /// RESET PROGRESS
  /// ===============================
  Future<void> resetProgress(String bookId) async {
    _progressMap.remove(bookId);
    await _save();
  }

  Future<void> resetAllProgress() async {
    _progressMap.clear();
    await _save();
  }

  /// ===============================
  /// SAVE TO STORAGE
  /// ===============================
  Future<void> _save() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setString(_storageKey, jsonEncode(_progressMap));
  }
}