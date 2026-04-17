import 'package:mythica/features/book/provider/book_provider.dart';
import 'package:mythica/core/utils/responsive_helper.dart';
import 'package:mythica/core/utils/asset_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeaturedBooks extends StatelessWidget {
  const FeaturedBooks({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, provider, _) {
        final books = provider.books.take(10).toList();
        
        // Responsive dimensions
        final screenWidth = MediaQuery.of(context).size.width;
        final isMobile = context.isMobile;
        final isTablet = context.isTablet;

        // Responsive sizes
        late final double itemWidth;
        late final double itemHeight;
        late final double containerHeight;
        late final double textSize;

        if (isMobile) {
          itemWidth = screenWidth * 0.35;
          itemHeight = itemWidth * 1.4;
          containerHeight = itemHeight + 60;
          textSize = 12;
        } else if (isTablet) {
          itemWidth = screenWidth * 0.25;
          itemHeight = itemWidth * 1.4;
          containerHeight = itemHeight + 70;
          textSize = 13;
        } else {
          // Desktop
          itemWidth = 160;
          itemHeight = 220;
          containerHeight = itemHeight + 80;
          textSize = 14;
        }

        if (provider.isLoading) {
          return SizedBox(
            height: containerHeight,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (books.isEmpty) {
          return SizedBox(
            height: containerHeight,
            child: const Center(
              child: Text('No featured books available'),
            ),
          );
        }

        return SizedBox(
          height: containerHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: books.length,
            separatorBuilder: (_, __) => SizedBox(
              width: isMobile ? 12 : 16,
            ),
            itemBuilder: (context, index) {
              final book = books[index];

              return GestureDetector(
                onTap: () {
                  // TODO: Navigate to book detail
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Book Cover Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AssetHelper.loadImage(
                        assetPath: book.coverImage,
                        width: itemWidth,
                        height: itemHeight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    SizedBox(height: isMobile ? 6 : 8),

                    // Book Title
                    SizedBox(
                      width: itemWidth,
                      child: Text(
                        book.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: textSize,
                          color: const Color(0xFFE2E2E5),
                        ),
                      ),
                    ),
                    SizedBox(height: isMobile ? 3 : 4),

                    // Author Name
                    SizedBox(
                      width: itemWidth,
                      child: Text(
                        book.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: textSize - 1,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}