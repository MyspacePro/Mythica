import 'package:mythica/core/routes/app_routes.dart';
import 'package:mythica/features/community/data/community_dummy_data.dart';
import 'package:mythica/features/community/models/user_model.dart';
import 'package:flutter/material.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  static const Color primaryBg = Color(0xFF1F1533);
  static const Color gradientMid = Color(0xFF2A1E47);
  static const Color goldPrimary = Color(0xFFF5C84C);
  static const Color goldGlow = Color(0xFFFFD76A);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFCFC8E8);
  static const Color cardFill = Color(0xFF251A3F);
  static const Color borderInactive = Color(0xFF3A2D5C);

  @override
  Widget build(BuildContext context) {
    final friends = CommunityDummyData.friends;

    return Scaffold(
      backgroundColor: primaryBg,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryBg, gradientMid],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 28),
              _buildActiveUsers(context, friends),
              const SizedBox(height: 28),
              Expanded(child: _FriendList(friends: friends)),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: goldGlow.withValues(alpha:0.3), blurRadius: 18, spreadRadius: 1)
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: goldPrimary,
          onPressed: () => Navigator.pushNamed(context, AppRoutes.friendRequests),
          child: const Icon(Icons.person_add, color: primaryBg),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        'Friends',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: textPrimary, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildActiveUsers(BuildContext context, List<UserModel> friends) {
    final onlineUsers = friends.where((f) => f.isOnline).toList();

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: onlineUsers.length,
        itemBuilder: (context, index) {
          final friend = onlineUsers[index];
          return GestureDetector(
            onTap: () => _openPrivateChat(context, friend),
            child: Padding(
              padding: const EdgeInsets.only(right: 18),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: goldPrimary, width: 2),
                    ),
                    child: const CircleAvatar(
                      radius: 30,
                      backgroundColor: cardFill,
                      child: Icon(Icons.person, color: goldPrimary, size: 28),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(friend.name.split(' ').first,
                      style: const TextStyle(color: textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _openPrivateChat(BuildContext context, UserModel friend) {
    Navigator.pushNamed(
      context,
      AppRoutes.chat,
      arguments: {'title': friend.name, 'isPrivateChat': true},
    );
  }
}

class _FriendList extends StatelessWidget {
  final List<UserModel> friends;

  const _FriendList({required this.friends});

  static const Color goldPrimary = Color(0xFFF5C84C);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color cardFill = Color(0xFF251A3F);
  static const Color borderInactive = Color(0xFF3A2D5C);
  static const Color primaryBg = Color(0xFF1F1533);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.chat,
              arguments: {'title': friend.name, 'isPrivateChat': true},
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 18),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            decoration: BoxDecoration(
              color: cardFill,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: borderInactive),
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: goldPrimary, width: 1.5)),
                  child: const CircleAvatar(
                    backgroundColor: cardFill,
                    radius: 24,
                    child: Icon(Icons.person, color: goldPrimary),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Text(friend.name,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: textPrimary)),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(color: goldPrimary, shape: BoxShape.circle),
                  child: const Icon(Icons.chat_bubble_outline, color: primaryBg, size: 20),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
