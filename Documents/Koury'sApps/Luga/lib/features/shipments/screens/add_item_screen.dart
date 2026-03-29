import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/luga_card.dart';

class AddItemScreen extends StatelessWidget {
  const AddItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add item')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        child: Column(
          children: [
            LugaCard(
              onTap: () { /* TODO: Navigate to URL scraper */ },
              child: const ListTile(
                leading: Icon(Icons.link),
                title: Text('Paste a product URL'),
                subtitle: Text('We\'ll fetch the details automatically'),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            LugaCard(
              onTap: () { /* TODO: Navigate to manual form */ },
              child: const ListTile(
                leading: Icon(Icons.edit),
                title: Text('Enter manually'),
                subtitle: Text('Fill in item details yourself'),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            LugaCard(
              onTap: () { /* TODO: Navigate to photo entry */ },
              child: const ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a photo'),
                subtitle: Text('Snap a picture of the item'),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            LugaCard(
              onTap: () { /* TODO: Navigate to popular stores */ },
              child: const ListTile(
                leading: Icon(Icons.store),
                title: Text('Browse popular stores'),
                subtitle: Text('Pick from popular shopping sites'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
