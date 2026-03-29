import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/route_names.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/luga_button.dart';
import '../../../core/widgets/luga_card.dart';

class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('How will you use Luga?', style: TextStyle(fontSize: 24)),
              const SizedBox(height: AppSpacing.xl),
              LugaCard(
                onTap: () => context.goNamed(RouteNames.phoneEntry, extra: 'sender'),
                child: const ListTile(
                  leading: Icon(Icons.send),
                  title: Text('I want to send items'),
                  subtitle: Text('Find travelers heading to your destination'),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              LugaCard(
                onTap: () => context.goNamed(RouteNames.phoneEntry, extra: 'traveler'),
                child: const ListTile(
                  leading: Icon(Icons.flight),
                  title: Text('I\'m a traveler'),
                  subtitle: Text('Earn money delivering items on your trips'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
