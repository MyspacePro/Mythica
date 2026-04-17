import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NoteModel {
  final String id;
  final String bookId;
  final int page;
  final String content;
  final DateTime createdAt;

  NoteModel({
    required this.id,
    required this.bookId,
    required this.page,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'page': page,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'],
      bookId: json['bookId'],
      page: json['page'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class ReaderNoteService {
  static const _storageKey = "reader_notes";

  final Map<String, List<NoteModel>> _notes = {};
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
        _notes.clear();
        decoded.forEach((bookId, list) {
          _notes[bookId] =
              (list as List).map((e) => NoteModel.fromJson(e)).toList();
        });
      } catch (_) {
        _notes.clear();
      }
    }

    _initialized = true;
  }

  /// ===============================
  /// ADD NOTE
  /// ===============================
  Future<void> addNote({
    required String bookId,
    required int page,
    required String content,
  }) async {
    if (bookId.isEmpty || content.isEmpty) return;

    _notes.putIfAbsent(bookId, () => []);

    final note = NoteModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      bookId: bookId,
      page: page,
      content: content,
      createdAt: DateTime.now(),
    );

    _notes[bookId]!.add(note);
    await _save();
  }

  /// ===============================
  /// GET NOTES FOR BOOK
  /// ===============================
  List<NoteModel> getNotes(String bookId) {
    return List.unmodifiable(_notes[bookId] ?? []);
  }

  /// ===============================
  /// GET NOTES FOR SPECIFIC PAGE
  /// ===============================
  List<NoteModel> getPageNotes(String bookId, int page) {
    final list = _notes[bookId];
    if (list == null) return [];
    return list.where((n) => n.page == page).toList();
  }

  /// ===============================
  /// DELETE NOTE
  /// ===============================
  Future<void> deleteNote(String bookId, String noteId) async {
    final list = _notes[bookId];
    if (list == null) return;

    list.removeWhere((n) => n.id == noteId);
    await _save();
  }

  /// ===============================
  /// CLEAR NOTES FOR BOOK
  /// ===============================
  Future<void> clearBookNotes(String bookId) async {
    _notes.remove(bookId);
    await _save();
  }

  /// ===============================
  /// TOTAL NOTES COUNT
  /// ===============================
  int getNoteCount(String bookId) {
    return _notes[bookId]?.length ?? 0;
  }

  /// ===============================
  /// SAVE TO STORAGE
  /// ===============================
  Future<void> _save() async {
    _prefs ??= await SharedPreferences.getInstance();

    final data = _notes.map((key, value) =>
        MapEntry(key, value.map((e) => e.toJson()).toList()));

    await _prefs!.setString(_storageKey, jsonEncode(data));
  }
}