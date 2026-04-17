import 'package:mythica/core/routes/app_routes.dart';
import 'package:mythica/features/community/data/community_dummy_data.dart';
import 'package:mythica/features/community/models/group_model.dart';
import 'package:flutter/material.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  static const Color bgPrimary = Color(0xFF1F1533);
  static const Color bgSecondary = Color(0xFF2A1E47);
  static const Color bgDeep = Color(0xFF140F26);
  static const Color goldPrimary = Color(0xFFF5C84C);
  static const Color goldGlow = Color(0xFFFFD76A);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFCFC8E8);
  static const Color textMuted = Color(0xFF9F96C8);
  static const Color cardFill = Color(0xFF251A3F);
  static const Color cardBorder = Color(0xFF3A2D5C);

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
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 30),
              Expanded(child: _buildGroupList(context)),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: goldGlow.withValues(alpha:0.30),
              blurRadius: 20,
              spreadRadius: 1,
            )
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: goldPrimary,
          onPressed: () async {
            final createdGroup = await Navigator.pushNamed<GroupModel>(
              context,
              AppRoutes.createGroup,
            );

            if (createdGroup != null) {
              setState(() {
                CommunityDummyData.groups.insert(0, createdGroup);
              });
            }
          },
          child: const Icon(Icons.group_add, color: bgPrimary),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        children: [
          Text(
            'Groups',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: textPrimary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupList(BuildContext context) {
    final groups = CommunityDummyData.groups;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.chat,
              arguments: {'title': group.name, 'isPrivateChat': false},
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardFill,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: cardBorder),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: bgPrimary,
                    border: Border.all(color: cardBorder),
                  ),
                  child: const Icon(Icons.group, color: goldPrimary, size: 26),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(group.name,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: textPrimary)),
                      const SizedBox(height: 4),
                      Text('${group.membersCount} Members',
                          style:
                              const TextStyle(fontSize: 12, color: textMuted)),
                      const SizedBox(height: 8),
                      Text(group.lastMessage,
                          style: const TextStyle(
                              fontSize: 14, color: textSecondary)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 18, color: goldPrimary),
              ],
            ),
          ),
        );
      },
    );
  }
}
