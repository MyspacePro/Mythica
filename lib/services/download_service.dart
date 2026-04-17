import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ReaderDownloadService {
  static const _storageKey = "reader_downloads";

  final Set<String> _downloadedBooks = {};
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
        final decoded = jsonDecode(raw) as List<dynamic>;
        _downloadedBooks.clear();
        _downloadedBooks.addAll(decoded.map((e) => e.toString()));
      } catch (_) {
        _downloadedBooks.clear();
      }
    }

    _initialized = true;
  }

  /// ===============================
  /// DOWNLOAD BOOK
  /// ===============================
  Future<void> downloadBook(String bookId) async {
    if (bookId.isEmpty) return;

    // Simulate download delay (remove or replace with real download logic)
    await Future.delayed(const Duration(seconds: 1));

    _downloadedBooks.add(bookId);
    await _save();
  }

  /// ===============================
  /// CHECK IF DOWNLOADED
  /// ===============================
  bool isDownloaded(String bookId) {
    return _downloadedBooks.contains(bookId);
  }

  /// ===============================
  /// REMOVE DOWNLOAD
  /// ===============================
  Future<void> removeDownload(String bookId) async {
    _downloadedBooks.remove(bookId);
    await _save();
  }

  /// ===============================
  /// CLEAR ALL DOWNLOADS
  /// ===============================
  Future<void> clearDownloads() async {
    _downloadedBooks.clear();
    await _save();
  }

  /// ===============================
  /// GET ALL DOWNLOADS
  /// ===============================
  Set<String> get allDownloads => Set.unmodifiable(_downloadedBooks);

  /// ===============================
  /// SAVE TO STORAGE
  /// ===============================
  Future<void> _save() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setString(
      _storageKey,
      jsonEncode(_downloadedBooks.toList()),
    );
  }
}