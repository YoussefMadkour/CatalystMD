import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/luga_card.dart';

class PopularStoresGrid extends StatelessWidget {
  const PopularStoresGrid({super.key});

  static const _stores = ['Amazon', 'eBay', 'Noon', 'Jumia', 'Shein', 'ASOS'];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
      children: _stores
          .map((store) => LugaCard(
                onTap: () { /* TODO: Open store URL */ },
                child: Center(child: Text(store)),
              ))
          .toList(),
    );
  }
}
