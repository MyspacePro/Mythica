import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// SERVICES
import 'package:mythica/services/auth_service.dart';
import 'package:mythica/services/role_service.dart';

// ROUTES
import 'package:mythica/core/routes/app_routes.dart';

// PROVIDERS
import 'package:mythica/providers/notification_provider.dart';

// WIDGETS
import '../widgets/home_app_bar.dart';
import '../widgets/app_drawer.dart';
import 'package:mythica/navigation/bottom_nav.dart';
import 'package:mythica/features/home/widgets/search_bar.dart';
import '../widgets/banner_slider.dart';
import '../widgets/services_section.dart';
import '../widgets/section_title.dart';
import '../widgets/banner_card.dart';
import '../widgets/sweet_banner.dart';

// SCREENS
import 'package:mythica/features/library/screens/my_library_screen.dart';

// DATA
import 'package:mythica/features/home/widgets/home_services.dart';

// BOOK SECTIONS
import 'package:mythica/features/home/widgets/featured_books.dart';
import 'package:mythica/features/home/widgets/recommended_books.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String? uid = FirebaseAuth.instance.currentUser?.uid;

  /// 🔥 Animation Route
  Route _animatedRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, animation, __) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween(begin: 0.98, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    /// ✅ Load notifications ONCE (not inside build)
    if (uid != null) {
      Future.microtask(() {
        Provider.of<NotificationProvider>(context, listen: false)
            .loadNotifications(uid!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    /// ✅ If user not logged in → no stream
    final stream = uid == null
        ? const Stream.empty()
        : RoleService.instance.userProfileStream(uid!);

    return StreamBuilder<Map<String, dynamic>?>(
      stream: stream,
      builder: (context, snapshot) {
        final role = snapshot.data?['role']?.toString();
        final canAccessWriter =
            RoleService.instance.isWriterOrAdmin(role);

        /// ✅ Filter services
        final visibleServices = homeServices
            .where((service) =>
                canAccessWriter ||
                service.route != AppRoutes.writerDashboard)
            .toList();

        final ourServices = visibleServices.take(4).toList();
        final explore = visibleServices.skip(4).take(4).toList();
        final discoverMore = visibleServices.skip(8).take(8).toList();
        final remaining = visibleServices.skip(16).toList();

        return Scaffold(
          backgroundColor: Colors.transparent,
          drawer: const AppDrawer(),

          /// 🔥 APP BAR
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(size.height * 0.09),
            child: HomeAppBar(
              actions: [
                /// 📚 Library
                IconButton(
                  icon: const Icon(Icons.library_books),
                  onPressed: () {
                    Navigator.push(
                      context,
                      _animatedRoute(const MyLibraryScreen()),
                    );
                  },
                ),

                /// 🔔 Notifications
                if (uid != null)
                  Consumer<NotificationProvider>(
                    builder: (context, notifications, _) {
                      final unread =
                          notifications.unreadCount(uid!);

                      return Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.notifications);
                            },
                          ),
                          if (unread > 0)
                            Positioned(
                              right: 10,
                              top: 10,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '$unread',
                                  style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),

                /// 🚪 Logout
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    await AuthService.instance.logout();
                  },
                ),
              ],
            ),
          ),

          /// 🔻 BOTTOM NAV
          bottomNavigationBar: BottomNav(
            currentIndex: 0,
            onTap: (index) {
              switch (index) {
                case 0:
                  break; // already home
                case 1:
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.writerDashboard);
                  break;
                case 2:
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.library);
                  break;
                case 3:
                  Navigator.pushNamed(context, AppRoutes.profile);
                  break;
              }
            },
          ),

          /// 🧠 BODY
          body: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.3,
                colors: [
                  Color(0xFF2E1B47),
                  Color(0xFF1C1B3A),
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(bottom: padding.bottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      /// 🔎 SEARCH
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: HomeSearchBar(),
                      ),

                      const SizedBox(height: 24),

                      /// 🎯 BANNER
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: BannerSlider(
                          banners: [
                            "assets/banners/banner1.jpg",
                            "assets/banners/banner2.jpg",
                            "assets/banners/banner3.jpg",
                          ],
                        ),
                      ),

                      SizedBox(height: size.height * 0.04),

                      /// 🛠 SERVICES
                      ServicesSection(
                        title: "Our Services",
                        services: ourServices,
                        crossAxisCount: 4,
                      ),

                      SizedBox(height: size.height * 0.03),

                      /// 📚 FEATURED
                      const SectionTitle("Featured Books"),
                      SizedBox(height: size.height * 0.02),
                      const FeaturedBooks(),

                      SizedBox(height: size.height * 0.04),

                      /// 🔎 EXPLORE
                      ServicesSection(
                        title: "Explore",
                        services: explore,
                        crossAxisCount: 4,
                      ),

                      SizedBox(height: size.height * 0.03),

                      /// 🚀 DISCOVER
                      ServicesSection(
                        title: "Discover More",
                        services: discoverMore,
                        crossAxisCount: 4,
                      ),

                      SizedBox(height: size.height * 0.03),

                      /// 💎 PROMO
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: BannerCard(
                          text:
                              "AI Powered Reading & Writing Experience",
                        ),
                      ),

                      SizedBox(height: size.height * 0.03),

                      /// ❤️ RECOMMENDED
                      const SectionTitle("Recommended For You"),
                      SizedBox(height: size.height * 0.02),
                      const RecommendedBooksSection(),

                      SizedBox(height: size.height * 0.03),

                      /// 🔥 OTHERS
                      ServicesSection(
                        title: "Others",
                        services: remaining,
                        crossAxisCount: 4,
                      ),

                      SizedBox(height: size.height * 0.03),

                      /// ✨ FINAL BANNER
                      const SweetBanner(),

                      SizedBox(height: size.height * 0.05),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}