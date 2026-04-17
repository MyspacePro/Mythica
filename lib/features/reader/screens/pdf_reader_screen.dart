import 'package:mythica/features/library/models/library_book.dart';
import 'package:mythica/features/reader/controller/pdf_reader_controller.dart';
import 'package:mythica/features/reader/provider/reader_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfReaderScreen extends StatefulWidget {
  final LibraryBook book;

  const PdfReaderScreen({
    super.key,
    required this.book,
  });

  @override
  State<PdfReaderScreen> createState() => _PdfReaderScreenState();
}

class _PdfReaderScreenState extends State<PdfReaderScreen> {
  late PdfViewerController _viewerController;

  int _totalPages = 0;
  String? _loadError;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _viewerController = PdfViewerController();
  }

  @override
  void dispose() {
    try {
      final pdfController = context.read<PdfReaderController>();
      final readerProvider = context.read<ReaderProvider>();

      readerProvider.savePdfProgress(
        bookId: widget.book.id,
        currentPage: pdfController.currentPage,
        totalPages: _totalPages,
      );
    } catch (_) {}

    _viewerController.dispose();
    super.dispose();
  }

  /// -------------------------
  /// Page Change
  /// -------------------------
  void _onPageChanged(PdfPageChangedDetails details) {
    final pdfController = context.read<PdfReaderController>();
    final readerProvider = context.read<ReaderProvider>();

    final page = details.newPageNumber - 1;

    pdfController.onPageChanged(page);

    readerProvider.savePdfProgress(
      bookId: widget.book.id,
      currentPage: page,
      totalPages: _totalPages,
    );
  }

  /// -------------------------
  /// Document Loaded
  /// -------------------------
  void _onDocumentLoaded(PdfDocumentLoadedDetails details) {
    final pdfController = context.read<PdfReaderController>();
    final readerProvider = context.read<ReaderProvider>();

    final savedPage = readerProvider.getPdfSavedPage(widget.book.id);

    setState(() {
      _totalPages = details.document.pages.count;
      _loadError = null;
    });

    pdfController.openPdf(
      bookId: widget.book.id,
      totalPages: _totalPages,
    );

    /// Resume last page
    if (savedPage > 0 && savedPage < _totalPages) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _viewerController.jumpToPage(savedPage + 1);
      });
    }
  }

  /// -------------------------
  /// Bookmark
  /// -------------------------
  void _addBookmark() {
    final pdfController = context.read<PdfReaderController>();

    pdfController.addBookmark(widget.book.id);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Bookmark added")),
    );
  }

  /// -------------------------
  /// UI
  /// -------------------------
  @override
  Widget build(BuildContext context) {
    final pdfController = context.watch<PdfReaderController>();

    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.black : Colors.white,

      appBar: AppBar(
        title: Text(widget.book.title),
        actions: [
          /// 🌙 Dark Mode
          IconButton(
            icon: Icon(
              _isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
          ),

          /// 🔖 Bookmark
          IconButton(
            icon: const Icon(Icons.bookmark_add),
            onPressed: _addBookmark,
          ),
        ],
      ),

      body: Column(
        children: [
          /// ❌ ERROR
          if (_loadError != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _loadError!,
                style: const TextStyle(color: Colors.red),
              ),
            )

          /// 📊 HEADER
          else if (_totalPages > 0)
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.book.author),
                  Text(
                    'Page ${pdfController.currentPage + 1} / $_totalPages',
                  ),
                ],
              ),
            ),

          /// 📄 PDF VIEWER
          Expanded(
            child: ColorFiltered(
              colorFilter: _isDarkMode
                  ? const ColorFilter.matrix([
                      -1, 0, 0, 0, 255,
                      0, -1, 0, 0, 255,
                      0, 0, -1, 0, 255,
                      0, 0, 0, 1, 0,
                    ])
                  : const ColorFilter.mode(
                      Colors.transparent,
                      BlendMode.dst,
                    ),
              child: SfPdfViewer.asset(
                widget.book.pdfPath,
                controller: _viewerController,

                enableDoubleTapZooming: true,
                enableTextSelection: true,
                canShowPaginationDialog: true,

                onDocumentLoaded: _onDocumentLoaded,

                onDocumentLoadFailed: (details) {
                  setState(() {
                    _loadError =
                        'Failed to load PDF: ${details.error}';
                  });
                },

                onPageChanged: _onPageChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}