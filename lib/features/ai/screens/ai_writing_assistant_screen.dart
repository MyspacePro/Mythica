import 'package:mythica/core/monetization/access_rules.dart';
import 'package:flutter/material.dart';
import 'package:mythica/core/monetization/premium_guard.dart';
import 'package:mythica/models/user_model.dart';
import 'package:mythica/features/subscription/reader_subscription_screen.dart';

class AIWritingAssistantScreen extends StatefulWidget {
  final AppUser? currentUser;
  final bool isGuest;

  const AIWritingAssistantScreen({
    super.key,
    this.currentUser,
    this.isGuest = true,
  });

  @override
  State<AIWritingAssistantScreen> createState() =>
      _AIWritingAssistantScreenState();
}

class _AIWritingAssistantScreenState extends State<AIWritingAssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _aiResponse;
  bool _isLoading = false;

  void _improveWithAI() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _aiResponse = null;
    });

    // 🔹 Demo delay to simulate AI processing
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _aiResponse =
          "✅ Improved version of your text:\n\n${_controller.text.trim()} [AI-enhanced]";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Text("AI Writing Assistant"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: PremiumGuard(
          user: widget.currentUser,
          isGuest: widget.isGuest,
          contentType: ContentType.premium,
          lockedView: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.workspace_premium,
                  size: 80, color: Colors.amber),
              const SizedBox(height: 20),
              const Text(
                "AI Writing Assistant is available for Premium Readers",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.amber, fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ReaderSubscriptionScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Upgrade",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Improve your writing with AI",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  maxLines: 8,
                  decoration: InputDecoration(
                    hintText: "Paste your paragraph here...",
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _isLoading ? null : _improveWithAI,
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.black,
                          )
                        : const Text("Improve with AI"),
                  ),
                ),
                const SizedBox(height: 20),

                // AI Response
                if (_aiResponse != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      _aiResponse!,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
