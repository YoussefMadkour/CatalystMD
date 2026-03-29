import 'package:flutter/material.dart';

import '../../../core/models/shipment_item_model.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';

class ItemCartTile extends StatelessWidget {
  const ItemCartTile({super.key, required this.item, this.onRemove});
  final ShipmentItemModel item;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name, style: AppTypography.titleMedium),
      subtitle: Text('${item.category} • ${Formatters.weight(item.weight)}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(Formatters.currency(item.price), style: AppTypography.labelLarge),
          if (onRemove != null)
            IconButton(icon: const Icon(Icons.close, size: 18), onPressed: onRemove),
        ],
      ),
    );
  }
}
