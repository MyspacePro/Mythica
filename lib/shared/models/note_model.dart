class NoteModel {
  final String id;
  final String bookId;
  final String text;
  final DateTime createdAt;

  const NoteModel({
    required this.id,
    required this.bookId,
    required this.text,
    required this.createdAt,
  });

  /// Quick constructor for creating new notes
  factory NoteModel.create({
    required String bookId,
    required String text,
  }) {
    return NoteModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      bookId: bookId,
      text: text,
      createdAt: DateTime.now(),
    );
  }

  /// Convert to JSON (for database / API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create from JSON
  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as String,
      bookId: json['bookId'] as String,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  /// Copy object with modifications
  NoteModel copyWith({
    String? id,
    String? bookId,
    String? text,
    DateTime? createdAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}