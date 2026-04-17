import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessageOptionsSheet extends StatelessWidget {
  final dynamic message;
  final String currentUserId;

  const MessageOptionsSheet({
    super.key,
    required this.message,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.senderId == currentUserId;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            _buildOption(
              icon: Icons.reply,
              text: "Reply",
              onTap: () {
                Navigator.pop(context);
                // 🔥 trigger reply logic
              },
            ),

            _buildOption(
              icon: Icons.copy,
              text: "Copy",
              onTap: () {
                Clipboard.setData(
                  ClipboardData(text: message.content),
                );
                Navigator.pop(context);
              },
            ),

            _buildOption(
              icon: Icons.forward,
              text: "Forward",
              onTap: () {
                Navigator.pop(context);
                // 🔥 forward logic later
              },
            ),

            if (isMe)
              _buildOption(
                icon: Icons.delete,
                text: "Delete",
                color: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  // 🔥 delete logic
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: TextStyle(color: color),
      ),
      onTap: onTap,
    );
  }
}