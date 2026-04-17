import 'package:flutter/material.dart';

class AIMoodScreen extends StatefulWidget {
  const AIMoodScreen({super.key});

  @override
  State<AIMoodScreen> createState() => _AIMoodScreenState();
}

class _AIMoodScreenState extends State<AIMoodScreen> {
  final List<String> moods = ["Motivated", "Calm", "Anxious", "Focused", "Spiritual"];
  String? selectedMood;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Text("Choose Your Mood"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: moods.map((mood) {
            final isSelected = mood == selectedMood;
            return ChoiceChip(
              label: Text(mood),
              selected: isSelected,
              selectedColor: Colors.amber,
              backgroundColor: const Color(0xFF1E293B),
              labelStyle: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              onSelected: (_) {
                setState(() {
                  selectedMood = mood;
                  // Optional: Navigate or trigger AI recommendation based on mood
                  // Navigator.pushNamed(context, AppRoutes.aiRecommendation, arguments: mood);
                });
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
