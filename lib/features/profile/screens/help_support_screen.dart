import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _searchController = TextEditingController();

  int expandedIndex = -1;

  final List<Map<String, String>> faqs = [
    {
      "question": "How do I reset my password?",
      "answer":
          "Go to Settings > Account > Reset Password. You will receive an email link."
    },
    {
      "question": "What payment methods are accepted?",
      "answer":
          "We accept Credit Card, Debit Card, UPI, PayPal and Google Pay."
    },
    {
      "question": "How to read downloaded books?",
      "answer":
          "Open Offline Vault from home screen to access downloaded books."
    },
  ];

  List<Map<String, String>> filteredFaqs = [];

  @override
  void initState() {
    super.initState();
    filteredFaqs = faqs;

    _searchController.addListener(() {
      filterFAQs();
    });
  }

  void filterFAQs() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      filteredFaqs = faqs
          .where((faq) =>
              faq["question"]!.toLowerCase().contains(query) ||
              faq["answer"]!.toLowerCase().contains(query))
          .toList();
    });
  }

  void toggleFAQ(int index) {
    setState(() {
      expandedIndex = expandedIndex == index ? -1 : index;
    });
  }

  /// CHAT SUPPORT
  void chatWithSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Opening live chat soon...")),
    );
  }

  /// EMAIL SUPPORT
  Future<void> emailSupport() async {
    final Uri email = Uri(
      scheme: 'mailto',
      path: 'support@yourapp.com',
      query: 'subject=App Support&body=Describe your issue',
    );

    if (await canLaunchUrl(email)) {
      await launchUrl(email);
    }
  }

  /// OPEN URL
  Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  /// CATEGORY NAVIGATION
  void openCategory(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$title help coming soon")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1533),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// HEADER
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Help & Support",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                const Text(
                  "How can we help you today?",
                  style: TextStyle(color: Color(0xFFCFC8E8)),
                ),

                const SizedBox(height: 25),

                /// SEARCH BAR
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF251A3F),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: const Color(0xFF3A2D5C)),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      icon: Icon(Icons.search,
                          color: Color(0xFFCFC8E8)),
                      hintText: "Search help topics...",
                      hintStyle:
                          TextStyle(color: Color(0xFF9F96C8)),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// QUICK HELP
                const Text(
                  "Quick Help Categories",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 18),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _categoryCard(Icons.person, "Account Issues"),
                    _categoryCard(Icons.book, "Reading Help"),
                    _categoryCard(Icons.payment, "Payments & Premium"),
                    _categoryCard(Icons.edit, "Writer Dashboard Help"),
                  ],
                ),

                const SizedBox(height: 30),

                /// FAQ
                const Text(
                  "FAQs",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 15),

                Column(
                  children: List.generate(
                    filteredFaqs.length,
                    (index) => _faqTile(
                      index,
                      filteredFaqs[index]["question"]!,
                      filteredFaqs[index]["answer"]!,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// CONTACT SUPPORT
                const Text(
                  "Contact Support",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 18),

                _goldButton("Chat with Support", chatWithSupport),

                const SizedBox(height: 14),

                _goldButton("Email Us", emailSupport),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF251A3F),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFF3A2D5C)),
                  ),
                  child: const Text(
                    "Support response time: < 1 hour",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9F96C8),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// FOOTER
                Center(
                  child: Column(
                    children: [
                      const Text(
                        "App Version 1.0.0",
                        style:
                            TextStyle(color: Color(0xFF9F96C8)),
                      ),

                      const SizedBox(height: 6),

                      GestureDetector(
                        onTap: () {
                          openUrl(
                              "https://yourapp.com/privacy");
                        },
                        child: const Text(
                          "Privacy Policy",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFF5C84C),
                          ),
                        ),
                      ),

                      const SizedBox(height: 4),

                      GestureDetector(
                        onTap: () {
                          openUrl(
                              "https://yourapp.com/terms");
                        },
                        child: const Text(
                          "Terms of Service",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFF5C84C),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// CATEGORY CARD
  Widget _categoryCard(IconData icon, String title) {
    return GestureDetector(
      onTap: () => openCategory(title),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF251A3F),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF3A2D5C)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFFF5C84C),
              child: Icon(icon,
                  color: const Color(0xFF1F1533), size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFFCFC8E8),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// FAQ TILE
  Widget _faqTile(int index, String question, String answer) {
    final bool isOpen = expandedIndex == index;

    return GestureDetector(
      onTap: () => toggleFAQ(index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF251A3F),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF3A2D5C)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    question,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                Icon(
                  isOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: const Color(0xFFF5C84C),
                )
              ],
            ),
            if (isOpen) ...[
              const SizedBox(height: 12),
              Text(
                answer,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFFCFC8E8),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  /// GOLD BUTTON
  Widget _goldButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5C84C),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF1F1533),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}