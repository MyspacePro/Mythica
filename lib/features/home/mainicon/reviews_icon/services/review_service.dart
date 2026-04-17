import 'package:mythica/shared/models/review_model.dart';

class ReviewService {
  final Map<String, List<ReviewModel>> _store = {};
  Future<List<ReviewModel>> fetchReviews(String bookId) async => List<ReviewModel>.from(_store[bookId] ?? const []);
  Future<void> addReview(String bookId, ReviewModel review) async {
    final list = _store.putIfAbsent(bookId, () => []);
    list.add(review);
  }
  Future<void> toggleLike(String bookId, String reviewId, String userId) async {}
}
