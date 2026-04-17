import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._();

  /* ------------------------------------------------------------------
   * 🔹 BASE SCALE (8pt system)
   * ------------------------------------------------------------------ */

  static const double xs = 6;
  static const double sm = 12;
  static const double md = 18;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 40;

  /* ------------------------------------------------------------------
   * 🔹 BORDER RADIUS PRESETS
   * ------------------------------------------------------------------ */

  static const BorderRadius xsRadius =
      BorderRadius.all(Radius.circular(xs));

  static const BorderRadius smRadius =
      BorderRadius.all(Radius.circular(sm));

  static const BorderRadius mdRadius =
      BorderRadius.all(Radius.circular(md));

  static const BorderRadius lgRadius =
      BorderRadius.all(Radius.circular(lg));

  static const BorderRadius xlRadius =
      BorderRadius.all(Radius.circular(xl));

  static const BorderRadius xxlRadius =
      BorderRadius.all(Radius.circular(xxl));

  /* ------------------------------------------------------------------
   * 🔹 SPECIAL USE CASE RADII
   * ------------------------------------------------------------------ */

  // Perfect for primary buttons
  static const BorderRadius pill =
      BorderRadius.all(Radius.circular(100));

  // Bottom sheet / modal top rounded
  static const BorderRadius modal =
      BorderRadius.vertical(top: Radius.circular(32));

  // Card style (modern soft UI)
  static const BorderRadius card =
      BorderRadius.all(Radius.circular(24));

  // Circular (avatars, icons)
  static const BorderRadius circle =
      BorderRadius.all(Radius.circular(999));
}
