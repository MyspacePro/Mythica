import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  /* ------------------------------------------------------------------
   * 📏 BASE SCALE (4pt grid system)
   * ------------------------------------------------------------------ */

  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;
  static const double huge = 48;
  static const double massive = 64;

  /* ------------------------------------------------------------------
   * 📐 COMMON EDGE INSETS
   * ------------------------------------------------------------------ */

  static const EdgeInsets screenPadding =
      EdgeInsets.symmetric(horizontal: md);

  static const EdgeInsets screenPaddingLarge =
      EdgeInsets.symmetric(horizontal: xl);

  static const EdgeInsets cardPadding =
      EdgeInsets.all(lg);

  static const EdgeInsets sectionPadding =
      EdgeInsets.symmetric(vertical: xxl);

  static const EdgeInsets buttonPadding =
      EdgeInsets.symmetric(vertical: md, horizontal: xl);

  /* ------------------------------------------------------------------
   * 📦 SIZEDBOX HELPERS (Very Useful)
   * ------------------------------------------------------------------ */

  static const SizedBox h4 = SizedBox(height: xxs);
  static const SizedBox h8 = SizedBox(height: xs);
  static const SizedBox h12 = SizedBox(height: sm);
  static const SizedBox h16 = SizedBox(height: md);
  static const SizedBox h20 = SizedBox(height: lg);
  static const SizedBox h24 = SizedBox(height: xl);
  static const SizedBox h32 = SizedBox(height: xxl);
  static const SizedBox h40 = SizedBox(height: xxxl);
  static const SizedBox h48 = SizedBox(height: huge);

  static const SizedBox w4 = SizedBox(width: xxs);
  static const SizedBox w8 = SizedBox(width: xs);
  static const SizedBox w12 = SizedBox(width: sm);
  static const SizedBox w16 = SizedBox(width: md);
  static const SizedBox w20 = SizedBox(width: lg);
  static const SizedBox w24 = SizedBox(width: xl);
  static const SizedBox w32 = SizedBox(width: xxl);

  /* ------------------------------------------------------------------
   * 🔄 RESPONSIVE HELPERS
   * ------------------------------------------------------------------ */

  /// Mobile padding (smaller screens)
  static const EdgeInsets mobilePadding =
      EdgeInsets.symmetric(horizontal: md, vertical: md);

  /// Tablet padding (medium screens)
  static const EdgeInsets tabletPadding =
      EdgeInsets.symmetric(horizontal: xl, vertical: xl);

  /// Desktop padding (large screens)
  static const EdgeInsets desktopPadding =
      EdgeInsets.symmetric(horizontal: xxl, vertical: xxl);

  /// Card spacing (mobile)
  static const EdgeInsets mobileCardSpacing =
      EdgeInsets.all(sm);

  /// Card spacing (tablet+)
  static const EdgeInsets tabletCardSpacing =
      EdgeInsets.all(lg);
}