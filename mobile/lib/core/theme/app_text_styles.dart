import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Application text styles matching the web app typography
/// Web uses Manrope font with weights: 400, 500, 600, 700
class AppTextStyles {
  // Private constructor to prevent instantiation
  AppTextStyles._();

  // Base text style using Manrope font
  static TextStyle get _baseTextStyle => GoogleFonts.manrope(
        color: AppColors.textPrimary,
        height: 1.5,
      );

  // Display styles
  static TextStyle get displayLarge => _baseTextStyle.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  static TextStyle get displayMedium => _baseTextStyle.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  static TextStyle get displaySmall => _baseTextStyle.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  // Heading styles (h1, h2, h3, h4)
  static TextStyle get h1 => _baseTextStyle.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );

  static TextStyle get h2 => _baseTextStyle.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );

  static TextStyle get h3 => _baseTextStyle.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );

  static TextStyle get h4 => _baseTextStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );

  // Body text styles
  static TextStyle get bodyLarge => _baseTextStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodyMedium => _baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodySmall => _baseTextStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  // Label styles
  static TextStyle get labelLarge => _baseTextStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );

  static TextStyle get labelMedium => _baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );

  static TextStyle get labelSmall => _baseTextStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );

  // Button text style
  static TextStyle get button => _baseTextStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );

  // Price styles
  static TextStyle get priceLarge => _baseTextStyle.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      );

  static TextStyle get priceMedium => _baseTextStyle.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      );

  static TextStyle get priceSmall => _baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  // Caption and helper text
  static TextStyle get caption => _baseTextStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  static TextStyle get overline => _baseTextStyle.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5,
        height: 1.6,
      );
}
