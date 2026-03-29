import '../models/shipment_model.dart';

abstract class ShipmentRepository {
  Future<List<ShipmentModel>> getShipments({String? senderId, ShipmentStatus? status});
  Future<ShipmentModel> getShipment(String id);
  Future<ShipmentModel> createShipment(ShipmentModel shipment);
  Future<ShipmentModel> updateShipment(ShipmentModel shipment);
  Future<void> deleteShipment(String id);
  Future<List<ShipmentModel>> searchShipments({
    required String departureCity,
    required String arrivalCity,
    String? category,
  });
  Future<void> saveDraft(ShipmentModel draft);
  Future<ShipmentModel?> getDraft(String senderId);
}
