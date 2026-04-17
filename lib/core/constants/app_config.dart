/// Global Dummy Mode
/// Used for development when backend not ready
const bool isDummyMode = true;

/// Supported environments
enum AppEnvironment {
  dev,
  staging,
  prod,
}

class AppConfig {
  final String appName;
  final String baseUrl;

  /// Feature Flags
  final bool enableLogging;
  final bool enablePayments;
  final bool enableAnalytics;
  final bool enableAI;
  final bool enableNotifications;

  final AppEnvironment environment;

  static AppConfig? _instance;

  AppConfig._({
    required this.appName,
    required this.baseUrl,
    required this.enableLogging,
    required this.enablePayments,
    required this.enableAnalytics,
    required this.enableAI,
    required this.enableNotifications,
    required this.environment,
  });

  /// Initialize configuration
  static void initialize(AppEnvironment env) {
    switch (env) {

      /// Development Environment
      case AppEnvironment.dev:
        _instance = AppConfig._(
          appName: "Mythica Dev",
          baseUrl: "http://localhost:3000",
          enableLogging: true,
          enablePayments: false,
          enableAnalytics: false,
          enableAI: true,
          enableNotifications: true,
          environment: env,
        );
        break;

      /// Staging Environment
      case AppEnvironment.staging:
        _instance = AppConfig._(
          appName: "Mythica Staging",
          baseUrl: "https://staging-api.mythica.app",
          enableLogging: true,
          enablePayments: true,
          enableAnalytics: true,
          enableAI: true,
          enableNotifications: true,
          environment: env,
        );
        break;

      /// Production Environment
      case AppEnvironment.prod:
        _instance = AppConfig._(
          appName: "Mythica",
          baseUrl: "https://api.mythica.app",
          enableLogging: false,
          enablePayments: true,
          enableAnalytics: true,
          enableAI: true,
          enableNotifications: true,
          environment: env,
        );
        break;
    }
  }

  /// Global access
  static AppConfig get instance {
    if (_instance == null) {
      throw Exception(
        "AppConfig not initialized. Call AppConfig.initialize(environment) first.",
      );
    }
    return _instance!;
  }

  /// Environment helpers
  bool get isDev => environment == AppEnvironment.dev;

  bool get isStaging => environment == AppEnvironment.staging;

  bool get isProd => environment == AppEnvironment.prod;

  /// Payment helper
  bool get canProcessPayments => enablePayments;

  /// Logging helper
  bool get isLoggingEnabled => enableLogging;

  /// Debug info (safe logging)
  void printConfig() {
    if (!enableLogging) return;

    // ignore: avoid_print
    print(
      """
      -------- APP CONFIG --------
      App Name: $appName
      Environment: $environment
      Base URL: $baseUrl
      Logging: $enableLogging
      Payments: $enablePayments
      Analytics: $enableAnalytics
      AI: $enableAI
      Notifications: $enableNotifications
      Dummy Mode: $isDummyMode
      ----------------------------
      """,
    );
  }
}
