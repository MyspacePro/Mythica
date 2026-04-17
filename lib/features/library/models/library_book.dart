class LibraryBook {
  final String id;
  final String title;
  final String author;
  final String category;
  final String imagePath;
  final String pdfPath;
  final List<String> chapters;
  final double progress;
  final bool favorite;

  const LibraryBook({required this.id, required this.title, required this.author, required this.category, required this.imagePath, required this.pdfPath, this.chapters = const [], this.progress = 0, this.favorite = false});

  LibraryBook copyWith({double? progress, bool? favorite}) => LibraryBook(
    id: id, title: title, author: author, category: category, imagePath: imagePath, pdfPath: pdfPath, chapters: chapters, progress: progress ?? this.progress, favorite: favorite ?? this.favorite);
}
