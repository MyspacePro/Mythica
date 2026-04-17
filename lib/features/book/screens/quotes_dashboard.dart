import 'package:mythica/features/home/mainicon/quotes_icon/models/quote_model.dart';
import 'package:mythica/features/home/mainicon/quotes_icon/provider/quotes_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuotesDashboard extends StatelessWidget {
  const QuotesDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1533),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1F1533),
              Color(0xFF2A1E47),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Consumer<QuotesProvider>(
              builder: (context, provider, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    const Text(
                      "My Quotes",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 28),

                    /// Categories
                    SizedBox(
                      height: 42,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: provider.categories.length,
                        itemBuilder: (context, index) {
                          final category = provider.categories[index];
                          final isSelected =
                              provider.selectedCategory == category;

                          return GestureDetector(
                            onTap: () => provider.changeCategory(category),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFF5C84C)
                                    : const Color(0xFF251A3F),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: const Color(0xFF3A2D5C),
                                ),
                              ),
                              child: Text(
                                category,
                                style: TextStyle(
                                  color: isSelected
                                      ? const Color(0xFF1F1533)
                                      : const Color(0xFFCFC8E8),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 25),

                    Expanded(
                      child: _buildBody(provider),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),

      /// Add Quote Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF5C84C),
        onPressed: () => _showAddQuoteBottomSheet(context),
        child: const Icon(Icons.add, color: Color(0xFF1F1533)),
      ),
    );
  }

  /// BODY
  Widget _buildBody(QuotesProvider provider) {
    if (provider.isLoading && provider.allQuotes.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFF5C84C)),
      );
    }

    if (provider.errorMessage != null && provider.allQuotes.isEmpty) {
      return Center(
        child: Text(
          provider.errorMessage!,
          style: const TextStyle(color: Colors.white70),
        ),
      );
    }

    if (provider.filteredQuotes.isEmpty) {
      return const Center(
        child: Text(
          "No Quotes Found",
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView.builder(
      itemCount: provider.filteredQuotes.length,
      itemBuilder: (context, index) {
        final quote = provider.filteredQuotes[index];
        return QuoteCard(quote: quote);
      },
    );
  }

  /// ADD QUOTE
  Future<void> _showAddQuoteBottomSheet(BuildContext context) async {
    final provider = context.read<QuotesProvider>();

    final quoteController = TextEditingController();
    final authorController = TextEditingController();
    final tagController = TextEditingController();

    String selectedCategory = provider.selectedCategory;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF251A3F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _inputField(controller: quoteController, hint: "Quote text"),
                  const SizedBox(height: 12),

                  _inputField(controller: authorController, hint: "Author"),
                  const SizedBox(height: 12),

                  _inputField(controller: tagController, hint: "Tag"),
                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    dropdownColor: const Color(0xFF251A3F),
                    style: const TextStyle(color: Colors.white),
                    decoration: _decoration("Category"),
                    items: provider.categories
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text(c),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() => selectedCategory = v);
                    },
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF5C84C),
                        foregroundColor: const Color(0xFF1F1533),
                      ),
                      onPressed: () async {
                        final quoteText = quoteController.text.trim();
                        final author = authorController.text.trim();
                        final tag = tagController.text.trim();

                        if (quoteText.isEmpty ||
                            author.isEmpty ||
                            tag.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please fill all fields"),
                            ),
                          );
                          return;
                        }

                        await provider.addQuote(
                          QuoteModel(
                            id: "",
                            category: selectedCategory,
                            quote: quoteText,
                            author: author,
                            tag: tag,
                            likes: 0,
                            likedBy: const [],
                            createdAt: Timestamp.now(),
                          ),
                        );

                        if (context.mounted) Navigator.pop(context);
                      },
                      child: const Text("Add Quote"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    quoteController.dispose();
    authorController.dispose();
    tagController.dispose();
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9F96C8)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF3A2D5C)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFF5C84C)),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      maxLines: hint == "Quote text" ? 3 : 1,
      decoration: _decoration(hint),
    );
  }
}

class QuoteCard extends StatelessWidget {
  const QuoteCard({super.key, required this.quote});

  final QuoteModel quote;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () =>
          context.read<QuotesProvider>().toggleLike(quote.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF251A3F),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFF3A2D5C)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '"${quote.quote}"',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 14),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "- ${quote.author}",
                  style: const TextStyle(
                    color: Color(0xFF9F96C8),
                  ),
                ),

                Row(
                  children: [
                    const Icon(Icons.favorite,
                        color: Color(0xFFF5C84C), size: 18),
                    const SizedBox(width: 4),
                    Text(
                      quote.likes.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}