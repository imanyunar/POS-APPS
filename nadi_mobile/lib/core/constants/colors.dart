import 'package:flutter/material.dart';

class ServeColors {
  ServeColors._();

  static const Color primary = Color(0xFFF97316);
  static const Color primaryLight = Color(0xFFFFEDD5);
  static const Color primaryDark = Color(0xFFC2410C);

  static const Color secondary = Color(0xFF1E293B);

  static const Color bgBase = Color(0xFFFFF7F0);
  static const Color bgCard = Color(0xFFFFFFFF);
  static const Color bgSurface = Color(0xFFFFFFFF);
  static const Color bgElevated = Color(0xFFFFFFFF);

  static const Color border = Color(0xFFE2E8F0);
  static const Color borderFocus = Color(0xFFCBD5E1);

  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  static const Color success = Color(0xFF10B981);
  static const Color successBg = Color(0xFFD1FAE5);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningBg = Color(0xFFFEF3C7);

  static const Color danger = Color(0xFFEF4444);
  static const Color dangerBg = Color(0xFFFEE2E2);

  static const Color info = Color(0xFF0EA5E9);
  static const Color infoBg = Color(0xFFE0F2FE);

  // Legacy aliases — mapped to new brand colors
  static const Color accentIndigo = primary;
  static const Color accentTeal = primary;
  static const Color accentIndigoBg = primaryLight;
  static const Color accentTealBg = primaryLight;
  static LinearGradient get accentGradient => primaryGradient;

  static const Color orderPending = Color(0xFFF59E0B);
  static const Color orderPreparing = Color(0xFF0EA5E9);
  static const Color orderReady = Color(0xFF8B5CF6);
  static const Color orderCompleted = Color(0xFF10B981);
  static const Color orderCancelled = Color(0xFFEF4444);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFB923C), Color(0xFFF97316)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF97316), Color(0xFFFFF7F0)],
    stops: [0.0, 0.35],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF34D399), Color(0xFF059669)],
  );
}
