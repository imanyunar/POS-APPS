import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand ──
  static const Color primary = Color(0xFF00AD48);
  static const Color primaryLight = Color(0xFFE4F8EA);
  static const Color primaryDark = Color(0xFF008C3A);
  static const Color onPrimary = Colors.white;

  static const Color secondary = Color(0xFF0E9F6E);
  static const Color secondaryLight = Color(0xFF34D399);
  static const Color secondaryDark = Color(0xFF059669);
  static const Color onSecondary = Colors.white;

  // ── Surface / Background (Light) ──
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSecondary = Color(0xFFF7F7F7);
  static const Color surfaceTertiary = Color(0xFFF3F4F6);
  static const Color background = Color(0xFFF3F4F6);
  static const Color scaffoldBackground = Color(0xFFFFFFFF);

  // ── Surface / Background (Dark) ──
  static const Color surfaceDark = Color(0xFF1F2937);
  static const Color surfaceSecondaryDark = Color(0xFF374151);
  static const Color surfaceTertiaryDark = Color(0xFF4B5563);
  static const Color backgroundDark = Color(0xFF111827);
  static const Color scaffoldBackgroundDark = Color(0xFF111827);

  // ── Text ──
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textDisabled = Color(0xFF9CA3AF);
  static const Color textOnDark = Color(0xFFF9FAFB);
  static const Color textOnDarkSecondary = Color(0xFFD1D5DB);

  // ── Border / Divider ──
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF4B5563);
  static const Color divider = Color(0xFFE5E7EB);
  static const Color dividerDark = Color(0xFF374151);

  // ── Semantic ──
  static const Color success = Color(0xFF059669);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color onSuccess = Colors.white;

  static const Color warning = Color(0xFFD97706);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color onWarning = Colors.white;

  static const Color error = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color onError = Colors.white;

  static const Color info = Color(0xFF2563EB);
  static const Color infoLight = Color(0xFFDBEAFE);
  static const Color onInfo = Colors.white;

  // ── POS-specific ──
  static const Color posProductCard = Color(0xFFFFFFFF);
  static const Color posProductCardDark = Color(0xFF1F2937);
  static const Color posCartBg = Color(0xFFF9FAFB);
  static const Color posCartBgDark = Color(0xFF111827);
  static const Color lowStock = Color(0xFFF97316);
  static const Color outOfStock = Color(0xFFEF4444);

  // ── Restaurant POS accent (aligned to grocery green) ──
  static const Color accent = Color(0xFF00AD48);
  static const Color accentLight = Color(0xFFE4F8EA);
  static const Color accentDark = Color(0xFF008C3A);
  static const Color onAccent = Colors.white;
  static const Color badge = Color(0xFF00AD48);
  static const Color cardBg = Color(0xFFFFFFFF);
}

class AppColorScheme {
  AppColorScheme._();

  static ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryLight.withValues(alpha: 0.2),
    onPrimaryContainer: AppColors.primaryDark,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryLight.withValues(alpha: 0.2),
    onSecondaryContainer: AppColors.secondaryDark,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    surfaceContainerHighest: AppColors.surfaceSecondary,
    onSurfaceVariant: AppColors.textSecondary,
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.errorLight,
    onErrorContainer: AppColors.error,
    outline: AppColors.border,
    outlineVariant: AppColors.divider,
    shadow: Colors.black.withValues(alpha: 0.08),
  );

  static ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primaryLight,
    onPrimary: AppColors.primaryDark,
    primaryContainer: AppColors.primary.withValues(alpha: 0.3),
    onPrimaryContainer: AppColors.primaryLight,
    secondary: AppColors.secondaryLight,
    onSecondary: AppColors.secondaryDark,
    secondaryContainer: AppColors.secondary.withValues(alpha: 0.3),
    onSecondaryContainer: AppColors.secondaryLight,
    surface: AppColors.surfaceDark,
    onSurface: AppColors.textOnDark,
    surfaceContainerHighest: AppColors.surfaceSecondaryDark,
    onSurfaceVariant: AppColors.textOnDarkSecondary,
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.error.withValues(alpha: 0.2),
    onErrorContainer: AppColors.errorLight,
    outline: AppColors.borderDark,
    outlineVariant: AppColors.dividerDark,
    shadow: Colors.black.withValues(alpha: 0.3),
  );
}
