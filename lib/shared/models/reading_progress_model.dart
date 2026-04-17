class ReadingProgressModel {

  /// ===============================
  /// BOOK INFO
  /// ===============================

  final String bookId;

  /// ===============================
  /// PAGE TRACKING
  /// ===============================

  final int currentPage;
  final int totalPages;

  /// ===============================
  /// PROGRESS
  /// ===============================

  final double progressPercent;

  /// ===============================
  /// READING TIME
  /// ===============================

  final int readingSeconds;

  /// ===============================
  /// LAST READ
  /// ===============================

  final DateTime? lastReadAt;

  /// ===============================
  /// COMPLETION
  /// ===============================

  final bool isCompleted;

  /// ===============================
  /// CONSTRUCTOR
  /// ===============================

  const ReadingProgressModel({
    required this.bookId,
    required this.currentPage,
    required this.totalPages,
    required this.progressPercent,
    required this.readingSeconds,
    required this.lastReadAt,
    required this.isCompleted,
  });

  /// ===============================
  /// INITIAL
  /// ===============================

  factory ReadingProgressModel.initial(String bookId) {
    return ReadingProgressModel(
      bookId: bookId,
      currentPage: 0,
      totalPages: 0,
      progressPercent: 0,
      readingSeconds: 0,
      lastReadAt: DateTime.now(),
      isCompleted: false,
    );
  }

  /// ===============================
  /// COPY WITH
  /// ===============================

  ReadingProgressModel copyWith({
    int? currentPage,
    int? totalPages,
    double? progressPercent,
    int? readingSeconds,
    DateTime? lastReadAt,
    bool? isCompleted,
  }) {
    return ReadingProgressModel(
      bookId: bookId,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      progressPercent: progressPercent ?? this.progressPercent,
      readingSeconds: readingSeconds ?? this.readingSeconds,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /// ===============================
  /// PROGRESS CALCULATION
  /// ===============================

  double calculateProgress() {
    if (totalPages == 0) return 0;
    return (currentPage / totalPages) * 100;
  }

  /// ===============================
  /// SERIALIZATION
  /// ===============================

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'progressPercent': progressPercent,
      'readingSeconds': readingSeconds,
      'lastReadAt': lastReadAt?.millisecondsSinceEpoch,
      'isCompleted': isCompleted,
    };
  }

  factory ReadingProgressModel.fromJson(Map<String, dynamic> json) {
    return ReadingProgressModel(
      bookId: json['bookId'] ?? '',
      currentPage: json['currentPage'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      progressPercent: (json['progressPercent'] ?? 0).toDouble(),
      readingSeconds: json['readingSeconds'] ?? 0,
      lastReadAt: json['lastReadAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['lastReadAt'])
          : null,
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  /// ===============================
  /// DEBUG
  /// ===============================

  @override
  String toString() {
    return '''
ReadingProgressModel(
  bookId: $bookId
  page: $currentPage / $totalPages
  progress: $progressPercent
  completed: $isCompleted
)
''';
  }
}