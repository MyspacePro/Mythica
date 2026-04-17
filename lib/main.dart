import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'package:mythica/firebase_options.dart';
import 'core/constants/app_config.dart';
import 'core/routes/app_routes.dart';

import 'package:mythica/core/theme/app_theme.dart';

import 'package:mythica/features/auth/screens/auth_wrapper.dart';
import 'package:mythica/features/auth/provider/auth_provider.dart';

import 'package:mythica/providers/app_settings_provider.dart';
import 'package:mythica/providers/comment_provider.dart';
import 'package:mythica/providers/follow_provider.dart';
import 'package:mythica/providers/monetization_provider.dart';
import 'package:mythica/providers/notification_provider.dart';

import 'package:mythica/features/library/provider/favorites_provider.dart';
import 'package:mythica/features/reader/merge/reader_provider.dart';
import 'package:mythica/features/reader/merge/reader_studio_provider.dart';

import 'package:mythica/features/writer/provider/writer_provider.dart';
import 'package:mythica/features/writer/provider/story_analytics_provider.dart';

import 'package:mythica/features/book/provider/discover_provider.dart';
import 'package:mythica/features/book/provider/book_provider.dart';

import 'package:mythica/features/library/models/library_store.dart';

import 'package:mythica/features/home/mainicon/premium_icon/services/premium_controller.dart';
import 'package:mythica/features/home/mainicon/premium_icon/services/premium_repository.dart';
import 'package:mythica/features/home/mainicon/premium_icon/services/premium_remote_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// CONFIG
  AppConfig.initialize(AppEnvironment.dev);

  /// FIREBASE
  await _initializeFirebase();

  /// LOCAL STORAGE
  final sharedPreferences = await SharedPreferences.getInstance();

  /// ERROR HANDLING
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint("🔥 Flutter Error: ${details.exception}");
  };

  runZonedGuarded(
    () {
      runApp(MyAppRoot(sharedPreferences: sharedPreferences));
    },
    (error, stack) {
      debugPrint("🔥 Unhandled Error: $error");
      debugPrintStack(stackTrace: stack);
    },
  );
}

/// FIREBASE INIT
Future<void> _initializeFirebase() async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e, stack) {
    debugPrint("🔥 Firebase Init Error: $e");
    debugPrintStack(stackTrace: stack);
  }
}

/// ROOT APP
class MyAppRoot extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyAppRoot({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: sharedPreferences),

        /// AUTH
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..initialize(),
        ),

        /// NOTIFICATIONS
        ChangeNotifierProvider(create: (_) => NotificationProvider()),

        /// DEPENDENT PROVIDERS
        ChangeNotifierProvider(
          create: (context) => CommentProvider(
            notificationProvider: context.read<NotificationProvider>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => FollowProvider(
            notificationProvider: context.read<NotificationProvider>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => MonetizationProvider(
            notificationProvider: context.read<NotificationProvider>(),
          ),
        ),

        /// CORE FEATURES
        ChangeNotifierProvider(create: (_) => ReaderProvider()),
        ChangeNotifierProvider(create: (_) => ReaderStudioProvider()),

        /// BOOKS + DISCOVER
        ChangeNotifierProvider(create: (_) => BookProvider()),
        ChangeNotifierProvider(create: (_) => DiscoverProvider()),

        /// ANALYTICS + WRITER
        ChangeNotifierProvider(create: (_) => StoryAnalyticsProvider()),
        ChangeNotifierProvider(create: (_) => WriterProvider()),

        /// LIBRARY + FAVORITES
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => LibraryStore()),

        /// SETTINGS
        ChangeNotifierProvider(create: (_) => AppSettingsProvider()),

        /// PREMIUM
        ChangeNotifierProvider(
          create: (_) => PremiumController(
            PremiumRepository(
              PremiumRemoteService(),
            ),
          ),
        ),
      ],
      child: const MyApp(),
    );
  }
}

/// APP
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettingsProvider>(
      builder: (context, settings, _) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,

          /// THEME
          theme: AppTheme.darkTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.themeMode,

          /// LOCALE
          locale: settings.locale,
          supportedLocales: const [
            Locale('en'),
            Locale('hi'),
            Locale('gu'),
          ],

          /// ENTRY
          home: const AuthWrapper(),

          /// ROUTES
          routes: AppRoutes.routes,
          onGenerateRoute: AppRoutes.onGenerateRoute,
        );
      },
    );
  }
}