import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/shipment_model.dart';

final shipmentsProvider = FutureProvider<List<ShipmentModel>>((ref) async {
  // TODO: Inject ShipmentRepository and fetch shipments
  return [];
});
