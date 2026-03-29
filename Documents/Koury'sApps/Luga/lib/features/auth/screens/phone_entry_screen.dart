import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/luga_button.dart';
import '../../../core/widgets/luga_snackbar.dart';
import '../providers/auth_notifier.dart';
import '../widgets/phone_flag_picker.dart';

class PhoneEntryScreen extends ConsumerStatefulWidget {
  const PhoneEntryScreen({super.key});

  @override
  ConsumerState<PhoneEntryScreen> createState() => _PhoneEntryScreenState();
}

class _PhoneEntryScreenState extends ConsumerState<PhoneEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String _countryCode = '+20';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final phone = '$_countryCode${_phoneController.text.trim()}';
    ref.read(authNotifierProvider.notifier).clearError();
    await ref.read(authNotifierProvider.notifier).sendOtp(phone);

    if (!mounted) return;

    final state = ref.read(authNotifierProvider);
    if (state.error != null) {
      LugaSnackbar.show(context, message: state.error!, type: SnackbarType.error);
    } else if (state.otpSent) {
      context.goNamed(RouteNames.otp, extra: phone);
    }
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 8 || digitsOnly.length > 15) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final state = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(8.h),
                Text(
                  'Enter your phone number',
                  style: AppTypography.h1(locale),
                ),
                Gap(8.h),
                Text(
                  'We\'ll send you a verification code to confirm your identity.',
                  style: AppTypography.body(locale),
                ),
                Gap(32.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PhoneFlagPicker(
                      selectedCode: _countryCode,
                      onChanged: (code) => setState(() => _countryCode = code),
                    ),
                    Gap(AppSpacing.sm.w),
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        textDirection: TextDirection.ltr,
                        validator: _validatePhone,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: '1012345678',
                          hintStyle: TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                LugaButton(
                  label: 'Send Code',
                  onPressed: state.isLoading ? null : _submit,
                  isLoading: state.isLoading,
                ),
                Gap(AppSpacing.screenVertical.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
