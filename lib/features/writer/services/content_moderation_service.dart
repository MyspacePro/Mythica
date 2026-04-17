// lib/features/writer/services/content_moderation_service.dart

enum ModerationStatus {
  safe,
  warning,
  blocked,
}

class ModerationResult {
  final ModerationStatus status;
  final String message;
  final String? matchedKeyword;

  const ModerationResult({
    required this.status,
    required this.message,
    this.matchedKeyword,
  });
}

class ContentModerationService {
  /// Strict banned keywords (auto block)
  static const List<String> _bannedKeywords = [
    'porn',
    'rape',
    'child abuse',
    'terrorist',
    'bomb attack',
    'kill religion',
    'drug selling',
    'hate speech',
    'extreme violence',
  ];

  /// Sensitive keywords (warning only)
  static const List<String> _warningKeywords = [
    'blood',
    'fight',
    'weapon',
    'war',
    'crime',
  ];

  /// Minimum chapter length
  static const int _minContentLength = 100;

  /// Maximum repetition threshold
  static const int _maxRepeatThreshold = 20;

  static Future<ModerationResult> checkContent(
    String title,
   String description,
    String content, 
  ) async {
    final fullText =
        "${title.trim()} ${description.trim()} ${content.trim()}".toLowerCase();

    /// Layer 1 — Banned Keyword Filtering
    for (final word in _bannedKeywords) {
      if (fullText.contains(word)) {
        return ModerationResult(
          status: ModerationStatus.blocked,
          message: "Content contains restricted keyword.",
          matchedKeyword: word,
        );
      }
    }

    /// Layer 2 — Warning Keywords
    for (final word in _warningKeywords) {
      if (fullText.contains(word)) {
        return ModerationResult(
          status: ModerationStatus.warning,
          message: "Content may contain sensitive material.",
          matchedKeyword: word,
        );
      }
    }

    /// Layer 3 — Minimum Content Validation
    if (content.trim().length < _minContentLength) {
      return const ModerationResult(
        status: ModerationStatus.warning,
        message: "Chapter content is too short.",
      );
    }

    /// Layer 4 — Spam / Repeated Word Detection
    final words = fullText.split(RegExp(r'\s+'));
    final Map<String, int> wordCount = {};

    for (final word in words) {
      if (word.isEmpty) continue;
      wordCount[word] = (wordCount[word] ?? 0) + 1;

      if (wordCount[word]! > _maxRepeatThreshold) {
        return ModerationResult(
          status: ModerationStatus.warning,
          message: "Content appears to contain repeated spam text.",
          matchedKeyword: word,
        );
      }
    }

    /// Layer 5 — Future AI Moderation Placeholder
    /// Example:
    /// final aiResult = await _callAiModerationApi(fullText);

    return const ModerationResult(
      status: ModerationStatus.safe,
      message: "Content is safe for publishing.",
    );
  }

  /// Future AI moderation integration
  /// Example: Gemini / OpenAI moderation
  /*
  static Future<ModerationResult> _callAiModerationApi(String text) async {
  
    return const ModerationResult(
      status: ModerationStatus.safe,
      message: "AI moderation passed",
    );
  }
  */
}