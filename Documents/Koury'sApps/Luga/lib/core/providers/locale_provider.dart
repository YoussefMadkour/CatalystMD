import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// AR/EN locale state.
final localeProvider = StateProvider<Locale>((ref) {
  return const Locale('en');
});
