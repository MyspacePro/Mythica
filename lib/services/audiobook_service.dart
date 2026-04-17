import 'package:mythica/features/home/mainicon/Audio_book_icon/models/audiobook_model.dart' show AudioBook;



class AudioBookService {

  Future<List<AudioBook>> fetchTrendingBooks() async {

    await Future.delayed(const Duration(milliseconds: 800));

    return [
      AudioBook(
        id: "1",
        title: "Dune",
        narrator: "Scott Brick",
        image: "assets/books/Book1.png",
        rating: 4.8,
        duration: const Duration(hours: 6),
      ),
      AudioBook(
        id: "2",
        title: "Educated",
        narrator: "Julia Whelan",
        image: "assets/books/Book2.png",
        rating: 4.6,
        duration: const Duration(hours: 5),
      ),
      AudioBook(
        id: "3",
        title: "Circe",
        narrator: "Perdita Weeks",
        image: "assets/books/Book3.png",
        rating: 4.7,
        duration: const Duration(hours: 7),
      ),
    ];
  }

}