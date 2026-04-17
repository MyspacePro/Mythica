import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ReaderBookmarkService {
  static const _storageKey = "reader_bookmarks";

  final Set<String> _bookmarks = {};
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
        _bookmarks.clear();
        _bookmarks.addAll(decoded.map((e) => e.toString()));
      } catch (_) {
        _bookmarks.clear();
      }
    }

    _initialized = true;
  }

  /// ===============================
  /// ADD BOOKMARK
  /// ===============================
  Future<void> addBookmark(String id) async {
    if (id.isEmpty) return;
    _bookmarks.add(id);
    await _save();
  }

  /// ===============================
  /// REMOVE BOOKMARK
  /// ===============================
  Future<void> removeBookmark(String id) async {
    _bookmarks.remove(id);
    await _save();
  }

  /// ===============================
  /// CHECK BOOKMARK
  /// ===============================
  bool isBookmarked(String id) {
    return _bookmarks.contains(id);
  }

  /// ===============================
  /// CLEAR ALL BOOKMARKS
  /// ===============================
  Future<void> clearBookmarks() async {
    _bookmarks.clear();
    await _save();
  }

  /// ===============================
  /// GET ALL BOOKMARKS
  /// ===============================
  Set<String> get allBookmarks => Set.unmodifiable(_bookmarks);

  /// ===============================
  /// SAVE TO STORAGE
  /// ===============================
  Future<void> _save() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setString(
      _storageKey,
      jsonEncode(_bookmarks.toList()),
    );
  }
}