import 'package:flutter/material.dart';

/// Application color palette matching the web app design
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary brand color from web
  static const Color primary = Color(0xFFEF2AC1);
  static const Color primaryDark = Color(0xFFD625AD);

  // Dark foreground
  static const Color darkBlue = Color(0xFF0A2240);

  // Secondary
  static const Color secondary = Color(0xFF005CB9);

  // Neutrals
  static const Color background = Color(0xFFFFFFFF);
  static const Color muted = Color(0xFFF5F5F5);
  static const Color mutedForeground = Color(0xFF717182);
  static const Color border = Color(0xFFE5E5E5);
  static const Color surface = Color(0xFFFBF9FA);

  // Text colors
  static const Color textPrimary = Color(0xFF0A2240);
  static const Color textSecondary = Color(0xFF4a5565);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Semantic colors
  static const Color error = Color(0xFFD4183D);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
}
