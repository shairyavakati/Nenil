import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary Sage Green Palette
  static const Color primary = Color(0xFF476649);
  static const Color primaryContainer = Color(0xFF7A9A7A);
  static const Color primaryFixed = Color(0xFFC9ECC7);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF143119);

  // Surface & Warm Cream Backgrounds
  static const Color background = Color(0xFFFCF9F8);
  static const Color surface = Color(0xFFFCF9F8);
  static const Color surfaceContainerLow = Color(0xFFF6F3F2);
  static const Color surfaceContainer = Color(0xFFF0EDED);
  static const Color surfaceContainerHigh = Color(0xFFEAE7E7);
  static const Color surfaceContainerHighest = Color(0xFFE4E2E1);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);

  // Earthen Accent & Tertiary (Terracotta)
  static const Color tertiary = Color(0xFF904C24);
  static const Color tertiaryContainer = Color(0xFFCE7E52);
  static const Color tertiaryFixed = Color(0xFFFFDBCA);
  static const Color onTertiary = Color(0xFFFFFFFF);

  // Secondary Warm Neutral
  static const Color secondary = Color(0xFF5F5E59);
  static const Color secondaryContainer = Color(0xFFE5E2DB);
  static const Color secondaryFixed = Color(0xFFE5E2DB);

  // Text & Outline
  static const Color onSurface = Color(0xFF1B1C1C);
  static const Color onSurfaceVariant = Color(0xFF424841);
  static const Color outline = Color(0xFF737971);
  static const Color outlineVariant = Color(0xFFC2C8BF);

  // Status & Error
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        secondaryContainer: AppColors.secondaryContainer,
        tertiary: AppColors.tertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: TextTheme(
        // Newsreader for headlines (Seraph, editorial warmth)
        displayLarge: GoogleFonts.newsreader(
          fontSize: 36,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        headlineLarge: GoogleFonts.newsreader(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        headlineMedium: GoogleFonts.newsreader(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        headlineSmall: GoogleFonts.newsreader(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        // Outfit for high legibility body & labels
        bodyLarge: GoogleFonts.outfit(
          fontSize: 19,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurface,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurfaceVariant,
        ),
        labelLarge: GoogleFonts.outfit(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        labelMedium: GoogleFonts.outfit(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}
