import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/luga_text_field.dart';
import '../../../core/widgets/luga_button.dart';

class UrlScraperField extends StatelessWidget {
  const UrlScraperField({super.key, this.onScraped});
  final ValueChanged<Map<String, dynamic>>? onScraped;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const LugaTextField(label: 'Product URL', hint: 'https://...'),
        const SizedBox(height: AppSpacing.sm),
        LugaButton(
          label: 'Fetch details',
          variant: LugaButtonVariant.secondary,
          onPressed: () {
            // TODO: Call scraper service
          },
        ),
      ],
    );
  }
}
