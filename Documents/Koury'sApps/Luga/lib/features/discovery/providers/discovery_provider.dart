import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/trip_model.dart';
import '../../../core/models/shipment_model.dart';

final travelerFeedProvider = FutureProvider<List<TripModel>>((ref) async {
  // TODO: Fetch available trips
  return [];
});

final shipmentFeedProvider = FutureProvider<List<ShipmentModel>>((ref) async {
  // TODO: Fetch available shipment requests
  return [];
});
