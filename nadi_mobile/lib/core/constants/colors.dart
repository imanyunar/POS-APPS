import 'package:flutter/material.dart';

class ServeColors {
  ServeColors._();

  // Stripe-inspired Primary (Indigo)
  static const Color primary = Color(0xFF533AFD);
  static const Color primaryLight = Color(0xFFB9B9F9); // Subdued
  static const Color primaryDark = Color(0xFF2E2B8C); // Pressed

  static const Color secondary = Color(0xFF0D253D); // Stripe Ink

  // Light Theme Surfaces
  static const Color bgBase = Color(0xFFF6F9FC); // Stripe Canvas Soft
  static const Color bgCard = Color(0xFFFFFFFF); // Stripe Canvas
  static const Color bgSurface = Color(0xFFFFFFFF);
  static const Color bgElevated = Color(0xFFFFFFFF);

  static const Color border = Color(0xFFE3E8EE); // Stripe Hairline
  static const Color borderFocus = Color(0xFFA8C3DE); // Stripe Hairline Input

  // Dark Theme Surfaces (Zinc Dark + Stripe Brand Dark 900)
  static const Color darkBgBase = Color(0xFF09090B); // Zinc 950
  static const Color darkBgCard = Color(0xFF1C1E54); // Stripe Brand Dark 900
  static const Color darkBorder = Color(0xFF273951); // Ink Secondary
  static const Color darkBorderFocus = Color(0xFF533AFD);

  // Text Colors (Light Mode)
  static const Color textPrimary = Color(0xFF0D253D); // Stripe Ink
  static const Color textSecondary = Color(0xFF273951); // Stripe Ink Secondary
  static const Color textMuted = Color(0xFF64748D); // Stripe Ink Mute

  // Text Colors (Dark Mode)
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFE3E8EE); // Hairline as light gray text
  static const Color darkTextMuted = Color(0xFFA8C3DE); // Hairline input as muted

  // Semantic
  static const Color success = Color(0xFF10B981);
  static const Color successBg = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color danger = Color(0xFFEA2261); // Stripe Ruby
  static const Color dangerBg = Color(0xFFFDE8EE); // Light Ruby
  static const Color info = Color(0xFF0EA5E9);
  static const Color infoBg = Color(0xFFE0F2FE);

  // Legacy aliases
  static const Color accentIndigo = primary;
  static const Color accentTeal = primary;
  static const Color accentIndigoBg = primaryLight;
  static const Color accentTealBg = primaryLight;
  static LinearGradient get accentGradient => primaryGradient;

  static const Color orderPending = Color(0xFFF59E0B);
  static const Color orderPreparing = Color(0xFF0EA5E9);
  static const Color orderReady = Color(0xFF8B5CF6);
  static const Color orderCompleted = Color(0xFF10B981);
  static const Color orderCancelled = Color(0xFFEA2261);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF665EFD), Color(0xFF533AFD)], // Primary Soft to Primary
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF6F9FC), Color(0xFFFFFFFF)],
    stops: [0.0, 0.35],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF34D399), Color(0xFF059669)],
  );
}
