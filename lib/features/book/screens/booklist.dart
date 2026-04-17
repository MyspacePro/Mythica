import 'package:mythica/features/library/models/library_book.dart';

/// 📚 Library Data Source (Demo + Future API Ready)
class LibraryData {
  LibraryData._(); // 🔒 prevent instance

  /// 🔥 DEMO BOOKS (fallback only)
  static final List<LibraryBook> _demoBooks = [
    LibraryBook(
      id: "1",
      title: "Demo Book",
      author: "Author Name",
      category: "Story",
      imagePath: "assets/books/book1.png",
      pdfPath: "assets/original/book1.pdf",
      chapters: const [],
    ),
    LibraryBook(
      id: "2",
      title: "Second Book",
      author: "Writer",
      category: "Motivation",
      imagePath: "assets/books/book2.png",
      pdfPath: "assets/original/book2.pdf",
      chapters: const [],
    ),
  ];

  /// ✅ Public getter (safe access)
  static List<LibraryBook> get demoBooks => List.unmodifiable(_demoBooks);

  /// 🔍 Get book by ID
  static LibraryBook? getById(String id) {
    try {
      return _demoBooks.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  /// ➕ Add book (for local testing / dev)
  static void addBook(LibraryBook book) {
    _demoBooks.add(book);
  }

  /// ❌ Remove book
  static void removeBook(String id) {
    _demoBooks.removeWhere((b) => b.id == id);
  }

  /// 🔄 Replace all (useful for API sync)
  static void replaceAll(List<LibraryBook> books) {
    _demoBooks
      ..clear()
      ..addAll(books);
  }

  /// 📊 Check empty
  static bool get isEmpty => _demoBooks.isEmpty;
}