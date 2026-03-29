import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/luga_button.dart';
import '../../../core/widgets/luga_text_field.dart';

class TopupScreen extends ConsumerWidget {
  const TopupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top up')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        child: Column(
          children: [
            const LugaTextField(label: 'Amount', keyboardType: TextInputType.number, prefix: Icon(Icons.attach_money)),
            const SizedBox(height: AppSpacing.lg),
            // TODO: Payment method selection (Stripe / Paymob)
            const Spacer(),
            LugaButton(label: 'Top up', onPressed: () { /* TODO */ }),
          ],
        ),
      ),
    );
  }
}
