class ReaderStatsSummary {
  final int totalBooksRead;
  final int completedBooks;
  final int currentlyReading;
  final double averageProgress;
  const ReaderStatsSummary({required this.totalBooksRead, required this.completedBooks, required this.currentlyReading, required this.averageProgress});
  factory ReaderStatsSummary.empty() => const ReaderStatsSummary(totalBooksRead: 0, completedBooks: 0, currentlyReading: 0, averageProgress: 0);
}
