import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Color palette
class AppColors {
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF9F9F9);
  static const Color primaryAccent = Color(0xFFE8614A); // coral-orange
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF9A9A9A);
  static const Color border = Color(0xFFEEEEEE);
  static const Color success = Color(0xFF34C759);
  static const Color badgeRed = Color(0xFFFF3B30);
}

// Typography
class AppTextStyles {
  static TextStyle heading = GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static TextStyle sectionLabel = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static TextStyle body = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
  static TextStyle caption = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
  static TextStyle accentPrice = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
}

// Spacing and radii
class AppSpacing {
  static const double base = 8.0;
  static const double xs = base; // 8
  static const double sm = base * 1.5; // 12
  static const double md = base * 2; // 16
  static const double lg = base * 2.5; // 20
  static const double xl = base * 3; // 24
}

class AppRadius {
  static const double card = 12.0;
  static const double chip = 8.0;
  static const double pill = 50.0;
}

// Elevation
class AppElevation {
  static const List<BoxShadow> subtle = [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];
}

// Helper for consistent icon size
class AppIcons {
  static const double small = 20.0;
  static const double medium = 24.0;
  static const double large = 28.0;
}
