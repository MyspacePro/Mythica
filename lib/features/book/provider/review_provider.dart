import 'package:mythica/features/home/mainicon/reviews_icon/models/review_model.dart';
import 'package:mythica/features/home/mainicon/reviews_icon/services/review_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReviewProvider extends ChangeNotifier {
  ReviewProvider({ReviewService? reviewService})
      : _reviewService = reviewService ?? ReviewService();

  final ReviewService _reviewService;

  bool isLoading = false;
  String? errorMessage;
  List<ReviewModel> reviews = <ReviewModel>[];
  double overallRating = 0.0;
  int totalReviews = 0;
  Map<int, double> ratingBreakdown = <int, double>{};

  int selectedStars = 0;
  final TextEditingController reviewController = TextEditingController();
  String? _loadedBookId;

  Future<void> ensureFetched(String bookId) async {
    if (_loadedBookId == bookId) {
      return;
    }
    _loadedBookId = bookId;
    await fetchReviews(bookId);
  }

  Future<void> fetchReviews(String bookId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      reviews = await _reviewService.fetchReviews(bookId);
      calculateAnalytics();
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitReview(String bookId, int rating, String reviewText) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      errorMessage = 'Please sign in to submit a review.';
      notifyListeners();
      return;
    }

    if (reviewText.trim().isEmpty) {
      errorMessage = 'Review cannot be empty.';
      notifyListeners();
      return;
    }

    if (rating <= 0) {
      errorMessage = 'Please select a rating greater than 0.';
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final review = ReviewModel(
        id: '',
        userId: user.uid,
        userName: user.displayName ?? 'Anonymous',
        rating: rating,
        review: reviewText.trim(),
        likes: 0,
        likedBy: <String>[],
        createdAt: Timestamp.now(),
      );
      await _reviewService.addReview(bookId, review);
      reviewController.clear();
      selectedStars = 0;
      await fetchReviews(bookId);
    } on FirebaseException catch (e) {
      errorMessage = e.message ?? 'Failed to submit review.';
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleLike(String bookId, String reviewId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      errorMessage = 'Please sign in to like a review.';
      notifyListeners();
      return;
    }

    errorMessage = null;
    notifyListeners();

    try {
      await _reviewService.toggleLike(bookId, reviewId, user.uid);
      await fetchReviews(bookId);
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }

  void calculateAnalytics() {
    totalReviews = reviews.length;

    if (totalReviews == 0) {
      overallRating = 0.0;
      ratingBreakdown = {for (int i = 1; i <= 5; i++) i: 0.0};
      return;
    }

    final Map<int, int> countByStar = {for (int i = 1; i <= 5; i++) i: 0};
    int totalStarsSum = 0;

    for (final review in reviews) {
      final rating = review.rating.clamp(1, 5).toInt();
      countByStar[rating] = (countByStar[rating] ?? 0) + 1;
      totalStarsSum += rating;
    }

    final rawRating = totalStarsSum / totalReviews;
    overallRating = double.parse(rawRating.toStringAsFixed(1));

    ratingBreakdown = {
      for (int star = 1; star <= 5; star++)
        star: (countByStar[star] ?? 0) / totalReviews,
    };
  }

  void setSelectedStars(int stars) {
    selectedStars = stars;
    notifyListeners();
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }
}
