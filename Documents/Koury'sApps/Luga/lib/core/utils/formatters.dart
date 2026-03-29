import 'package:intl/intl.dart';

/// Formatting utilities for currency, weight, date, Arabic numbers.
class Formatters {
  Formatters._();

  static String currency(double amount, {String symbol = '\$'}) {
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  static String currencyEgp(double amount) {
    return currency(amount, symbol: 'EGP ');
  }

  static String weight(double kg) {
    return '${kg.toStringAsFixed(1)} kg';
  }

  static String date(DateTime dt) {
    return DateFormat('MMM d, yyyy').format(dt);
  }

  static String dateShort(DateTime dt) {
    return DateFormat('MMM d').format(dt);
  }

  static String time(DateTime dt) {
    return DateFormat('HH:mm').format(dt);
  }

  static String dateTime(DateTime dt) {
    return DateFormat('MMM d, yyyy HH:mm').format(dt);
  }

  static String relativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return date(dt);
  }

  static String toArabicNumerals(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    var result = input;
    for (var i = 0; i < english.length; i++) {
      result = result.replaceAll(english[i], arabic[i]);
    }
    return result;
  }
}
