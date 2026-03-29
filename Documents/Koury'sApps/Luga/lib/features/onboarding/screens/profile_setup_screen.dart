import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/luga_button.dart';
import '../../../core/widgets/luga_text_field.dart';
import '../../../core/widgets/luga_avatar.dart';
import '../providers/onboarding_notifier.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set up your profile')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.lg),
              GestureDetector(
                onTap: () {
                  // TODO: Pick avatar image
                },
                child: const LugaAvatar(name: '', radius: 48),
              ),
              const SizedBox(height: AppSpacing.lg),
              LugaTextField(
                label: 'Full name',
                controller: _nameController,
                validator: (v) => v?.isEmpty == true ? 'Name is required' : null,
              ),
              const Spacer(),
              LugaButton(
                label: 'Continue',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Save profile and navigate
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
