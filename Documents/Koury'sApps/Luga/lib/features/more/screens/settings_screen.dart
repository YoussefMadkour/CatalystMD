import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/locale_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Arabic'),
            value: locale.languageCode == 'ar',
            onChanged: (v) => ref.read(localeProvider.notifier).state = Locale(v ? 'ar' : 'en'),
          ),
          // TODO: More settings
        ],
      ),
    );
  }
}
