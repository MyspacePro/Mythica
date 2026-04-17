import 'package:mythica/features/community/models/group_model.dart';
import 'package:flutter/material.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  static const Color bgPrimary = Color(0xFF1F1533);
  static const Color cardFill = Color(0xFF251A3F);
  static const Color cardBorder = Color(0xFF3A2D5C);
  static const Color goldPrimary = Color(0xFFF5C84C);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFCFC8E8);
  static const Color textMuted = Color(0xFF9F96C8);

  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _groupNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgPrimary,
      appBar: AppBar(
        backgroundColor: bgPrimary,
        iconTheme: const IconThemeData(color: textSecondary),
        title: const Text('Create New Group', style: TextStyle(color: textPrimary)),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 30),
        child: Column(
          children: [
            TextField(
              controller: _groupNameController,
              style: const TextStyle(color: textSecondary),
              decoration: InputDecoration(
                labelText: 'Group Name',
                labelStyle: const TextStyle(color: textMuted),
                filled: true,
                fillColor: cardFill,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(color: cardBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(color: goldPrimary),
                ),
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _descriptionController,
              style: const TextStyle(color: textSecondary),
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: const TextStyle(color: textMuted),
                filled: true,
                fillColor: cardFill,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(color: cardBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(color: goldPrimary),
                ),
              ),
            ),
            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: goldPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                onPressed: _createGroup,
                child: const Text(
                  'Create Group',
                  style: TextStyle(
                    color: bgPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createGroup() {
    final name = _groupNameController.text.trim();
    final description = _descriptionController.text.trim();

    if (name.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields.')),
      );
      return;
    }

    final group = GroupModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      imageUrl: '',
      membersCount: 1,
      isPrivate: false,
      lastMessage: 'Group created',
      lastMessageTime: DateTime.now(),
    );

    Navigator.pop(context, group);
  }
}
