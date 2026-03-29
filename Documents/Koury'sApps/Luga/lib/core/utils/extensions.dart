extension DateTimeX on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  bool get isPast => isBefore(DateTime.now());
}

extension StringX on String {
  String get capitalized => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
  String get initials {
    final parts = trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return isNotEmpty ? this[0].toUpperCase() : '?';
  }
}

extension NumX on num {
  String get asCurrency => '\$${toStringAsFixed(2)}';
  String get asWeight => '${toStringAsFixed(1)} kg';
}
