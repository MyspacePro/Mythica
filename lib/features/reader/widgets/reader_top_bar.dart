import 'package:mythica/features/reader/provider/reader_provider.dart' show ReaderProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReaderTopBar extends StatelessWidget {
  const ReaderTopBar();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReaderProvider>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: Colors.black54,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),

          Expanded(
            child: Text(
              provider.currentBook?.title ?? '',
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.white),
            onPressed: () {
              provider.toggleBookmark(
                "chapter_${provider.currentChapter}",
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.format_size, color: Colors.white),
            onPressed: () {
              _showFontDialog(context);
            },
          )
        ],
      ),
    );
  }

  void _showFontDialog(BuildContext context) {
    final provider = context.read<ReaderProvider>();

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: provider.decreaseFont,
              ),
              Text("${provider.fontSize.toInt()}"),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: provider.increaseFont,
              ),
            ],
          ),
        );
      },
    );
  }
}