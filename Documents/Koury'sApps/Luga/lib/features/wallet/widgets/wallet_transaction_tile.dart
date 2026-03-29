import 'package:flutter/material.dart';

import '../../../core/models/wallet_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';

class WalletTransactionTile extends StatelessWidget {
  const WalletTransactionTile({super.key, required this.transaction});
  final WalletTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final isPositive = transaction.amount > 0;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isPositive ? AppColors.success.withValues(alpha: 0.1) : AppColors.error.withValues(alpha: 0.1),
        child: Icon(isPositive ? Icons.arrow_downward : Icons.arrow_upward, color: isPositive ? AppColors.success : AppColors.error),
      ),
      title: Text(transaction.description, style: AppTypography.titleMedium),
      subtitle: Text(Formatters.relativeTime(transaction.createdAt), style: AppTypography.bodySmall),
      trailing: Text(
        '${isPositive ? "+" : ""}${Formatters.currency(transaction.amount)}',
        style: AppTypography.titleMedium.copyWith(color: isPositive ? AppColors.success : AppColors.error),
      ),
    );
  }
}
