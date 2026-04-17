import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math' as math;

import 'package:mythica/features/home/mainicon/quotes_icon/models/quote_model.dart';
import 'package:mythica/features/home/mainicon/quotes_icon/services/quotes_service.dart';

class QuotesProvider extends ChangeNotifier {
  QuotesProvider({QuotesService? service})
      : _service = service ?? QuotesService() {
    initialize();
  }

  final QuotesService _service;

  bool isLoading = false;
  String? errorMessage;

  String selectedCategory = "Emotional";

  List<String> categories = [];
  List<QuoteModel> allQuotes = [];
  List<QuoteModel> filteredQuotes = [];

  bool _didInitialize = false;

  /// ============================
  /// 🔥 INITIALIZE DATA
  /// ============================
  Future<void> initialize() async {
    if (_didInitialize) return;
    _didInitialize = true;

    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final quotes = await _service.fetchQuotes();
      final backendCategories = await _service.fetchCategories();

      allQuotes = quotes;

      categories = {
        "Emotional",
        "Motivational",
        "Love",
        "Success",
        "Life",
        ...backendCategories
      }.toList();

      if (!categories.contains(selectedCategory) && categories.isNotEmpty) {
        selectedCategory = categories.first;
      }

      _filterQuotes();
    } catch (e) {
      debugPrint("Quotes Initialize Error: $e");
      errorMessage = "Failed to load quotes";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ============================
  /// 🔥 FETCH QUOTES
  /// ============================
  Future<void> fetchQuotes() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final quotes = await _service.fetchQuotes();
      allQuotes = quotes;

      _filterQuotes();
    } catch (e) {
      debugPrint("Fetch Quotes Error: $e");
      errorMessage = "Failed to load quotes";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ============================
  /// 🔥 FETCH CATEGORIES
  /// ============================
  Future<void> fetchCategories() async {
    try {
      final backendCategories = await _service.fetchCategories();

      categories = {
        "Emotional",
        "Motivational",
        "Love",
        "Success",
        "Life",
        ...backendCategories
      }.toList();

      notifyListeners();
    } catch (e) {
      debugPrint("Fetch Categories Error: $e");
      errorMessage = "Failed to load categories";
      notifyListeners();
    }
  }

  /// ============================
  /// 🔥 CHANGE CATEGORY
  /// ============================
  void changeCategory(String category) {
    selectedCategory = category;
    _filterQuotes();
  }

  /// ============================
  /// 🔥 ADD QUOTE
  /// ============================
  Future<void> addQuote(QuoteModel quote) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await _service.addQuote(quote);

      await fetchQuotes();
      await fetchCategories();
    } catch (e) {
      debugPrint("Add Quote Error: $e");
      errorMessage = "Failed to add quote";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ============================
  /// 🔥 LIKE / UNLIKE QUOTE
  /// ============================
  Future<void> toggleLike(String quoteId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      errorMessage = "Please login first";
      notifyListeners();
      return;
    }

    final index = allQuotes.indexWhere((q) => q.id == quoteId);

    if (index == -1) return;

    final quote = allQuotes[index];

    try {
      final isLiked = await _service.toggleLike(
        quoteId: quoteId,
        userId: userId,
      );

      final likedBy = List<String>.from(quote.likedBy);

      if (isLiked) {
        likedBy.add(userId);
      } else {
        likedBy.remove(userId);
      }

      allQuotes[index] = quote.copyWith(
        likedBy: likedBy,
        likes: isLiked ? quote.likes + 1 : math.max(quote.likes - 1, 0),
      );

      _filterQuotes();
    } catch (e) {
      debugPrint("Toggle Like Error: $e");
      errorMessage = "Unable to update like";
      notifyListeners();
    }
  }

  /// ============================
  /// 🔥 FILTER QUOTES
  /// ============================
  void _filterQuotes() {
    filteredQuotes = allQuotes.where((q) {
      final category = (q.category).toLowerCase();
      return category == selectedCategory.toLowerCase();
    }).toList();

    notifyListeners();
  }
}