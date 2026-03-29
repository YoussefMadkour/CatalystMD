import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_colors.dart';

class SearchFiltersBar extends StatelessWidget {
  const SearchFiltersBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
        children: [
          FilterChip(label: const Text('All'), selected: true, onSelected: (_) {}),
          const SizedBox(width: AppSpacing.xs),
          FilterChip(label: const Text('Electronics'), selected: false, onSelected: (_) {}),
          const SizedBox(width: AppSpacing.xs),
          FilterChip(label: const Text('Clothing'), selected: false, onSelected: (_) {}),
          const SizedBox(width: AppSpacing.xs),
          FilterChip(label: const Text('Cosmetics'), selected: false, onSelected: (_) {}),
        ],
      ),
    );
  }
}
