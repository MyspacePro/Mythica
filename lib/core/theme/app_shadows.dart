import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  /* ------------------------------------------------------------------
   * 🌞 LIGHT THEME SHADOWS
   * ------------------------------------------------------------------ */

  // Very subtle (cards on soft background)
  static const List<BoxShadow> lightSoft = [
    BoxShadow(
      color: Color(0x0D000000), // 5%
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];

  // Default card shadow (modern SaaS look)
  static const List<BoxShadow> lightCard = [
    BoxShadow(
      color: Color(0x14000000), // 8%
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];

  // Elevated content (modals / sheets)
  static const List<BoxShadow> lightElevated = [
    BoxShadow(
      color: Color(0x1F000000), // 12%
      blurRadius: 30,
      offset: Offset(0, 12),
    ),
  ];

  // Floating button glow (purple vibe)
  static const List<BoxShadow> primaryGlow = [
    BoxShadow(
      color: Color(0x337B4DFF), // purple glow
      blurRadius: 25,
      offset: Offset(0, 10),
    ),
  ];

  /* ------------------------------------------------------------------
   * 🌙 DARK THEME SHADOWS
   * ------------------------------------------------------------------ */

  static const List<BoxShadow> darkSoft = [
    BoxShadow(
      color: Color(0x33000000), // 20%
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> darkCard = [
    BoxShadow(
      color: Color(0x44000000), // 27%
      blurRadius: 18,
      offset: Offset(0, 6),
    ),
  ];

  static const List<BoxShadow> darkElevated = [
    BoxShadow(
      color: Color(0x55000000),
      blurRadius: 28,
      offset: Offset(0, 12),
    ),
  ];

  /* ------------------------------------------------------------------
   * 🧊 NEUMORPHIC (Optional Advanced Style)
   * ------------------------------------------------------------------ */

  static const List<BoxShadow> neumorphicLight = [
    BoxShadow(
      color: Color(0xFFFFFFFF),
      offset: Offset(-4, -4),
      blurRadius: 10,
    ),
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(4, 4),
      blurRadius: 10,
    ),
  ];
}
