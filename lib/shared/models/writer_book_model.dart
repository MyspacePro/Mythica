class Book {
  /// 🔑 Unique ID
  final String id;

  final String title;
  final String author;
  final String coverImage;
  final String summary;
  final String? status;

  /// Backend ready fields
  final String authorId;
  final String authorName;

  final double rating;
  final int reviewCount;

  final bool isPaid;
  final bool isPremium;

  final double price;
  final double totalEarnings;

  final String genre;
  final int viewsCount;
  final String pdfPath;

  /// Reader Compatibility
  final List<String> chapters;

  /// Analytics / Tracking
  final int totalReads;
  final int likes;

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? writerActivatedAt;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverImage,
    required this.summary,
    this.status,
    this.authorId = '',
    this.authorName = '',
    this.rating = 0.0,
    this.reviewCount = 0,

    this.isPaid = false,
    this.isPremium = false,
    this.price = 0,
    this.totalEarnings = 0,
    this.genre = 'General',
    this.viewsCount = 0,
    this.pdfPath = 'assets/original/book1.pdf',
    this.chapters = const [],
    this.totalReads = 0,
    this.likes = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.writerActivatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Empty placeholder (for provider initial state)
  factory Book.empty() {
    return Book(
      id: '',
      title: '',
      author: '',
      coverImage: '',
      summary: '',
    );
  }

  /// Backward compatibility
  String get description => summary;

  /// ---------------------------------------------------------
  /// COPY WITH
  /// ---------------------------------------------------------

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? coverImage,
    String? summary,
    String? status,
    String? authorId,
    String? authorName,
    double? rating,
    int? reviewCount,
    bool? isPaid,
    bool? isPremium,
    double? price,
    double? totalEarnings,
    String? genre,
    int? viewsCount,
    String? pdfPath,
    List<String>? chapters,
    int? totalReads,
    int? likes,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? writerActivatedAt,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      coverImage: coverImage ?? this.coverImage,
      summary: summary ?? this.summary,
      status: status ?? this.status,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isPaid: isPaid ?? this.isPaid,
      isPremium: isPremium ?? this.isPremium,
      price: price ?? this.price,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      genre: genre ?? this.genre,
      viewsCount: viewsCount ?? this.viewsCount,
      pdfPath: pdfPath ?? this.pdfPath,
      chapters: chapters ?? this.chapters,
      totalReads: totalReads ?? this.totalReads,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      writerActivatedAt: writerActivatedAt ?? this.writerActivatedAt,
    );
  }

  /// ---------------------------------------------------------
  /// COPY WITH MAP (Firestore partial updates)
  /// ---------------------------------------------------------

  Book copyWithMap(Map<String, dynamic> map) {
    return copyWith(
      id: map['id'] as String?,
      title: map['title'] as String?,
      author: map['author'] as String?,
      coverImage: map['coverImage'] as String?,
      summary: map['summary'] as String?,
      status: map['status'] as String?,
      authorId: map['authorId'] as String?,
      authorName: map['authorName'] as String?,
      rating: (map['rating'] as num?)?.toDouble(),
      reviewCount: map['reviewCount'] as int?,
      isPaid: map['isPaid'] as bool?,
      isPremium: map['isPremium'] as bool?,
      price: (map['price'] as num?)?.toDouble(),
      totalEarnings: (map['totalEarnings'] as num?)?.toDouble(),
      genre: map['genre'] as String?,
      viewsCount: map['viewsCount'] as int?,
      pdfPath: map['pdfPath'] as String?,
      chapters: (map['chapters'] as List?)?.map((e) => e.toString()).toList(),
      totalReads: map['totalReads'] as int?,
      likes: map['likes'] as int?,
    );
  }

  /// ---------------------------------------------------------
  /// MAP → OBJECT
  /// ---------------------------------------------------------

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      coverImage: map['coverImage'] ?? '',
      summary: map['summary'] ?? '',
      status: map['status'],
      authorId: map['authorId'] ?? '',
      authorName: map['authorName'] ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: map['reviewCount'] ?? 0,
      isPaid: map['isPaid'] ?? false,
      isPremium: map['isPremium'] ?? false,
      price: (map['price'] as num?)?.toDouble() ?? 0,
      totalEarnings: (map['totalEarnings'] as num?)?.toDouble() ?? 0,
      genre: map['genre'] ?? 'General',
      viewsCount: map['viewsCount'] ?? 0,
      pdfPath: map['pdfPath'] ?? 'assets/original/book1.pdf',
      chapters: List<String>.from(map['chapters'] ?? []),
      totalReads: map['totalReads'] ?? 0,
      likes: map['likes'] ?? 0,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt']) ?? DateTime.now()
          : DateTime.now(),
      writerActivatedAt: map['writerActivatedAt'] != null
          ? DateTime.tryParse(map['writerActivatedAt'])
          : null,
    );
  }

  /// ---------------------------------------------------------
  /// OBJECT → MAP
  /// ---------------------------------------------------------

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'coverImage': coverImage,
      'summary': summary,
      'status': status,
      'authorId': authorId,
      'authorName': authorName,
      'rating': rating,
      'reviewCount': reviewCount,
      'isPaid': isPaid,
      'isPremium': isPremium,
      'price': price,
      'totalEarnings': totalEarnings,
      'genre': genre,
      'viewsCount': viewsCount,
      'pdfPath': pdfPath,
      'chapters': chapters,
      'totalReads': totalReads,
      'likes': likes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'writerActivatedAt': writerActivatedAt?.toIso8601String(),
    };
  }
}
