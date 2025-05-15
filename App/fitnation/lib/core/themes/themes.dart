import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';

class AppThemes {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: AppTextStyles.fontFamily,
    primaryColor: AppColors.darkGradientEnd, // A dominant color from gradient
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkGradientEnd,
      secondary: AppColors.darkGradientStart,
      surface: AppColors.darkSurface,
      background: AppColors.darkBackground,
      error: Colors.redAccent,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.darkPrimaryText,
      onBackground: AppColors.darkPrimaryText,
      onError: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.darkPrimaryText),
      titleTextStyle: AppTextStyles.darkHeadlineLarge.copyWith(fontSize: 20),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurface,
      hintStyle: AppTextStyles.darkHintText,
      labelStyle: AppTextStyles.darkLabelSmall.copyWith(color: AppColors.darkSecondaryText),
      prefixIconColor: AppColors.darkIcon,
      suffixIconColor: AppColors.darkIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: AppColors.darkInputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: AppColors.darkInputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: AppColors.darkGradientEnd, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.darkHeadlineLarge, // Formerly headline1
      displayMedium: AppTextStyles.darkHeadlineLarge.copyWith(fontSize: 26), // headline2
      displaySmall: AppTextStyles.darkHeadlineLarge.copyWith(fontSize: 24), // headline3
      headlineMedium: AppTextStyles.darkHeadlineLarge.copyWith(fontSize: 22), // headline4
      headlineSmall: AppTextStyles.darkHeadlineLarge.copyWith(fontSize: 20), // headline5
      titleLarge: AppTextStyles.darkHeadlineLarge.copyWith(fontSize: 18, fontWeight: FontWeight.w600), // headline6
      bodyLarge: AppTextStyles.darkBodyLarge, // bodyText1
      bodyMedium: AppTextStyles.darkBodyLarge.copyWith(fontSize: 14), // bodyText2
      labelLarge: AppTextStyles.darkButtonText.copyWith(fontSize: 16), // button
      bodySmall: AppTextStyles.darkLabelSmall.copyWith(fontSize: 12), // caption
      labelSmall: AppTextStyles.darkLabelSmall.copyWith(fontSize: 10), // overline
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        // For non-gradient buttons, if any
        backgroundColor: AppColors.darkGradientEnd,
        foregroundColor: Colors.white,
        textStyle: AppTextStyles.darkButtonText,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.darkGradientEnd,
        textStyle: AppTextStyles.darkLabelSmall.copyWith(fontWeight: FontWeight.bold),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.darkGradientEnd;
        }
        return AppColors.darkSurface;
      }),
      checkColor: MaterialStateProperty.all(Colors.white),
      side: const BorderSide(color: AppColors.darkInputBorder),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.darkIcon,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.darkInputBorder,
      thickness: 1,
    )
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: AppTextStyles.fontFamily,
    primaryColor: AppColors.lightGradientEnd,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightGradientEnd,
      secondary: AppColors.lightGradientStart,
      surface: AppColors.lightSurface,
      background: AppColors.lightBackground,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.lightPrimaryText,
      onBackground: AppColors.lightPrimaryText,
      onError: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightSurface,
      elevation: 1,
      iconTheme: const IconThemeData(color: AppColors.lightPrimaryText),
      titleTextStyle: AppTextStyles.lightHeadlineLarge.copyWith(fontSize: 20, color: AppColors.lightPrimaryText),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurface,
      hintStyle: AppTextStyles.lightHintText,
      labelStyle: AppTextStyles.lightLabelSmall.copyWith(color: AppColors.lightSecondaryText),
      prefixIconColor: AppColors.lightIcon,
      suffixIconColor: AppColors.lightIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: AppColors.lightInputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: AppColors.lightInputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: AppColors.lightGradientEnd, width: 1.5),
      ),
       errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.lightHeadlineLarge,
      displayMedium: AppTextStyles.lightHeadlineLarge.copyWith(fontSize: 26),
      displaySmall: AppTextStyles.lightHeadlineLarge.copyWith(fontSize: 24),
      headlineMedium: AppTextStyles.lightHeadlineLarge.copyWith(fontSize: 22),
      headlineSmall: AppTextStyles.lightHeadlineLarge.copyWith(fontSize: 20),
      titleLarge: AppTextStyles.lightHeadlineLarge.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
      bodyLarge: AppTextStyles.lightBodyLarge,
      bodyMedium: AppTextStyles.lightBodyLarge.copyWith(fontSize: 14),
      labelLarge: AppTextStyles.lightButtonText.copyWith(fontSize: 16),
      bodySmall: AppTextStyles.lightLabelSmall.copyWith(fontSize: 12),
      labelSmall: AppTextStyles.lightLabelSmall.copyWith(fontSize: 10),
    ),
     elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightGradientEnd,
        foregroundColor: Colors.white,
        textStyle: AppTextStyles.lightButtonText,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.lightGradientEnd,
         textStyle: AppTextStyles.lightLabelSmall.copyWith(fontWeight: FontWeight.bold),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.lightGradientEnd;
        }
        return AppColors.lightSurface;
      }),
      checkColor: MaterialStateProperty.all(Colors.white),
      side: const BorderSide(color: AppColors.lightInputBorder),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.lightIcon,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.lightInputBorder,
      thickness: 1,
    )
  );
}