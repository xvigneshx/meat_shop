import 'package:flutter/material.dart';

/// Artisanal Butcher Design Tokens
abstract class AppColors {
  // Brand & Accent
  static const Color primary = Color(0xFF6B020E); // Oxblood / Butcher Crimson
  static const Color primaryContainer = Color(0xFF8B1E22);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFFFF9D98);

  // Surface Canvas & Containers
  static const Color surface = Color(0xFFF8F9FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF0F4FD);
  static const Color surfaceContainer = Color(0xFFEAEEF8);
  static const Color surfaceContainerHigh = Color(0xFFE4E8F2);
  static const Color surfaceContainerHighest = Color(0xFFDEE2EC);

  // Typography & Content Inks
  static const Color onSurface = Color(0xFF171C23);
  static const Color onSurfaceVariant = Color(0xFF584140);
  static const Color outline = Color(0xFF8B716F);
  static const Color outlineVariant = Color(0xFFDFBFBD);

  // Secondary & Muted Accents
  static const Color secondary = Color(0xFF745853);
  static const Color tertiary = Color(0xFF4A2B05);
}

abstract class AppRadius {
  static const double sm = 8.0;
  static const double defaultRadius = 16.0;
  static const double md = 24.0;
  static const double lg = 32.0;
  static const double full = 9999.0;
}

abstract class AppSpacing {
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 14.0;
  static const double spaceLg = 20.0;
  static const double spaceXl = 32.0;
  static const double margin = 16.0;
  static const double gutter = 12.0;
}

abstract class AppTypography {
  static const String fontFamily = 'Plus Jakarta Sans';

  static const TextStyle displayLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 44 / 36,
    letterSpacing: -1.08,
    color: AppColors.onSurface,
  );

  static const TextStyle headlineLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w600,
    height: 34 / 26,
    letterSpacing: -0.52,
    color: AppColors.onSurface,
  );

  static const TextStyle headlineMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
    letterSpacing: -0.3,
    color: AppColors.onSurface,
  );

  static const TextStyle headlineSm = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 24 / 17,
    letterSpacing: -0.17,
    color: AppColors.onSurface,
  );

  static const TextStyle bodyLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    color: AppColors.onSurface,
  );

  static const TextStyle bodyMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 21 / 14,
    color: AppColors.onSurface,
  );

  static const TextStyle bodySm = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 17 / 12,
    color: AppColors.onSurfaceVariant,
  );

  static const TextStyle labelLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 18 / 14,
    color: AppColors.onSurface,
  );

  static const TextStyle labelMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    color: AppColors.onSurfaceVariant,
  );

  static const TextStyle labelCaps = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    height: 14 / 11,
    letterSpacing: 0.88,
    color: AppColors.primary,
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.surface,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
      ),
      fontFamily: AppTypography.fontFamily,
      cardTheme: const CardThemeData(
        color: AppColors.surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
        ),
      ),
    );
  }
}
