
import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  static const String fontFamily =
      'YourAppFontFamily'; // Replace if you have a custom font

  // Dark Theme Text Styles
  static TextStyle get darkHeadlineLarge => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.darkPrimaryText,
    height: 1.3,
  );

  static TextStyle get darkBodyLarge => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    color: AppColors.darkSecondaryText,
  );

  static TextStyle get darkLabelSmall => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    color: AppColors.darkSecondaryText,
  );

  static TextStyle get darkButtonText => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    color: Colors.white, // Assuming gradient button text is always white
    fontWeight: FontWeight.bold,
  );

  static TextStyle get darkHintText =>
      TextStyle(fontFamily: fontFamily, color: AppColors.darkHintText);

  // Light Theme Text Styles
  static TextStyle get lightHeadlineLarge => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.lightPrimaryText,
    height: 1.3,
  );

  static TextStyle get lightBodyLarge => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    color: AppColors.lightSecondaryText,
  );

  static TextStyle get lightLabelSmall => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    color: AppColors.lightSecondaryText,
  );

  static TextStyle get lightButtonText => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    color: Colors.white, // Assuming gradient button text is always white
    fontWeight: FontWeight.bold,
  );

  static TextStyle get lightHintText =>
      TextStyle(fontFamily: fontFamily, color: AppColors.lightHintText);
}
