class AudioBook {
  final String id;
  final String title;
  final String narrator;
  final String image;
  final double rating;
  final Duration duration;
  final double progress;

  AudioBook({
    required this.id,
    required this.title,
    required this.narrator,
    required this.image,
    required this.rating,
    required this.duration,
    this.progress = 0,
  });

  factory AudioBook.fromJson(Map<String, dynamic> json) {
    return AudioBook(
      id: json['id'],
      title: json['title'],
      narrator: json['narrator'],
      image: json['image'],
      rating: (json['rating'] as num).toDouble(),
      duration: Duration(minutes: json['duration']),
      progress: (json['progress'] ?? 0).toDouble(),
    );
  }
}