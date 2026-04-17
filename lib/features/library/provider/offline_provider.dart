import 'package:mythica/features/home/mainicon/offline_icon/models/offline_book_model.dart' show OfflineBook;

class OfflineState {
  final List<OfflineBook> books;
  final bool isLoading;

  OfflineState({
    this.books = const [],
    this.isLoading = false,
  });

  double get totalStorageUsed =>
      books.fold(0, (sum, b) => sum + b.sizeInMB);

  int get totalBooks => books.length;

  double get storageProgress =>
      totalStorageUsed == 0 ? 0 : (totalStorageUsed / 500); // 500MB limit example

  OfflineState copyWith({
    List<OfflineBook>? books,
    bool? isLoading,
  }) {
    return OfflineState(
      books: books ?? this.books,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}