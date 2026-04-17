import 'package:mythica/features/library/models/library_book.dart';
import 'package:mythica/features/library/models/library_store.dart';
import 'package:mythica/features/library/widgets/library_books_grid.dart';
import 'package:mythica/features/library/widgets/library_tabs.dart';
import 'package:mythica/features/reader/screens/pdf_reader_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyLibraryScreen extends StatefulWidget {
  const MyLibraryScreen({super.key});

  @override
  State<MyLibraryScreen> createState() => _MyLibraryScreenState();
}

class _MyLibraryScreenState extends State<MyLibraryScreen> {
  int _selectedTabIndex = 0;

  List<LibraryBook> _filteredBooks(List<LibraryBook> books) {
    switch (_selectedTabIndex) {
      case 1:
        return books.where((book) => book.favorite).toList();
      case 2:
        return books.where((book) => book.progress >= 1).toList();
      default:
        return books;
    }
  }

  @override
  Widget build(BuildContext context) {
    final books = context.watch<LibraryStore>().books;
    final filteredBooks = _filteredBooks(books);
    final continueBooks = filteredBooks
        .where((book) => book.progress > 0 && book.progress < 1)
        .toList();

    final featuredBook = filteredBooks.isNotEmpty
        ? filteredBooks.first
        : (books.isNotEmpty ? books.first : null);

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverAppBar(
            backgroundColor: Colors.black,
            pinned: true,
            elevation: 0,
            title: Text(
              'My Library',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SliverToBoxAdapter(
            child: LibraryTabs(
              selectedIndex: _selectedTabIndex,
              onTabSelected: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
            ),
          ),
          if (featuredBook != null)
            SliverToBoxAdapter(
              child: _featuredBanner(context, featuredBook),
            ),
          if (continueBooks.isNotEmpty) ...[
            SliverToBoxAdapter(child: _sectionTitle('Continue Reading')),
            SliverToBoxAdapter(child: _horizontalList(context, continueBooks)),
          ],
          SliverToBoxAdapter(child: _sectionTitle('All Books')),
          SliverFillRemaining(
            hasScrollBody: true,
            child: filteredBooks.isEmpty
                ? const Center(
                    child: Text(
                      'No books found in this tab',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                : LibraryBooksGrid(books: filteredBooks),
          ),
        ],
      ),
    );
  }

  Widget _featuredBanner(BuildContext context, LibraryBook book) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PdfReaderScreen(book: book)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Hero(
          tag: book.id,
          child: Container(
            height: 260,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              image: DecorationImage(
                image: AssetImage(book.imagePath),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withValues(alpha:0.4),
                  blurRadius: 18,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: [Colors.transparent, Colors.black87],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    book.author,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _horizontalList(BuildContext context, List<LibraryBook> books) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PdfReaderScreen(book: book)),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Stack(
                children: [
                  Hero(
                    tag: book.id,
                    child: Container(
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        image: DecorationImage(
                          image: AssetImage(book.imagePath),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withValues(alpha:0.3),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (book.progress > 0)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: LinearProgressIndicator(
                        value: book.progress,
                        minHeight: 4,
                        backgroundColor: Colors.white24,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
