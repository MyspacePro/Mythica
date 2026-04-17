import 'package:flutter/foundation.dart';
import 'library_book.dart';

class LibraryStore extends ChangeNotifier {
  LibraryStore();
  static final LibraryStore instance = LibraryStore();

  final List<LibraryBook> _books = [];
  List<LibraryBook> get books => List.unmodifiable(_books);

  void addBook(LibraryBook book) {
    final index = _books.indexWhere((b) => b.id == book.id);
    if (index >= 0) {
      _books[index] = book;
    } else {
      _books.add(book);
    }
    notifyListeners();
    if (!identical(this, instance)) instance.addBook(book);
  }

  void removeBook(String id) {
    _books.removeWhere((b) => b.id == id);
    notifyListeners();
  }
}
