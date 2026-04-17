import 'package:mythica/features/ai/screens/ai_summary_screen.dart';
import 'package:mythica/features/book/provider/quotes_provider.dart';
import 'package:mythica/features/book/provider/review_provider.dart';
import 'package:mythica/features/book/screens/all_books_screen.dart';
import 'package:mythica/features/book/screens/audio_book_screen.dart';
import 'package:mythica/features/book/screens/book_battle_screen.dart';
import 'package:mythica/features/book/screens/book_detail_screen.dart';
import 'package:mythica/features/book/screens/discover_dashboard.dart';
import 'package:mythica/features/book/screens/quotes_dashboard.dart';
import 'package:mythica/features/book/screens/review_dashboard_screen.dart';
import 'package:mythica/features/category/screens/category_dashboard.dart';
import 'package:mythica/features/library/provider/favorites_provider.dart';
import 'package:mythica/features/library/screens/favorites_screen.dart';
import 'package:mythica/features/library/screens/offline_vault_screen.dart';
import 'package:mythica/features/premium/screens/premium_dashboard.dart';
import 'package:mythica/features/profile/screens/help_support_screen.dart';
import 'package:mythica/features/profile/screens/language_selection_screen.dart';
import 'package:mythica/features/profile/screens/profile_screen.dart';
import 'package:mythica/features/profile/screens/settings_screen.dart';
import 'package:mythica/features/writer/screens/content_writing_dashboard.dart';
import 'package:mythica/features/writer/screens/create_book_entry_page.dart';
import 'package:mythica/features/writer/screens/create_book_screen.dart';
import 'package:mythica/features/writer/screens/story_analytics_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mythica/navigation/app_shell.dart';
import 'package:mythica/features/auth/provider/auth_provider.dart';
import 'package:mythica/features/auth/widgets/role_guard.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/auth/screens/profile_upload_screen.dart';
import '../../features/auth/screens/genre_selection_screen.dart';
import '../../features/auth/screens/reader_genre_selection_screen.dart';
import '../../features/auth/screens/writer_genre_selection_screen.dart';
import '../../features/auth/screens/auth_wrapper.dart';
import 'package:mythica/features/library/screens/my_library_screen.dart';
import '../../features/reader/screens/pdf_reader_screen.dart';
import '../../features/reader/screens/reader_dashboard_screen.dart';
import '../../features/community/screens/community_screen.dart';
import '../../features/community/screens/create_group_screen.dart';
import '../../features/community/screens/groups_screen.dart';
import '../../features/community/screens/friends_screen.dart';
import '../../features/community/screens/friend_requests_screen.dart';
import '../../features/community/screens/chat_screen.dart';
import '../../features/writer/screens/writer_dashboard.dart';
import '../../features/writer/screens/writer_earnings_screen.dart';
import 'package:mythica/features/writer/screens/manage_books_page.dart';
import 'package:mythica/features/writer/screens/write_chapter_screen.dart';
import 'package:mythica/features/writer/screens/writer_analytics_screen.dart';
import 'package:mythica/features/writer/screens/writer_profile_screen.dart';
import 'package:mythica/features/writer/screens/writer_publish_page.dart';
import 'package:mythica/features/writer/screens/writer_subscription_screen.dart';
import '../../features/subscription/reader_subscription_screen.dart';

class AppRoutes {
  AppRoutes._();

  /// ROUTES
  static const splash = '/splash';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const authWrapper = '/auth-wrapper';

  static const genreSelection = '/genreselection';
  static const readerGenres = '/readergenres';
  static const writerGenres = '/writergenres';
  static const profileUpload = '/profileupload';

  static const readerDashboard = '/readerDashboard';

  static const subscription = '/subscription';
  static const read = '/read';
  static const pdfReader = '/pdfReader';

  static const aiSummary = '/aiSummary';
  static const storyAnalytics = '/storyAnalytics';

  static const discover = '/discover';
  static const premiumDashboard = '/premiumDashboard';
  static const offlineVault = '/offlineVault';
  static const audioBookDashboard = '/audioBookDashboard';
  static const contentWritingDashboard = '/contentWritingDashboard';

  static const communityDashboard = '/communityDashboard';
  static const groups = '/groups';
  static const friends = '/friends';
  static const friendRequests = '/friendRequests';
  static const createGroup = '/createGroup';
  static const chat = '/chat';

  static const reviewDashboard = '/reviewDashboard';
  static const quotesDashboard = '/quotesDashboard';
  static const favoritesDashboard = '/favoritesDashboard';

  static const writerDashboard = '/writerDashboard';
  static const earn = '/earn';

  static const categoryDashboard = '/categoryDashboard';
  static const bookBattleDashboard = '/bookBattleDashboard';

  static const helpSupportDashboard = '/helpSupportDashboard';
  static const language = '/language';
  static const settings = '/settings';

  static const profile = '/profile';
  static const library = '/library';
  static const bookDetail = '/bookDetail';

  static const createBook = '/writer/createBook';
  static const createBookEntry = '/writer/createBookEntry';
  static const writeChapter = '/writer/writeChapter';
  static const manageBooks = '/writer/manageBooks';
  static const writerAnalytics = '/writer/analytics';
  static const writerProfile = '/writer/profile';
  static const writerSubscription = '/writer/subscription';
  static const writerPublish = '/writer/publish';

