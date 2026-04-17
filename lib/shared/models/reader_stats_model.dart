class ReaderStatsModel {
  final int totalReadingSeconds;
  final int pagesRead;
  final int booksCompleted;
  final int readingStreak;
  final DateTime? lastReadAt;
  final int totalReadingTime;

  const ReaderStatsModel({
    required this.totalReadingSeconds,
    required this.pagesRead,
    required this.booksCompleted,
    required this.readingStreak,
    required this.lastReadAt,
    required this.totalReadingTime,
  });

  /// ===============================
  /// EMPTY STATE
  /// ===============================

  factory ReaderStatsModel.empty() {
    return const ReaderStatsModel(
      totalReadingSeconds: 0,
      pagesRead: 0,
      booksCompleted: 0,
      readingStreak: 0,
      lastReadAt: null,
      totalReadingTime: 0,
    );
  }

  /// ===============================
  /// COPY WITH
  /// ===============================

  ReaderStatsModel copyWith({
    int? totalReadingSeconds,
    int? pagesRead,
    int? booksCompleted,
    int? readingStreak,
    DateTime? lastReadAt,
    int? totalReadingTime,
  }) {
    return ReaderStatsModel(
      totalReadingSeconds:
          totalReadingSeconds ?? this.totalReadingSeconds,
      pagesRead: pagesRead ?? this.pagesRead,
      booksCompleted: booksCompleted ?? this.booksCompleted,
      readingStreak: readingStreak ?? this.readingStreak,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      totalReadingTime:
          totalReadingTime ?? this.totalReadingTime,
    );
  }

  /// ===============================
  /// JSON SERIALIZATION
  /// ===============================

  Map<String, dynamic> toJson() {
    return {
      'totalReadingSeconds': totalReadingSeconds,
      'pagesRead': pagesRead,
      'booksCompleted': booksCompleted,
      'readingStreak': readingStreak,
      'totalReadingTime': totalReadingTime,
      'lastReadAt': lastReadAt?.millisecondsSinceEpoch,
    };
  }

  factory ReaderStatsModel.fromJson(Map<String, dynamic> json) {
    return ReaderStatsModel(
      totalReadingSeconds:
          (json['totalReadingSeconds'] ?? 0 as num).toInt(),
      pagesRead: (json['pagesRead'] ?? 0 as num).toInt(),
      booksCompleted: (json['booksCompleted'] ?? 0 as num).toInt(),
      readingStreak: (json['readingStreak'] ?? 0 as num).toInt(),
      totalReadingTime:
          (json['totalReadingTime'] ?? 0 as num).toInt(),
      lastReadAt: json['lastReadAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              json['lastReadAt'])
          : null,
    );
  }

  /// ===============================
  /// COMPUTED PROPERTIES
  /// ===============================

  int get readingMinutes => totalReadingSeconds ~/ 60;

  int get readingHours => totalReadingSeconds ~/ 3600;

  String get formattedReadingTime {
    final hours = readingHours;
    final minutes = (totalReadingSeconds % 3600) ~/ 60;
    return "${hours}h ${minutes}m";
  }

  /// ===============================
  /// STREAK CHECK
  /// ===============================

  bool get hasReadToday {
    if (lastReadAt == null) return false;

    final now = DateTime.now();

    return now.year == lastReadAt!.year &&
        now.month == lastReadAt!.month &&
        now.day == lastReadAt!.day;
  }

  /// ===============================
  /// DEBUG
  /// ===============================

  @override
  String toString() {
    return '''
ReaderStatsModel(
  pagesRead: $pagesRead
  booksCompleted: $booksCompleted
  streak: $readingStreak
  readingTime: $formattedReadingTime
)
''';
  }
}