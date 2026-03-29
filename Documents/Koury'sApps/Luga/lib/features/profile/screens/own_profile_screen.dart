import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/luga_avatar.dart';
import '../../../core/widgets/luga_badge.dart';
import '../widgets/trust_indicators_row.dart';

class OwnProfileScreen extends ConsumerWidget {
  const OwnProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile'), actions: [
        IconButton(icon: const Icon(Icons.settings), onPressed: () { /* TODO: Navigate to settings */ }),
      ]),
      body: user == null
          ? const Center(child: Text('Not logged in'))
          : Padding(
              padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
              child: Column(
                children: [
                  LugaAvatar(name: user.name, imageUrl: user.avatarUrl, radius: 48),
                  const SizedBox(height: AppSpacing.sm),
                  Text(user.name, style: AppTypography.headlineMedium),
                  const SizedBox(height: AppSpacing.xs),
                  if (user.isVerified) const LugaBadge(label: 'Verified', type: BadgeType.verified, icon: Icons.verified),
                  const SizedBox(height: AppSpacing.lg),
                  TrustIndicatorsRow(rating: user.rating, trips: user.totalTrips, shipments: user.totalShipments),
                  // TODO: Tabs for reviews, completed bookings
                ],
              ),
            ),
    );
  }
}
