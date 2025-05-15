import 'package:flutter/material.dart';

class AppColors {
  // Dark Theme Colors
  static const Color darkBackground = Color(
    0xFF121212,
  ); // Slightly darker than 1C1C1E for more depth
  static const Color darkSurface = Color(
    0xFF1E1E1E,
  ); // For cards, dialogs, input backgrounds
  static const Color darkPrimaryText = Colors.white;
  static const Color darkSecondaryText = Color(0xFFB0B0B0); // Lighter grey
  static const Color darkHintText = Color(0xFF8A8A8A); // Even lighter grey
  static const Color darkIcon = Color(0xFFA0A0A0);
  static const Color darkInputBorder = Color(0xFF3A3A3C);
  static const Color darkGradientStart =
      Colors.redAccent; // Or Color(0xFFF44336)
  static const Color darkGradientEnd =
      Colors.purpleAccent; // Or Color(0xFFE91E63)
  static const Color darkSocialButtonOutline = Color(0xFF48484A);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF5F5F7);
  static const Color lightSurface = Colors.white;
  static const Color lightPrimaryText = Color(0xFF1D1D1F);
  static const Color lightSecondaryText = Color(0xFF505052);
  static const Color lightHintText = Color(0xFF8A8A8F);
  static const Color lightIcon = Color(0xFF606062);
  static const Color lightInputBorder = Color(0xFFD1D1D6);
  static const Color lightGradientStart = Colors.deepOrangeAccent;
  static const Color lightGradientEnd = Colors.pinkAccent;
  static const Color lightSocialButtonOutline = Color(0xFFC6C6C8);

  // Common Colors (can be used in both or specific, adjust as needed)
  static const Color googleRed = Colors.red; // More specific
  static const Color facebookBlue = Colors.blue; // More specific
  static const Color sparkleYellow = Color(
    0xFFFFD700,
  ); // Gold/Amber for sparkle
}
