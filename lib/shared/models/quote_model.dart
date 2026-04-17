import 'package:cloud_firestore/cloud_firestore.dart';

class QuoteModel {
  final String id;
  final String category;
  final String quote;
  final String author;
  final String tag;
  final int likes;
  final List<String> likedBy;
  final Timestamp createdAt;

  const QuoteModel({
    required this.id,
    required this.category,
    required this.quote,
    required this.author,
    required this.tag,
    required this.likes,
    required this.likedBy,
    required this.createdAt,
  });

  /// =========================
  /// FROM FIRESTORE
  /// =========================
  factory QuoteModel.fromJson(String id, Map<String, dynamic>? json) {
    final data = json ?? {};

    final category = (data['category'] as String?)?.trim();
    final quote = (data['quote'] as String?)?.trim();
    final author = (data['author'] as String?)?.trim();
    final tag = (data['tag'] as String?)?.trim();

    final likes = (data['likes'] as num?)?.toInt() ?? 0;

    final likedBy = (data['likedBy'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        <String>[];

    final createdAt = data['createdAt'];

    return QuoteModel(
      id: id,
      category: (category != null && category.isNotEmpty)
          ? category
          : 'Emotional',
      quote: quote ?? '',
      author: (author != null && author.isNotEmpty) ? author : 'Unknown',
      tag: tag ?? '',
      likes: likes,
      likedBy: likedBy,
      createdAt: createdAt is Timestamp ? createdAt : Timestamp.now(),
    );
  }

  /// =========================
  /// TO FIRESTORE
  /// =========================
  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'quote': quote,
      'author': author,
      'tag': tag,
      'likes': likes,
      'likedBy': likedBy,
      'createdAt': createdAt,
    };
  }

  /// =========================
  /// COPY WITH
  /// =========================
  QuoteModel copyWith({
    String? id,
    String? category,
    String? quote,
    String? author,
    String? tag,
    int? likes,
    List<String>? likedBy,
    Timestamp? createdAt,
  }) {
    return QuoteModel(
      id: id ?? this.id,
      category: category ?? this.category,
      quote: quote ?? this.quote,
      author: author ?? this.author,
      tag: tag ?? this.tag,
      likes: likes ?? this.likes,
      likedBy: likedBy ?? this.likedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}