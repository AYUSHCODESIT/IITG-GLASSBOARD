import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF6366F1); // Indigo / Electric Purple
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color secondary = Color(0xFF3B82F6); // Vibrant Blue
  static const Color accent = Color(0xFF8B5CF6); // Violet

  // Dark Mode Backdrops
  static const Color darkBg = Color(0xFF090D16); // Ultra Dark Blue-Black
  static const Color darkCard = Color(0xFF151E2E); // Deep Slate
  static const Color darkCardGlass = Color(0x991E293B); // Translucent Slate
  static const Color darkBorder = Color(0xFF2E3E53);

  // Light Mode Backdrops
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardGlass = Color(0xD9FFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // Status Colors
  static const Color success = Color(0xFF10B981); // Emerald Green
  static const Color warning = Color(0xFFF59E0B); // Amber Yellow
  static const Color danger = Color(0xFFEF4444); // Sunset Orange / Blocked
  static const Color info = Color(0xFF0EA5E9); // Sky Blue

  // Text Colors
  static const Color textDarkPrimary = Color(0xFFF8FAFC);
  static const Color textDarkSecondary = Color(0xFF94A3B8);
  static const Color textLightPrimary = Color(0xFF0F172A);
  static const Color textLightSecondary = Color(0xFF64748B);

  // Custom Gradients for premium visual layout
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0x22FFFFFF), Color(0x05FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient dangerGradient = LinearGradient(
    colors: [danger, Color(0xFFB91C1C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
