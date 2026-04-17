import 'package:mythica/features/home/mainicon/book_battle_icon/models/battle_book_model.dart' show BattleBook;


class BookBattleService {

  Future<List<BattleBook>> fetchBattleBooks() async {

    await Future.delayed(const Duration(milliseconds: 500));

    return [
      BattleBook(
        id: "1",
        title: "Project Hail Mary",
        author: "Andy Weir",
        rating: 4.8,
        image: "assets/books/Book1.png",
      ),
      BattleBook(
        id: "2",
        title: "The Midnight Library",
        author: "Matt Haig",
        rating: 4.7,
        image: "assets/books/Book2.png",
      ),
    ];
  }
}