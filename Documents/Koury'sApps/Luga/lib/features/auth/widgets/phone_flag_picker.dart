import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class PhoneFlagPicker extends StatelessWidget {
  const PhoneFlagPicker({
    super.key,
    required this.selectedCode,
    required this.onChanged,
  });

  final String selectedCode;
  final ValueChanged<String> onChanged;

  static const _countries = {
    '+20': '🇪🇬',
    '+1': '🇺🇸',
    '+44': '🇬🇧',
    '+971': '🇦🇪',
    '+966': '🇸🇦',
    '+965': '🇰🇼',
    '+974': '🇶🇦',
    '+90': '🇹🇷',
    '+33': '🇫🇷',
    '+49': '🇩🇪',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCode,
          items: _countries.entries
              .map((e) => DropdownMenuItem(
                    value: e.key,
                    child: Text('${e.value} ${e.key}'),
                  ))
              .toList(),
          onChanged: (code) {
            if (code != null) onChanged(code);
          },
        ),
      ),
    );
  }
}
