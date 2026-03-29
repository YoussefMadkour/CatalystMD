import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/route_names.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/luga_button.dart';
import '../providers/auth_notifier.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final phone = GoRouterState.of(context).extra as String;
    final user = await ref.read(authNotifierProvider.notifier).verifyOtp(
          phone,
          _otpController.text,
        );

    if (mounted && user != null) {
      context.goNamed(RouteNames.tripsHome);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter the code we sent', style: AppTypography.headlineMedium),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              style: AppTypography.displayMedium,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(counterText: ''),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(
                  state.error.toString(),
                  style: AppTypography.bodySmall.copyWith(color: Colors.red),
                ),
              ),
            const Spacer(),
            LugaButton(
              label: 'Verify',
              onPressed: _verify,
              isLoading: state.isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
