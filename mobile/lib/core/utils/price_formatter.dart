import 'package:intl/intl.dart';

/// Utility class for formatting prices in Russian format
class PriceFormatter {
  // Private constructor to prevent instantiation
  PriceFormatter._();

  /// Number formatter for Russian locale
  static final _formatter = NumberFormat('#,###', 'ru_RU');

  /// Format price to Russian format with₽ symbol
  ///
  /// Example:
  /// ```dart
  /// PriceFormatter.format(1299.0)  // "1 299 ₽"
  /// PriceFormatter.format(1000)    // "1 000 ₽"
  /// ```
  static String format(num price) {
    return '${_formatter.format(price)} ₽';
  }

  /// Format price without currency symbol
  ///
  /// Example:
  /// ```dart
  /// PriceFormatter.formatWithoutSymbol(1299.0)  // "1 299"
  /// ```
  static String formatWithoutSymbol(num price) {
    return _formatter.format(price);
  }

  /// Format price with custom currency symbol
  ///
  /// Example:
  /// ```dart
  /// PriceFormatter.formatWithSymbol(1299.0, '₴')  // "1 299 ₴"
  /// ```
  static String formatWithSymbol(num price, String symbol) {
    return '${_formatter.format(price)} $symbol';
  }

  /// Format price range
  ///
  /// Example:
  /// ```dart
  /// PriceFormatter.formatRange(1000, 5000)  // "1 000 - 5 000 ₽"
  /// ```
  static String formatRange(num minPrice, num maxPrice) {
    return '${_formatter.format(minPrice)} - ${_formatter.format(maxPrice)} ₽';
  }

  /// Parse formatted price string back to number
  /// Removes spaces, currency symbols, and converts to double
  ///
  /// Example:
  /// ```dart
  /// PriceFormatter.parse("1 299 ₽")  // 1299.0
  /// ```
  static double parse(String formattedPrice) {
    // Remove spaces, currency symbols, and other non-numeric characters except decimal point
    final cleaned = formattedPrice
        .replaceAll(RegExp(r'[^\d.]'), '')
        .trim();

    return double.tryParse(cleaned) ?? 0.0;
  }

  /// Format discount amount (shown as negative)
  ///
  /// Example:
  /// ```dart
  /// PriceFormatter.formatDiscount(100)  // "−100 ₽"
  /// ```
  static String formatDiscount(num discount) {
    return '−${_formatter.format(discount)} ₽';
  }
}
