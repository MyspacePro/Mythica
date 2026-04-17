import 'package:flutter/material.dart';

class FriendRequestsScreen extends StatefulWidget {
  const FriendRequestsScreen({super.key});

  @override
  State<FriendRequestsScreen> createState() => _FriendRequestsScreenState();
}

class _FriendRequestsScreenState extends State<FriendRequestsScreen> {
  static const Color bgPrimary = Color(0xFF1F1533);
  static const Color bgSecondary = Color(0xFF2A1E47);
  static const Color bgDeep = Color(0xFF140F26);
  static const Color goldPrimary = Color(0xFFF5C84C);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFCFC8E8);
  static const Color cardFill = Color(0xFF251A3F);
  static const Color cardBorder = Color(0xFF3A2D5C);

  final List<String> _pendingRequests = ['Rohan Mehta', 'Priya Shah'];
  final List<String> _suggestions = ['Aman Verma', 'Sneha Patel', 'Dev Joshi'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgPrimary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [bgPrimary, bgSecondary, bgDeep],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            children: [
              const Text('Friend Requests',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textPrimary, letterSpacing: 0.5)),
              const SizedBox(height: 30),
              const Text('Pending Requests',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textSecondary)),
              const SizedBox(height: 18),
              ..._pendingRequests.map((name) => _requestCard(name)),
              const SizedBox(height: 40),
              const Text('Suggested Readers',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textSecondary)),
              const SizedBox(height: 18),
              ..._suggestions.map((name) => _suggestionCard(name)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _requestCard(String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: cardFill, borderRadius: BorderRadius.circular(26), border: Border.all(color: cardBorder)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(shape: BoxShape.circle, color: bgPrimary, border: Border.all(color: cardBorder)),
            child: const Icon(Icons.person, color: goldPrimary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(name,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: textPrimary)),
          ),
          _actionButton('Accept', true, () => _acceptRequest(name)),
          const SizedBox(width: 10),
          _actionButton('Reject', false, () => _rejectRequest(name)),
        ],
      ),
    );
  }

  Widget _suggestionCard(String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: cardFill, borderRadius: BorderRadius.circular(26), border: Border.all(color: cardBorder)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(shape: BoxShape.circle, color: bgPrimary, border: Border.all(color: cardBorder)),
            child: const Icon(Icons.person, color: goldPrimary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(name,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: textPrimary)),
          ),
          TextButton(
            onPressed: () => _addSuggestion(name),
            child: const Text('Add', style: TextStyle(color: goldPrimary, fontWeight: FontWeight.w600)),
          )
        ],
      ),
    );
  }

  Widget _actionButton(String text, bool isPrimary, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isPrimary ? goldPrimary : cardFill,
          borderRadius: BorderRadius.circular(22),
          border: isPrimary ? null : Border.all(color: cardBorder),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isPrimary ? bgPrimary : textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _acceptRequest(String name) {
    setState(() => _pendingRequests.remove(name));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$name accepted')));
  }

  void _rejectRequest(String name) {
    setState(() => _pendingRequests.remove(name));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$name rejected')));
  }

  void _addSuggestion(String name) {
    setState(() {
      _suggestions.remove(name);
      _pendingRequests.add(name);
    });
  }
}
