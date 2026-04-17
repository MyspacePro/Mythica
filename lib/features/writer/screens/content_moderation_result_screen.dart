import 'package:mythica/features/writer/widgets/content_moderation_service.dart' show ModerationResult, ModerationStatus;
import 'package:flutter/material.dart';

class ContentModerationResultScreen extends StatelessWidget {
  final ModerationResult result;

  const ContentModerationResultScreen({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;

    switch (result.status) {
      case ModerationStatus.safe:
        color = Colors.green;
        icon = Icons.check_circle;
        break;

      case ModerationStatus.warning:
        color = Colors.orange;
        icon = Icons.warning;
        break;

      case ModerationStatus.blocked:
        color = Colors.red;
        icon = Icons.cancel;
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Content Moderation"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 80),
            const SizedBox(height: 20),
            Text(
              result.message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Back"),
            )
          ],
        ),
      ),
    );
  }
}