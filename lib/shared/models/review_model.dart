import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  const ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.review,
    required this.likes,
    required this.likedBy,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String userName;
  final int rating;
  final String review;
  final int likes;
  final List<String> likedBy;
  final Timestamp createdAt;

  factory ReviewModel.fromJson(Map<String, dynamic> json, String id) {
    final likedByRaw = json['likedBy'];
    return ReviewModel(
      id: id,
      userId: (json['userId'] as String?) ?? '',
      userName: (json['userName'] as String?) ?? 'Anonymous',
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      review: (json['review'] as String?) ?? '',
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      likedBy: likedByRaw is List
          ? likedByRaw.map((user) => user.toString()).toList()
          : <String>[],
      createdAt: (json['createdAt'] as Timestamp?) ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'review': review,
      'likes': likes,
      'likedBy': likedBy,
      'createdAt': createdAt,
    };
  }
}
