import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class PhotoProofUploader extends StatelessWidget {
  const PhotoProofUploader({super.key, required this.label, this.onUploaded});
  final String label;
  final ValueChanged<String>? onUploaded;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Open image picker
      },
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.border, style: BorderStyle.solid),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.camera_alt, size: 48, color: AppColors.textTertiary),
            const SizedBox(height: AppSpacing.sm),
            Text(label, style: AppTypography.bodyMedium),
          ],
        ),
      ),
    );
  }
}
