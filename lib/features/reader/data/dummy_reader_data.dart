class ReaderBook {
  final String id;
  final String title;
  final String author;
  final String pdfPath;
  const ReaderBook({required this.id, required this.title, required this.author, required this.pdfPath});
}

class ReadingTask {
  final String id;
  final String title;
  bool isCompleted;
  ReadingTask({required this.id, required this.title, this.isCompleted = false});
}

class DummyReaderData {
  static const continueReading = <ReaderBook>[
    ReaderBook(id: '1', title: 'Demo Book', author: 'Author Name', pdfPath: 'assets/original/book1.pdf'),
  ];

  static final readingTasks = <ReadingTask>[
    ReadingTask(id: '1', title: 'Read 20 pages'),
  ];
}
