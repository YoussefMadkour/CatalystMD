import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/luga_button.dart';
import '../../../core/widgets/luga_text_field.dart';

class ItemFormScreen extends ConsumerStatefulWidget {
  const ItemFormScreen({super.key});

  @override
  ConsumerState<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends ConsumerState<ItemFormScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Item details')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const LugaTextField(label: 'Item name'),
              const SizedBox(height: AppSpacing.md),
              const LugaTextField(label: 'Category'),
              const SizedBox(height: AppSpacing.md),
              const LugaTextField(label: 'Estimated price', keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.md),
              const LugaTextField(label: 'Weight (kg)', keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.xl),
              LugaButton(
                label: 'Add to cart',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Add item to shipment cart
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
