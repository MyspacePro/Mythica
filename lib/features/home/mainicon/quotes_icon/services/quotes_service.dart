import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mythica/shared/models/quote_model.dart';

class QuotesService {
  final List<QuoteModel> _quotes = [
    QuoteModel(id: 'q1', category: 'Motivational', quote: 'Keep going.', author: 'Unknown', tag: 'motivation', likes: 0, likedBy: const [], createdAt: Timestamp.now()),
  ];
  Future<List<QuoteModel>> fetchQuotes() async => List<QuoteModel>.from(_quotes);
  Future<List<String>> fetchCategories() async => _quotes.map((e) => e.category).toSet().toList();
  Future<void> addQuote(QuoteModel quote) async => _quotes.add(quote);
  Future<bool> toggleLike({required String quoteId, required String userId}) async => true;
}
