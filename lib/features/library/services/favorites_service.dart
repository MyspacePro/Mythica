import 'dart:async';
import 'package:mythica/features/book/model/book_model.dart';
import 'package:mythica/features/home/mainicon/favorites_icon/models/favorite_book_model.dart' show FavoriteBookModel;


class FavoritesService {
  final List<FavoriteBookModel> _favorites = [];

  Future<List<BookModel>> getFavorites() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _favorites;
  }

  Future<void> addToFavorites(BookModel book) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final exists = _favorites.any((b) => b.id == book.id);

    if (!exists) {
      _favorites.add(FavoriteBookModel.fromBook(book));
    }
  }

  Future<void> removeFromFavorites(String bookId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _favorites.removeWhere((b) => b.id == bookId);
  }

  Future<void> clearFavorites() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _favorites.clear();
  }
}