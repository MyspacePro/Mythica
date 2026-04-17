import 'package:mythica/config/app_config.dart';
import 'package:mythica/data/dummy_books.dart';
import 'package:mythica/features/writer/widgets/content_moderation_service.dart';
import 'package:mythica/models/user_model.dart';
import 'package:mythica/models/writer_book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WriterProvider extends ChangeNotifier {
  WriterProvider({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  bool _isLoading = false;
  bool _isActionLoading = false;
  bool _loaded = false;

  String? _error;
  String? _writerId;

  int _followersCount = 0;

  List<Book> _writerBooks = const [];

  /// Async action tracking per book (e.g., publish, delete)
  final Map<String, bool> _bookActionLoading = {};
  final Map<String, int> _chapterCountByBook = {};

  bool get isLoading => _isLoading;
  bool get isActionLoading => _isActionLoading;
  bool get isLoaded => _loaded;
  String? get error => _error;

  int get followersCount => _followersCount;
  List<Book> get writerBooks => List.unmodifiable(_writerBooks);

  bool isBookProcessing(String bookId) => _bookActionLoading[bookId] ?? false;

  int chapterCountForBook(String bookId) => _chapterCountByBook[bookId] ?? 0;

  /// ---------- STATS ----------
  int get totalBooks => _writerBooks.length;
  double get totalEarnings =>
      _writerBooks.fold(0, (sum, book) => sum + book.totalEarnings);
  int get totalViews => _writerBooks.fold(0, (sum, book) => sum + book.viewsCount);
  double get avgRating {
    if (_writerBooks.isEmpty) return 0;
    return _writerBooks.fold<double>(0, (sum, book) => sum + book.rating) /
        _writerBooks.length;
  }

  /// ---------- CONTENT MODERATION ----------
  Future<ModerationResult> validateContentSafety({
    required String title,
    required String description,
    required String content,
  }) async {
    _isActionLoading = true;
    notifyListeners();
    try {
      return await ContentModerationService.checkContent(
        title,
        description,
        content,
      );
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  /// ---------- WRITER ACCESS CONTROL ----------
  bool canEditBook({
    required Book book,
    required AppUser? user,
  }) {
    if (user == null) return false;
    if (user.role != UserRole.writer && user.role != UserRole.admin) return false;
    if (book.authorId != user.uid) return false;

    final status = book.status?.toLowerCase();
    const blockedStatuses = ['banned', 'locked', 'under_review'];
    if (status != null && blockedStatuses.contains(status)) return false;

    return true;
  }

  /// ---------- LOAD WRITER STUDIO ----------
  Future<void> loadWriterStudio({
    required AppUser? user,
    required bool isGuest,
    bool forceRefresh = false,
  }) async {
    if (user == null || isGuest) {
      _setError('Sign in with a writer account to access this feature.');
      return;
    }
    if (user.role != UserRole.writer && user.role != UserRole.admin) {
      _setError('Switch to Writer account from Profile to access this feature.');
      return;
    }
    if (!forceRefresh && _loaded && _writerId == user.uid) return;

    _isLoading = true;
    _error = null;
    _writerId = user.uid;
    notifyListeners();

    try {
      if (isDummyMode) {
        await _loadDummyData(user);
      } else {
        await getMyBooks(user.uid);
      }
      _loaded = true;
    } catch (_) {
      _setError('Unable to load writer studio. Please try again.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _setError(String message) {
    _error = message;
    _writerBooks = const [];
    _loaded = true;
    _isLoading = false;
    notifyListeners();
  }

  /// ---------- DUMMY DATA ----------
  Future<void> _loadDummyData(AppUser user) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _writerBooks = dummyBooks.where((book) => book.authorId == user.uid).toList();
    _followersCount = user.followersCount > 0 ? user.followersCount : 128;
    for (final book in _writerBooks) {
      _chapterCountByBook[book.id] = book.chapters.length;
    }
  }

  /// ---------- FIRESTORE DATA ----------
  Future<void> getMyBooks(String authorId) async {
    final snapshot = await _firestore
        .collection('books')
        .where('authorId', isEqualTo: authorId)
        .orderBy('createdAt', descending: true)
        .get();

    _writerBooks = snapshot.docs.map(_bookFromMap).toList();

    for (final book in _writerBooks) {
      final countSnapshot = await _firestore
          .collection('chapters')
          .where('bookId', isEqualTo: book.id)
          .count()
          .get();
      _chapterCountByBook[book.id] = countSnapshot.count ?? 0;
    }

    final userDoc = await _firestore.collection('users').doc(authorId).get();
    _followersCount = (userDoc.data()?['followersCount'] as num?)?.toInt() ?? 0;
    notifyListeners();
  }

  /// ---------- BOOK PARSER ----------
  Book _bookFromMap(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data() ?? {};
    return Book(
      id: doc.id,
      title: map['title']?.toString() ?? '',
      author: map['authorName']?.toString() ?? 'Unknown',
      authorName: map['authorName']?.toString() ?? 'Unknown',
      authorId: map['authorId']?.toString() ?? '',
      coverImage: map['coverImage']?.toString() ?? 'assets/books/Book1.png',
      summary: map['summary']?.toString() ?? map['description']?.toString() ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: (map['reviewCount'] as num?)?.toInt() ?? 0,
      isPaid: map['isPaid'] == true,
      isPremium: map['isPaid'] == true,
      price: (map['price'] as num?)?.toDouble() ?? 0,
      totalEarnings: (map['totalEarnings'] as num?)?.toDouble() ?? 0,
      genre: map['genre']?.toString() ?? 'General',
      viewsCount: (map['viewsCount'] as num?)?.toInt() ?? 0,
      status: map['status']?.toString() ?? 'draft',
    );
  }

  /// ---------- WRITER CRUD ----------
  Future<String?> createBook({
    required String title,
    required String authorId,
    required String authorName,
    required String description,
    String coverImage = 'assets/books/Book1.png',
    String genre = 'General',
    bool isPremium = false,
    double price = 0,
  }) async {
    _isActionLoading = true;
    _error = null;
    notifyListeners();
    try {
      final docRef = await _firestore.collection('books').add({
        'title': title,
        'authorName': authorName,
        'authorId': authorId,
        'description': description,
        'summary': description,
        'coverImage': coverImage,
        'rating': 0,
        'reviewCount': 0,
        'isPaid': isPremium,
        'price': price,
        'totalEarnings': 0,
        'genre': genre,
        'viewsCount': 0,
        'status': 'draft',
        'createdAt': FieldValue.serverTimestamp(),
      });

      final createdBook = Book(
        id: docRef.id,
        title: title,
        author: authorName,
        authorName: authorName,
        authorId: authorId,
        coverImage: coverImage,
        summary: description,
        isPaid: isPremium,
        isPremium: isPremium,
        price: price,
        genre: genre,
        status: 'draft',
      );

      _writerBooks = [createdBook, ..._writerBooks];
      _chapterCountByBook[docRef.id] = 0;
      notifyListeners();
      return docRef.id;
    } catch (_) {
      _setError('Failed to create book.');
      return null;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  Future<void> addChapter({
    required String bookId,
    required String title,
    required String content,
    int? chapterNumber,
  }) async {
    _bookActionLoading[bookId] = true;
    _error = null;
    notifyListeners();
    try {
      final nextChapterNumber = chapterNumber ?? (chapterCountForBook(bookId) + 1);

      await _firestore.collection('chapters').add({
        'bookId': bookId,
        'title': title,
        'content': content,
        'chapterNumber': nextChapterNumber,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _chapterCountByBook[bookId] = nextChapterNumber;
      notifyListeners();
    } catch (_) {
      _setError('Failed to add chapter.');
    } finally {
      _bookActionLoading[bookId] = false;
      notifyListeners();
    }
  }

  Future<void> updateChapter({
    required String chapterId,
    required String title,
    required String content,
  }) async {
    _isActionLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _firestore.collection('chapters').doc(chapterId).update({
        'title': title,
        'content': content,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {
      _setError('Failed to update chapter.');
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitForPublish(String bookId) async {
    _bookActionLoading[bookId] = true;
    _error = null;
    notifyListeners();

    try {
      await _firestore.collection('books').doc(bookId).update({
        'status': 'pending_approval',
        'submittedAt': FieldValue.serverTimestamp(),
      });

      final index = _writerBooks.indexWhere((b) => b.id == bookId);
      if (index != -1) {
        _writerBooks[index] = _writerBooks[index].copyWith(status: 'pending_approval');
      }
      notifyListeners();
    } catch (_) {
      _setError('Failed to submit for publishing.');
    } finally {
      _bookActionLoading[bookId] = false;
      notifyListeners();
    }
  }

  Future<String> getPublishStatus(String bookId) async {
    try {
      Book? localBook;
      for (final book in _writerBooks) {
        if (book.id == bookId) {
          localBook = book;
          break;
        }
      }
      if (localBook?.status != null && localBook!.status!.isNotEmpty) {
        return localBook.status!;
      }

      final snapshot = await _firestore.collection('books').doc(bookId).get();
      final status = snapshot.data()?['status']?.toString() ?? 'draft';

      final index = _writerBooks.indexWhere((b) => b.id == bookId);
      if (index != -1) {
        _writerBooks[index] = _writerBooks[index].copyWith(status: status);
      }
      notifyListeners();

      return status;
    } catch (_) {
      return 'draft';
    }
  }

  /// ---------- ADMIN FLOW ----------
  Future<List<Book>> getPendingBooks() async {
    final snapshot = await _firestore
        .collection('books')
        .where('status', isEqualTo: 'pending_approval')
        .orderBy('submittedAt', descending: false)
        .get();

    return snapshot.docs.map(_bookFromMap).toList();
  }

  Future<void> approveBook(String bookId) async {
    await _firestore.collection('books').doc(bookId).update({
      'status': 'approved',
      'approvedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> publishBook(String bookId) async {
    _bookActionLoading[bookId] = true;
    notifyListeners();
    try {
      await _firestore.collection('books').doc(bookId).update({
        'status': 'published',
        'publishedAt': FieldValue.serverTimestamp(),
      });
      final index = _writerBooks.indexWhere((b) => b.id == bookId);
      if (index != -1) {
        _writerBooks[index] = _writerBooks[index].copyWith(status: 'published');
      }
      notifyListeners();
    } catch (_) {
      _setError('Failed to publish book.');
    } finally {
      _bookActionLoading[bookId] = false;
      notifyListeners();
    }
  }

  Future<void> rejectBook(String bookId, {String reason = ''}) async {
    await _firestore.collection('books').doc(bookId).update({
      'status': 'rejected',
      'rejectionReason': reason,
      'rejectedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateBook(String bookId, Map<String, dynamic> newData) async {
    _bookActionLoading[bookId] = true;
    notifyListeners();
    try {
      await _firestore.collection('books').doc(bookId).update(newData);
      final index = _writerBooks.indexWhere((b) => b.id == bookId);
      if (index != -1) {
        _writerBooks[index] = _writerBooks[index].copyWithMap(newData);
      }
      notifyListeners();
    } catch (_) {
      _setError('Failed to update book.');
    } finally {
      _bookActionLoading[bookId] = false;
      notifyListeners();
    }
  }

  Future<void> deleteBook(String bookId) async {
    _bookActionLoading[bookId] = true;
    notifyListeners();
    try {
      await _firestore.collection('books').doc(bookId).delete();
      _writerBooks = _writerBooks.where((b) => b.id != bookId).toList();
      _chapterCountByBook.remove(bookId);
      notifyListeners();
    } catch (_) {
      _setError('Failed to delete book.');
    } finally {
      _bookActionLoading[bookId] = false;
      notifyListeners();
    }
  }

  /// ---------- ANALYTICS ----------
  Map<String, dynamic> bookAnalytics(String bookId) {
    final book = _writerBooks.firstWhere(
      (b) => b.id == bookId,
      orElse: Book.empty,
    );
    return {
      'views': book.viewsCount,
      'earnings': book.totalEarnings,
      'rating': book.rating,
    };
  }
}
