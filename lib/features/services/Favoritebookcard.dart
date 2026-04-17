import 'package:flutter/material.dart';
import 'package:mythica/shared/models/book_model.dart';

class FavoriteBookCard extends StatelessWidget {
  final BookModel book;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const FavoriteBookCard({super.key, required this.book, required this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(book.coverUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.black12)))),
            const SizedBox(height: 8),
            Text(book.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
