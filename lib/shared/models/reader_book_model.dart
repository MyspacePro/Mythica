import 'package:cloud_firestore/cloud_firestore.dart';

class ReaderBookModel {
  final String id;
  final String title;
  final String description;
  final String authorName;
  final String coverUrl;
  final String genre;
  final double rating;
  final int totalChapters;
  final int lastReadChapter;
  final double progressPercent;
  final int viewsCount;
  final bool isBookmarked;
  final DateTime? lastReadAt;

  const ReaderBookModel({
    required this.id,
    required this.title,
    required this.description,
    required this.authorName,
    required this.coverUrl,
    required this.genre,
    required this.rating,
    required this.totalChapters,
    required this.lastReadChapter,
    required this.progressPercent,
    required this.viewsCount,
    required this.isBookmarked,
    required this.lastReadAt,
  });

  /// ==============================
  /// READER ENGINE PROGRESS
  /// ==============================

  double get progress => progressPercent;

  /// ==============================
  /// COPY WITH
  /// ==============================

  ReaderBookModel copyWith({
    String? id,
    String? title,
    String? description,
    String? authorName,
    String? coverUrl,
    String? genre,
    double? rating,
    int? totalChapters,
    int? lastReadChapter,
    double? progressPercent,
    int? viewsCount,
    bool? isBookmarked,
    DateTime? lastReadAt,
  }) {
    return ReaderBookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      authorName: authorName ?? this.authorName,
      coverUrl: coverUrl ?? this.coverUrl,
      genre: genre ?? this.genre,
      rating: rating ?? this.rating,
      totalChapters: totalChapters ?? this.totalChapters,
      lastReadChapter: lastReadChapter ?? this.lastReadChapter,
      progressPercent: progressPercent ?? this.progressPercent,
      viewsCount: viewsCount ?? this.viewsCount,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      lastReadAt: lastReadAt ?? this.lastReadAt,
    );
  }

  /// ==============================
  /// FIRESTORE FACTORY
  /// ==============================

  factory ReaderBookModel.fromFirestore({
    required String id,
    required Map<String, dynamic> bookData,
    Map<String, dynamic>? progressData,
    bool isBookmarked = false,
  }) {
    final int totalChapters = (bookData['totalChapters'] ?? 0) as int;
    final int lastReadChapter = (progressData?['lastReadChapter'] ?? 0) as int;

    final dynamic progressValue = progressData?['progressPercent'];

    final double progressPercent = progressValue is num
        ? progressValue.toDouble()
        : _calculateProgress(
            lastReadChapter: lastReadChapter,
            totalChapters: totalChapters,
          );

    return ReaderBookModel(
      id: id,
      title: bookData['title'] ?? '',
      description: bookData['description'] ?? '',
      authorName: bookData['authorName'] ?? '',
      coverUrl: bookData['coverUrl'] ?? '',
      genre: bookData['genre'] ?? '',
      rating: (bookData['rating'] ?? 0).toDouble(),
      totalChapters: totalChapters,
      lastReadChapter: lastReadChapter,
      progressPercent: progressPercent,
      viewsCount: (bookData['viewsCount'] ?? 0) as int,
      isBookmarked: isBookmarked,
      lastReadAt: _parseTimestamp(progressData?['lastReadAt']),
    );
  }

  /// ==============================
  /// BOOK JSON (DATABASE WRITE)
  /// ==============================

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'authorName': authorName,
      'coverUrl': coverUrl,
      'genre': genre,
      'rating': rating,
      'totalChapters': totalChapters,
      'viewsCount': viewsCount,
    };
  }

  /// ==============================
  /// READING PROGRESS JSON
  /// ==============================

  Map<String, dynamic> progressJson() {
    return {
      'lastReadChapter': lastReadChapter,
      'progressPercent': progressPercent,
      'lastReadAt': lastReadAt,
    };
  }

  /// ==============================
  /// UTILITIES
  /// ==============================

  static double _calculateProgress({
    required int lastReadChapter,
    required int totalChapters,
  }) {
    if (totalChapters <= 0) return 0;

    return ((lastReadChapter / totalChapters) * 100)
        .clamp(0, 100)
        .toDouble();
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return null;
  }
}