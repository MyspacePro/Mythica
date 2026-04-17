class BattleBook {
  final String id;
  final String title;
  final String author;
  final double rating;
  final String image;

  BattleBook({
    required this.id,
    required this.title,
    required this.author,
    required this.rating,
    required this.image,
  });

  factory BattleBook.fromJson(Map<String, dynamic> json) {
    return BattleBook(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      rating: (json['rating'] as num).toDouble(),
      image: json['image'],
    );
  }
}