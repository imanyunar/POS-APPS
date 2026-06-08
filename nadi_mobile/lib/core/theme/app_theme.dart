import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: ServeColors.bgBase,
      colorScheme: const ColorScheme.light(
        primary: ServeColors.primary,
        primaryContainer: ServeColors.primaryLight,
        secondary: ServeColors.secondary,
        surface: ServeColors.bgSurface,
        surfaceContainerHighest: ServeColors.bgCard,
        error: ServeColors.danger,
        onPrimary: Colors.white,
        onSurface: ServeColors.textPrimary,
        onSurfaceVariant: ServeColors.textSecondary,
        outline: ServeColors.border,
        outlineVariant: ServeColors.borderFocus,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: ServeColors.primary,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: -0.64, // Stripe negative tracking
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        indicatorColor: ServeColors.primaryLight,
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.08), // Stripe shadow
        height: 68,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final active = states.contains(WidgetState.selected);
          return GoogleFonts.inter(
            fontSize: 11,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            color: active ? ServeColors.primary : ServeColors.textMuted,
            letterSpacing: 0,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final active = states.contains(WidgetState.selected);
          return IconThemeData(
            color: active ? ServeColors.primary : ServeColors.textMuted,
            size: 24,
          );
        }),
      ),
      cardTheme: CardThemeData(
        color: ServeColors.bgCard,
        surfaceTintColor: Colors.transparent,
        elevation: 1, // Will be mapped to Stripe box-shadow in actual cards
        shadowColor: const Color(0xFF003770).withValues(alpha: 0.08), // Stripe shadow-blue
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: ServeColors.border, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ServeColors.bgCard,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: GoogleFonts.inter(
          fontSize: 15,
          color: ServeColors.textMuted,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // Stripe input radius
          borderSide: const BorderSide(color: ServeColors.borderFocus),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ServeColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ServeColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ServeColors.danger),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ServeColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)), // Stripe Pill
          elevation: 0,
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: ServeColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)), // Pill
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ServeColors.primary,
          side: const BorderSide(color: ServeColors.primary),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)), // Pill
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: ServeColors.primaryLight,
        selectedColor: ServeColors.primary,
        side: const BorderSide(color: ServeColors.primaryLight),
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: ServeColors.primaryDark,
        ),
        secondaryLabelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)), // Pill
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      dividerTheme: const DividerThemeData(
        color: ServeColors.border,
        thickness: 1,
        space: 1,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: ServeColors.bgSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: ServeColors.bgElevated,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: ServeColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ServeColors.textPrimary,
        contentTextStyle: GoogleFonts.inter(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? Colors.white : ServeColors.textMuted),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? ServeColors.primary : ServeColors.border),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? ServeColors.primary : Colors.transparent),
        side: const BorderSide(color: ServeColors.border, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: ServeColors.primary,
        linearTrackColor: ServeColors.border,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(color: ServeColors.textPrimary, fontWeight: FontWeight.w300, letterSpacing: -1.4),
        displayMedium: GoogleFonts.inter(color: ServeColors.textPrimary, fontWeight: FontWeight.w300, letterSpacing: -0.64),
        headlineLarge: GoogleFonts.inter(color: ServeColors.textPrimary, fontWeight: FontWeight.w300, letterSpacing: -0.22),
        headlineMedium: GoogleFonts.inter(color: ServeColors.textPrimary, fontWeight: FontWeight.w300, letterSpacing: -0.2),
        headlineSmall: GoogleFonts.inter(color: ServeColors.textPrimary, fontWeight: FontWeight.w300, letterSpacing: 0),
        titleLarge: GoogleFonts.inter(color: ServeColors.textPrimary, fontWeight: FontWeight.w400, letterSpacing: -0.2),
        bodyLarge: GoogleFonts.inter(color: ServeColors.textPrimary, fontWeight: FontWeight.w300, letterSpacing: 0),
        bodyMedium: GoogleFonts.inter(color: ServeColors.textSecondary, fontWeight: FontWeight.w300, letterSpacing: 0),
        bodySmall: GoogleFonts.inter(color: ServeColors.textMuted, fontWeight: FontWeight.w400, letterSpacing: 0),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: ServeColors.darkBgBase,
      colorScheme: const ColorScheme.dark(
        primary: ServeColors.primary,
        primaryContainer: ServeColors.primaryLight,
        secondary: ServeColors.secondary,
        surface: ServeColors.darkBgCard,
        surfaceContainerHighest: ServeColors.darkBgBase,
        error: ServeColors.danger,
        onPrimary: Colors.white,
        onSurface: ServeColors.darkTextPrimary,
        onSurfaceVariant: ServeColors.darkTextSecondary,
        outline: ServeColors.darkBorder,
        outlineVariant: ServeColors.darkBorderFocus,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: ServeColors.darkBgCard,
        foregroundColor: ServeColors.darkTextPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: ServeColors.darkTextPrimary),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: ServeColors.darkTextPrimary,
          letterSpacing: -0.64,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: ServeColors.darkBgCard,
        surfaceTintColor: Colors.transparent,
        indicatorColor: ServeColors.primaryDark,
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        height: 68,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final active = states.contains(WidgetState.selected);
          return GoogleFonts.inter(
            fontSize: 11,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            color: active ? ServeColors.primaryLight : ServeColors.darkTextMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final active = states.contains(WidgetState.selected);
          return IconThemeData(
            color: active ? ServeColors.primaryLight : ServeColors.darkTextMuted,
            size: 24,
          );
        }),
      ),
      cardTheme: CardThemeData(
        color: ServeColors.darkBgCard,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.2),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: ServeColors.darkBorder, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ServeColors.darkBgCard,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: GoogleFonts.inter(
          fontSize: 15,
          color: ServeColors.darkTextMuted,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ServeColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ServeColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ServeColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ServeColors.danger),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ServeColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
          elevation: 0,
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: ServeColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ServeColors.primaryLight,
          side: const BorderSide(color: ServeColors.primaryLight),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: ServeColors.darkBgBase,
        selectedColor: ServeColors.primary,
        side: const BorderSide(color: ServeColors.darkBorder),
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: ServeColors.darkTextPrimary,
        ),
        secondaryLabelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: ServeColors.darkBgCard,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: ServeColors.darkBgCard,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: ServeColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ServeColors.textPrimary, // Contrast on dark
        contentTextStyle: GoogleFonts.inter(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? Colors.white : ServeColors.textMuted),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? ServeColors.primary : ServeColors.darkBorder),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? ServeColors.primary : Colors.transparent),
        side: const BorderSide(color: ServeColors.darkBorder, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: ServeColors.primary,
        linearTrackColor: ServeColors.darkBorder,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(color: ServeColors.darkTextPrimary, fontWeight: FontWeight.w300, letterSpacing: -1.4),
        displayMedium: GoogleFonts.inter(color: ServeColors.darkTextPrimary, fontWeight: FontWeight.w300, letterSpacing: -0.64),
        headlineLarge: GoogleFonts.inter(color: ServeColors.darkTextPrimary, fontWeight: FontWeight.w300, letterSpacing: -0.22),
        headlineMedium: GoogleFonts.inter(color: ServeColors.darkTextPrimary, fontWeight: FontWeight.w300, letterSpacing: -0.2),
        headlineSmall: GoogleFonts.inter(color: ServeColors.darkTextPrimary, fontWeight: FontWeight.w300, letterSpacing: 0),
        titleLarge: GoogleFonts.inter(color: ServeColors.darkTextPrimary, fontWeight: FontWeight.w400, letterSpacing: -0.2),
        bodyLarge: GoogleFonts.inter(color: ServeColors.darkTextPrimary, fontWeight: FontWeight.w300, letterSpacing: 0),
        bodyMedium: GoogleFonts.inter(color: ServeColors.darkTextSecondary, fontWeight: FontWeight.w300, letterSpacing: 0),
        bodySmall: GoogleFonts.inter(color: ServeColors.darkTextMuted, fontWeight: FontWeight.w400, letterSpacing: 0),
      ),
    );
  }
}
