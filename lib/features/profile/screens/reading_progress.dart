class ReadingProgress {
  final String bookId;
  final int lastPage;
  final DateTime updatedAt;

  const ReadingProgress({
    required this.bookId,
    required this.lastPage,
    required this.updatedAt,
  });

  factory ReadingProgress.initial({
    required String bookId,
  }) {
    return ReadingProgress(
      bookId: bookId,
      lastPage: 0,
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'lastPage': lastPage,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ReadingProgress.fromJson(Map<String, dynamic> json) {
    return ReadingProgress(
      bookId: (json['bookId'] ?? '') as String,
      lastPage: (json['lastPage'] ?? 0) as int,
      updatedAt: DateTime.tryParse((json['updatedAt'] ?? '') as String) ??
          DateTime.now(),
    );
  }

  ReadingProgress copyWith({
    int? lastPage,
    DateTime? updatedAt,
  }) {
    return ReadingProgress(
      bookId: bookId,
      lastPage: lastPage ?? this.lastPage,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
