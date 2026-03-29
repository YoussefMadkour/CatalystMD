import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';

class ReviewTagChips extends StatelessWidget {
  const ReviewTagChips({super.key, required this.selectedTags, required this.onToggle});
  final List<String> selectedTags;
  final ValueChanged<String> onToggle;

  static const _tags = ['Fast delivery', 'Careful handling', 'Great communication', 'Professional', 'Friendly', 'On time'];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: _tags.map((tag) => FilterChip(
        label: Text(tag),
        selected: selectedTags.contains(tag),
        onSelected: (_) => onToggle(tag),
      )).toList(),
    );
  }
}
