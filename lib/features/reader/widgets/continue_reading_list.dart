import 'package:flutter/material.dart';
import 'package:mythica/features/reader/models/reader_book_model.dart';

class ContinueReadingSlider extends StatelessWidget {
  final List<ReaderBookModel> books;
  final ValueChanged<ReaderBookModel> onBookTap;
  final ValueChanged<ReaderBookModel>? onBookLongPress;

  const ContinueReadingSlider({
    super.key,
    required this.books,
    required this.onBookTap,
    this.onBookLongPress,
  });

  static const double _cardWidth = 150;
  static const double _cardHeight = 230;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (books.isEmpty) {
      return SizedBox(
        height: _cardHeight,
        child: Center(
          child: Text(
            'No books to continue reading',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    return SizedBox(
      height: _cardHeight,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: books.length,
        cacheExtent: 500,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final book = books[index];

          return _BookCard(
            book: book,
            onTap: () => onBookTap(book),
            onLongPress: onBookLongPress != null
                ? () => onBookLongPress!(book)
                : null,
          );
        },
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  final ReaderBookModel book;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _BookCard({
    required this.book,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final progress =
        (book.progressPercent / 100).clamp(0.0, 1.0).toDouble();

    return SizedBox(
      width: ContinueReadingSlider._cardWidth,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// COVER
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: _BookImage(coverUrl: book.coverUrl),
                ),
              ),

              /// INFO
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),

                    /// PROGRESS BAR
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: Colors.black12,
                        valueColor: const AlwaysStoppedAnimation(
                          Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookImage extends StatelessWidget {
  final String coverUrl;

  const _BookImage({required this.coverUrl});

  @override
  Widget build(BuildContext context) {
    if (coverUrl.isEmpty) {
      return _placeholder();
    }

    final isNetwork =
        coverUrl.startsWith('http') || coverUrl.startsWith('https');

    return isNetwork
        ? Image.network(
            coverUrl,
            width: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return _placeholder();
            },
            errorBuilder: (_, __, ___) => _placeholder(),
          )
        : Image.asset(
            coverUrl,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _placeholder(),
          );
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey.shade300,
      alignment: Alignment.center,
      child: const Icon(
        Icons.menu_book,
        size: 40,
        color: Colors.white60,
      ),
    );
  }
}