import 'package:flutter/material.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String selectedLanguage = "English";

  final List<Map<String, String>> languages = [
    {"language": "English", "subtitle": "English (Default)"},
    {"language": "हिन्दी", "subtitle": "Hindi"},
    {"language": "ગુજરાતી", "subtitle": "Gujarati"},
    {"language": "தமிழ்", "subtitle": "Tamil"},
    {"language": "తెలుగు", "subtitle": "Telugu"},
    {"language": "বাংলা", "subtitle": "Bengali"},
    {"language": "मराठी", "subtitle": "Marathi"},
    {"language": "ਪੰਜਾਬੀ", "subtitle": "Punjabi"},
    {"language": "ಕನ್ನಡ", "subtitle": "Kannada"},
    {"language": "മലയാളം", "subtitle": "Malayalam"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Text("Choose Language"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select your preferred language",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "You can change this anytime from settings.",
              style: TextStyle(color: Colors.white60),
            ),
            const SizedBox(height: 24),

            /// Language List
            Expanded(
              child: ListView.builder(
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  final language = languages[index];

                  return _LanguageTile(
                    language: language["language"]!,
                    subtitle: language["subtitle"]!,
                    selected: selectedLanguage == language["language"],
                    onTap: () {
                      setState(() {
                        selectedLanguage = language["language"]!;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🌍 LANGUAGE TILE
class _LanguageTile extends StatelessWidget {
  final String language;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.language,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: selected
              ? Border.all(
                  color: Colors.amber,
                  width: 1.2,
                )
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle,
                color: Colors.amber,
              ),
          ],
        ),
      ),
    );
  }
}