  import 'package:cloud_firestore/cloud_firestore.dart';

class OfflineBook {
  final String id;
  final String title;
  final String author;
  final String filePath;
  final double sizeInMB;
  final DateTime downloadedAt;

  OfflineBook({
    required this.id,
    required this.title,
    required this.author,
    required this.filePath,
    required this.sizeInMB,
    required this.downloadedAt,
  });

  factory OfflineBook.fromMap(Map<String, dynamic> map) {
    final timestamp = map['downloadedAt'];

    return OfflineBook(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      filePath: map['filePath'] ?? '',
      sizeInMB: (map['sizeInMB'] ?? 0).toDouble(),
      downloadedAt:
          timestamp is Timestamp ? timestamp.toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'filePath': filePath,
      'sizeInMB': sizeInMB,
      'downloadedAt': downloadedAt,
    };
  }
}