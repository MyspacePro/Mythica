import 'package:mythica/core/routes/app_routes.dart';
import 'package:mythica/features/community/data/community_dummy_data.dart';
import 'package:mythica/features/community/screens/community_home_screen.dart';
import 'package:mythica/features/community/screens/community_profile_screen.dart';
import 'package:mythica/features/community/screens/friends_screen.dart';
import 'package:mythica/features/community/screens/groups_screen.dart';
import 'package:flutter/material.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const CommunityHomeScreen(),
      const GroupsScreen(),
      const _ChatsTab(),
      const FriendsScreen(),
      const CommunityProfileScreen(name: 'Reader User', role: 'Book Enthusiast'),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Community Home'),
          NavigationDestination(icon: Icon(Icons.groups_outlined), selectedIcon: Icon(Icons.groups), label: 'Groups'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Chats'),
          NavigationDestination(icon: Icon(Icons.people_alt_outlined), selectedIcon: Icon(Icons.people_alt), label: 'Friends'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _ChatsTab extends StatelessWidget {
  const _ChatsTab();

  @override
  Widget build(BuildContext context) {
    final chats = [
      ...CommunityDummyData.groups.map((g) => {'title': g.name, 'isPrivateChat': false}),
      ...CommunityDummyData.friends.map((f) => {'title': f.name, 'isPrivateChat': true}),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return ListTile(
          onTap: () => Navigator.pushNamed(context, AppRoutes.chat, arguments: chat),
          title: Text(chat['title']! as String),
          subtitle: Text((chat['isPrivateChat']! as bool) ? 'Private chat' : 'Group chat'),
          trailing: const Icon(Icons.chevron_right),
        );
      },
    );
  }
}
