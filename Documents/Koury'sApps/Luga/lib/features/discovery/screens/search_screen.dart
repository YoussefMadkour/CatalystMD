import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/luga_text_field.dart';
import '../widgets/search_filters_bar.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
            child: LugaTextField(
              label: 'Search',
              hint: 'City, category, or keyword...',
              prefix: const Icon(Icons.search),
              onChanged: (query) {
                // TODO: Trigger search
              },
            ),
          ),
          const SearchFiltersBar(),
          // TODO: Search results list
          const Expanded(child: Center(child: Text('Search results'))),
        ],
      ),
    );
  }
}
