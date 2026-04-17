import 'package:mythica/features/home/mainicon/Audio_book_icon/models/audiobook_model.dart' show AudioBook;
import 'package:flutter/material.dart';
import '../services/audiobook_service.dart';

class AudioBookProvider extends ChangeNotifier {

  final AudioBookService _service = AudioBookService();

  List<AudioBook> trending = [];
  List<AudioBook> continueListening = [];

  AudioBook? featuredBook;

  bool isLoading = false;

  Future<void> loadDashboard() async {

    try {

      isLoading = true;
      notifyListeners();

      trending = await _service.fetchTrendingBooks();

      if (trending.isNotEmpty) {
        featuredBook = trending.first;
      }

      continueListening = trending.take(2).toList();

    } catch (e) {

      debugPrint("Audio dashboard error: $e");

    } finally {

      isLoading = false;
      notifyListeners();

    }

  }

  void playBook(AudioBook book) {

    featuredBook = book;

    notifyListeners();

  }

}