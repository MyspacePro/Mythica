import 'package:flutter/material.dart';
import 'package:mythica/core/routes/app_routes.dart';

class HomeService {
  final String title;
  final IconData icon;
  final String route;

  HomeService({
    required this.title,
    required this.icon,
    required this.route,
  });
}

final List<HomeService> homeServices = [

  /// 🔵 CORE READING
  HomeService(
    title: "Reader Studio",
    icon: Icons.menu_book,
    route: AppRoutes.readerDashboard,
  ),
  HomeService(
    title: "Discover",
    icon: Icons.explore,
    route: AppRoutes.discover,
  ),
  HomeService(
    title: "Premium",
    icon: Icons.workspace_premium,
    route: AppRoutes.premiumDashboard,
  ),
  HomeService(
    title: "Offline Vault",
    icon: Icons.download_for_offline,
    route: AppRoutes.offlineVault,
  ),
  HomeService(
    title: "Audio Books",
    icon: Icons.headphones,
    route: AppRoutes.audioBookDashboard,
  ),
  HomeService(
    title: "AI Summary",
    icon: Icons.psychology_alt,
    route: AppRoutes.aiSummary, 
    // change if you create separate AI screen
  ),

  /// 🟢 WRITER ZONE
  HomeService(
    title: "Writer Studio",
    icon: Icons.edit_note,
    route: AppRoutes.writerDashboard,
  ),
  HomeService(
    title: "Content Writing",
    icon: Icons.create,
    route: AppRoutes.contentWritingDashboard,
  ),
  HomeService(
    title: "Story Analytics",
    icon: Icons.analytics,
    route: AppRoutes.storyAnalytics,
  ),
  HomeService(
    title: "Earn as Writer",
    icon: Icons.currency_rupee,
    route: AppRoutes.earn,
  ),

  /// 🟠 COMMUNITY
  HomeService(
    title: "Community",
    icon: Icons.groups,
    route: AppRoutes.communityDashboard,
  ),
  HomeService(
    title: "Reviews",
    icon: Icons.rate_review,
    route: AppRoutes.reviewDashboard,
  ),
  HomeService(
    title: "Category",
    icon: Icons.category,
    route: AppRoutes.categoryDashboard,
  ),
  HomeService(
    title: "Book Battle",
    icon: Icons.sports_kabaddi,
    route: AppRoutes.bookBattleDashboard,
  ),
  HomeService(
    title: "Quotes",
    icon: Icons.format_quote,
    route: AppRoutes.quotesDashboard,
  ),

  /// 🟣 USER SECTION
  HomeService(
    title: "Favorites",
    icon: Icons.favorite,
    route: AppRoutes.favoritesDashboard,
  ),
  HomeService(
    title: "Languages",
    icon: Icons.language,
    route: AppRoutes.language,
  ),
  HomeService(
    title: "Help & Support",
    icon: Icons.help_outline,
    route: AppRoutes.helpSupportDashboard,
  ),
  HomeService(
    title: "Settings",
    icon: Icons.settings,
    route: AppRoutes.settings,
  ),
];