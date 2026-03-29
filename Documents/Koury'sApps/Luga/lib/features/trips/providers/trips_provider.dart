import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/trip_model.dart';

final tripsProvider = FutureProvider<List<TripModel>>((ref) async {
  // TODO: Inject TripRepository and fetch trips
  return [];
});
