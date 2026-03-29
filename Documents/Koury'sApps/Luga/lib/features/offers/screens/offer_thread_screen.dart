import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../widgets/offer_bubble.dart';
import '../widgets/offer_action_bar.dart';
import '../widgets/negotiation_round_indicator.dart';

class OfferThreadScreen extends ConsumerWidget {
  const OfferThreadScreen({super.key, required this.shipmentId, required this.tripId});
  final String shipmentId;
  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offer negotiation')),
      body: Column(
        children: [
          const NegotiationRoundIndicator(currentRound: 1, maxRounds: 3),
          const Expanded(
            child: Center(child: Text('Offer timeline')),
            // TODO: ListView of OfferBubble widgets from stream
          ),
          const OfferActionBar(),
        ],
      ),
    );
  }
}
