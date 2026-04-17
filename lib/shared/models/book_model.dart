import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mythica/models/writer_book_model.dart';

class BookModel {
  final String id;
  final String title;
  final String description;
  final String authorName;
  final String coverUrl;
  final String genre;
  final double rating;
  final int reviewCount;
  final int viewsCount;

  /// Monetization
  final bool isPaid;
  final double price;
  final double totalEarnings;

  /// Favorites / Library
  final bool isBookmarked;
  final DateTime createdAt;
  final DateTime? savedAt;
  final now = DateTime.now();

  /// Assets
  final String pdfPath;

  /// 🔁 Legacy compatibility (DO NOT REMOVE)
  String get author => authorName;
  String get cover => coverUrl;

  BookModel({
    this.id = '',
    required this.title,
    this.description = '',
    required this.authorName,
    required this.coverUrl,
    this.genre = 'General',
    this.rating = 0,
    this.reviewCount = 0,
    this.viewsCount = 0,
    this.isPaid = false,
    this.price = 0,
    this.totalEarnings = 0,
    this.isBookmarked = false,
    this.pdfPath = 'assets/original/book1.pdf',
    DateTime? createdAt,
    this.savedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // --------------------------------------------------
  // 🔥 Firestore → BookModel (DocumentSnapshot)
  // --------------------------------------------------
  factory BookModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc, {
    DateTime? savedAt,
    bool isBookmarked = false,
  }) {
    final data = doc.data() ?? {};

    final createdAtValue = data['createdAt'];

    return BookModel(
      id: doc.id,
      title: data['title']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      authorName: data['authorName']?.toString() ?? 'Unknown',
      coverUrl: data['coverUrl']?.toString() ?? 'assets/books/Book1.png',
      genre: data['genre']?.toString() ?? 'General',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (data['reviewCount'] as num?)?.toInt() ?? 0,
      viewsCount: (data['viewsCount'] as num?)?.toInt() ?? 0,
      totalEarnings: (data['totalEarnings'] as num?)?.toDouble() ?? 0.0,
      isPaid: data['isPaid'] == true,
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      pdfPath: data['pdfPath']?.toString() ??
          'assets/original/book1.pdf',
      isBookmarked: isBookmarked,
      savedAt: savedAt,
      createdAt: createdAtValue is Timestamp
          ? createdAtValue.toDate()
          : createdAtValue is DateTime
              ? createdAtValue
              : DateTime.now(),
    );
  }

  // --------------------------------------------------
  // 🔁 BookModel → Firestore
  // --------------------------------------------------
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'authorName': authorName,
      'coverUrl': coverUrl,
      'genre': genre,
      'rating': rating,
      'reviewCount': reviewCount,
      'viewsCount': viewsCount,
      'totalEarnings': totalEarnings,
      'isPaid': isPaid,
      'price': price,
      'pdfPath': pdfPath,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // --------------------------------------------------
  // 🧠 Copy helper (Favorites toggle etc.)
  // --------------------------------------------------
  BookModel copyWith({
    bool? isBookmarked,
    DateTime? savedAt,
    double? rating,
    int? viewsCount,
  }) {
    return BookModel(
      id: id,
      title: title,
      description: description,
      authorName: authorName,
      coverUrl: coverUrl,
      genre: genre,
      rating: rating ?? this.rating,
      reviewCount: reviewCount,
      viewsCount: viewsCount ?? this.viewsCount,
      isPaid: isPaid,
      price: price,
      totalEarnings: totalEarnings,
      pdfPath: pdfPath,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      savedAt: savedAt ?? this.savedAt,
      createdAt: createdAt,
    );
  }

  // --------------------------------------------------
  // ✍️ Reader → Writer bridge
  // --------------------------------------------------
  Book toWriterBook() {
    return Book(
      id: id,
      title: title,
      author: authorName,
      authorName: authorName,
      coverImage: coverUrl,
      summary: description,
      rating: rating,
      reviewCount: reviewCount,
      isPaid: isPaid,
      isPremium: isPaid,
      price: price,
      genre: genre,
      viewsCount: viewsCount,
    );
  }
}