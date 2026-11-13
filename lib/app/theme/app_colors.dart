import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Figma Exact Primary & Brand Colors
  static const Color primary = Color(
    0xFFB1326A,
  ); // Signature Berry / Magenta Pink from Figma
  static const Color primaryLight = Color(0xFFFF81AE);
  static const Color primaryDark = Color(0xFF8B1D4F);

  // Secondary & Accents
  static const Color secondary = Color(0xFFFF81AE);
  static const Color accent = Color(0xFF03035A);

  // Soft Tint Backgrounds (e.g. Card & Field backgrounds)
  static const Color inputBackground = Color(
    0xFFF8DDE6,
  ); // Soft pink tint from login/signup fields
  static const Color inputBackgroundLight = Color(0xFFFDF6F8);

  // Customer dashboard tints
  static const Color heroStart = Color(0xFFF8D8E4);
  static const Color heroEnd = Color(0xFFFCEDF3);
  static const Color softPink = Color(0xFFFBEBF1);
  static const Color iconPink = Color(0xFFF5C1D7);
  static const Color rating = Color(0xFFFFB400);

  // Background & Surfaces
  static const Color background = Colors.white;
  static const Color surface = Colors.white;
  static const Color cardColor = Colors.white;

  // Text Colors
  static const Color textPrimary = Color(
    0xFF03035A,
  ); // Deep navy for titles and headings
  static const Color textSecondary = Color(
    0xFF607092,
  ); // Muted slate navy for subtitles
  static const Color textMuted = Color(0xFF9EA8BD);

  // Borders & Dividers
  static const Color border = Color(0xFFE8D7DF);
  static const Color divider = Color(0xFFF2ECEF);

  // Feedback Colors
  static const Color success = Color(0xFF2ED573);
  static const Color error = Color(0xFFFF4757);
  static const Color warning = Color(0xFFFFA502);
  static const Color info = Color(0xFF1E90FF);
}
