import 'package:mythica/features/book/screen/book_detail_screen.dart';
import 'package:mythica/features/book/provider/book_provider.dart';
import 'package:mythica/features/book/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllBooksScreen extends StatefulWidget {
  const AllBooksScreen({super.key});

  @override
  State<AllBooksScreen> createState() => _AllBooksScreenState();
}

class _AllBooksScreenState extends State<AllBooksScreen> {
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookProvider>().loadBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, provider, _) {
        final books = provider.books.where((book) {
          final status = (book.status ?? '').toLowerCase();

          final canShowInReader =
              status.isEmpty || status == 'approved' || status == 'published';

          final matchesSearch =
              book.title.toLowerCase().contains(searchQuery.toLowerCase());

          return canShowInReader && matchesSearch;
        }).toList();

        return Scaffold(
          backgroundColor: const Color(0xFF0F172A),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0F172A),
            title: const Text('All Books'),
            elevation: 0,
          ),
          body: Column(
            children: [
              /// SEARCH BAR
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search books...',
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon:
                        const Icon(Icons.search, color: Colors.white54),
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) =>
                      setState(() => searchQuery = value),
                ),
              ),

              /// GRID
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : provider.error != null
                        ? Center(
                            child: Text(
                              provider.error!,
                              style:
                                  const TextStyle(color: Colors.redAccent),
                            ),
                          )
                        : books.isEmpty
                            ? const Center(
                                child: Text(
                                  'No books found',
                                  style:
                                      TextStyle(color: Colors.white70),
                                ),
                              )
                            : GridView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                physics:
                                    const BouncingScrollPhysics(),
                                itemCount: books.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 18,
                                  childAspectRatio: 0.65,
                                ),
                                itemBuilder: (context, index) {
                                  final book = books[index];

                                  return BookCard(
                                    book: book,

                                    /// 🔥 FIX HERE
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            BookDetailScreen(
                                          bookId: book.id,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
              ),
            ],
          ),
        );
      },
    );
  }
}