  /// ✅ 🔥 CENTRAL BOOK OPEN FUNCTION
  static void openBook(BuildContext context, String bookId) {
    Navigator.pushNamed(
      context,
      bookDetail,
      arguments: bookId,
    );
  }

  /// ROUTE MAP
  static final Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashScreen(),
    login: (_) => const LoginScreen(),
    signup: (_) => const SignupScreen(),
    authWrapper: (_) => const AuthWrapper(),

    profile: (_) => ProfileScreen(isWriterMode: false, onSwap: () {}),

    genreSelection: (_) => const RoleSelectionScreen(),
    readerGenres: (_) => const ReaderGenreSelectionScreen(),
    writerGenres: (_) => const WriterGenreSelectionScreen(),
    profileUpload: (_) => const ProfileUploadScreen(),

    home: (_) => const AppShell(),
    readerDashboard: (_) => const ReaderDashboardScreen(),

    subscription: (_) => const ReaderSubscriptionScreen(),
    read: (_) => const AllBooksScreen(),

    discover: (_) => const DiscoverDashboard(),
    premiumDashboard: (_) => const PremiumDashboard(),
    offlineVault: (_) => const OfflineVault(),
    audioBookDashboard: (_) => const AudioBookDashboard(),

    categoryDashboard: (_) => const CategoryDashboard(),
    bookBattleDashboard: (_) => const BookBattleDashboard(),

    contentWritingDashboard: (_) =>
        const WriterAccessGuard(child: ContentWritingDashboard()),

    communityDashboard: (_) => const CommunityScreen(),
    groups: (_) => const GroupsScreen(),
    friends: (_) => const FriendsScreen(),
    friendRequests: (_) => const FriendRequestsScreen(),
    createGroup: (_) => const CreateGroupScreen(),

    helpSupportDashboard: (_) => const HelpSupportScreen(),
    language: (_) => const LanguageSelectionScreen(),
    settings: (_) => const SettingsScreen(),
    storyAnalytics: (_) => const StoryAnalyticsScreen(),

    library: (_) => const MyLibraryScreen(),
    aiSummary: (_) => const AISummaryScreen(bookTitle: ''),

    reviewDashboard: (context) {
      final bookId =
          (ModalRoute.of(context)?.settings.arguments as String?) ?? '';
      return ChangeNotifierProvider(
        create: (_) => ReviewProvider(),
        child: ReviewDashboardScreen(bookId: bookId),
      );
    },

    quotesDashboard: (_) => ChangeNotifierProvider(
          create: (_) => QuotesProvider(),
          child: const QuotesDashboard(),
        ),

    favoritesDashboard: (_) => ChangeNotifierProvider(
          create: (_) => FavoritesProvider(),
          child: const FavoritesDashboard(),
        ),

    earn: (_) =>
        const WriterAccessGuard(child: WriterEarningsScreen()),

    createBook: (_) =>
        const WriterAccessGuard(child: CreateBookScreen()),

    createBookEntry: (_) =>
        const WriterAccessGuard(child: CreateBookPage()),

    writeChapter: (_) =>
        const WriterAccessGuard(child: WriteChapterScreen()),

    manageBooks: (_) =>
        const WriterAccessGuard(child: ManageBooksPage()),

    writerAnalytics: (_) =>
        const WriterAccessGuard(child: WriterAnalyticsScreen()),

    writerProfile: (_) =>
        const WriterAccessGuard(child: WriterProfileScreen()),

    writerSubscription: (_) =>
        const WriterAccessGuard(child: WriterSubscribersScreen()),

    writerPublish: (_) =>
        const WriterAccessGuard(child: WriterPublishPage()),

    writerDashboard: (context) {
      final auth = context.read<AuthProvider>();
      final user = auth.currentUser;
      final isWriter = user?.role == UserRole.writer;

      return WriterAccessGuard(
        child: WriterDashboard(
          currentUser: user,
          isGuest: auth.isGuest,
          isWriterMode: isWriter,
        ),
      );
    },
  };

  /// 🔥 DYNAMIC ROUTES (FIXED)
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case bookDetail:
        final bookId = settings.arguments as String?;

        if (bookId == null || bookId.isEmpty) {
          return _error("Invalid Book ID");
        }

        return _page(BookDetailScreen(bookId: bookId));

      case pdfReader:
        final ReaderBook? args = settings.arguments as ReaderBook?;
        final selected =
            args ?? DummyReaderData.continueReading.first;

        final libraryBook = LibraryBook(
          id: selected.id,
          title: selected.title,
          author: selected.author,
          category: "General",
          imagePath: "",
          pdfPath: selected.pdfPath,
        );

        return _page(PdfReaderScreen(book: libraryBook));

      case chat:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return _page(ChatScreen(
          title: args['title'] ?? "Chat",
          isPrivateChat: args['isPrivateChat'] ?? false,
        ));

      default:
        return _error("Route not found");
    }
  }

  static PageRouteBuilder _page(Widget child) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, __, ___) => child,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static Route<dynamic> _error(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(child: Text(message)),
      ),
    );
  }
}