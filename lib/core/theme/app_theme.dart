import 'package:flutter/material.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  // =====================================================
  // 🌙 PREMIUM DARK THEME (MATCHED WITH SCREENSHOT)
  // =====================================================

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    scaffoldBackgroundColor: const Color(0xFF1C1B3A),

    primaryColor: const Color(0xFFFFD600),

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFFFD600), // Gold Accent
      secondary: Color(0xFF2B3250), // Mid Purple
      surface: Color(0xFF2F2B4D), // Card Color
      background: Color(0xFF1C1B3A),
      onPrimary: Colors.black,
      onSurface: Colors.white,
    ),

    dividerColor: const Color(0xFF3A3A5A),

    // =========================
    // 📝 TEXT THEME
    // =========================

    textTheme: TextTheme(
      displayLarge:
          AppTypography.displayLarge.copyWith(color: Colors.white),
      titleLarge:
          AppTypography.titleLarge.copyWith(color: Colors.white),
      titleMedium:
          AppTypography.titleMedium.copyWith(color: const Color(0xFFE2E2E5)),
      bodyLarge:
          AppTypography.bodyLarge.copyWith(color: const Color(0xFFE2E2E5)),
      bodyMedium:
          AppTypography.bodyMedium.copyWith(color: const Color(0xFFE2E2E5)),
      labelSmall:
          AppTypography.labelSmall.copyWith(color: Colors.white60),
    ),

    // =========================
    // 📱 APP BAR
    // =========================

    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: AppTypography.titleLarge.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    ),

    // =========================
    // 🧾 CARD THEME
    // =========================

    cardTheme: CardThemeData(
      color: const Color(0xFF2F2B4D),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),

    // =========================
    // 🔘 ELEVATED BUTTON (GOLD)
    // =========================

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFD600),
        foregroundColor: Colors.black,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        textStyle: AppTypography.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // =========================
    // 🧊 INPUT FIELD
    // =========================

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2B3250),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      hintStyle: const TextStyle(color: Colors.white54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(
          color: Color(0xFFFFD600),
          width: 1.2,
        ),
      ),
    ),

    // =========================
    // 🧭 BOTTOM NAV
    // =========================

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF2B3250),
      selectedItemColor: Color(0xFFFFD600),
      unselectedItemColor: Colors.white54,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),

    iconTheme: const IconThemeData(
      color: Colors.white,
    ),

    splashFactory: InkRipple.splashFactory,
  );
}