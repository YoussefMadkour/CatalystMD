import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/shipment_item_model.dart';

final createShipmentNotifierProvider =
    StateNotifierProvider<CreateShipmentNotifier, CreateShipmentState>((ref) {
  return CreateShipmentNotifier();
});

class CreateShipmentState {
  const CreateShipmentState({
    this.items = const [],
    this.departureCity,
    this.arrivalCity,
    this.isSubmitting = false,
  });

  final List<ShipmentItemModel> items;
  final String? departureCity;
  final String? arrivalCity;
  final bool isSubmitting;
}

class CreateShipmentNotifier extends StateNotifier<CreateShipmentState> {
  CreateShipmentNotifier() : super(const CreateShipmentState());

  void addItem(ShipmentItemModel item) {
    state = CreateShipmentState(items: [...state.items, item]);
  }

  void removeItem(String itemId) {
    state = CreateShipmentState(
      items: state.items.where((i) => i.id != itemId).toList(),
    );
  }

  Future<void> submit() async {
    // TODO: Create shipment via repository, save drafts on each step
  }
}
