import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/shipment_model.dart';
import '../../repositories/shipment_repository.dart';

class SupabaseShipmentSource implements ShipmentRepository {
  SupabaseShipmentSource(this._client);

  final SupabaseClient _client;

  @override
  Future<List<ShipmentModel>> getShipments({String? senderId, ShipmentStatus? status}) async {
    var query = _client.from('shipments').select('*, items:shipment_items(*)');
    if (senderId != null) query = query.eq('sender_id', senderId);
    if (status != null) query = query.eq('status', status.name);
    final data = await query.order('created_at', ascending: false);
    return data.map((e) => ShipmentModel.fromJson(e)).toList();
  }

  @override
  Future<ShipmentModel> getShipment(String id) async {
    final data = await _client.from('shipments').select('*, items:shipment_items(*)').eq('id', id).single();
    return ShipmentModel.fromJson(data);
  }

  @override
  Future<ShipmentModel> createShipment(ShipmentModel shipment) async {
    final data = await _client.from('shipments').insert(shipment.toJson()).select().single();
    return ShipmentModel.fromJson(data);
  }

  @override
  Future<ShipmentModel> updateShipment(ShipmentModel shipment) async {
    final data = await _client.from('shipments').update(shipment.toJson()).eq('id', shipment.id).select().single();
    return ShipmentModel.fromJson(data);
  }

  @override
  Future<void> deleteShipment(String id) async {
    await _client.from('shipments').delete().eq('id', id);
  }

  @override
  Future<List<ShipmentModel>> searchShipments({
    required String departureCity,
    required String arrivalCity,
    String? category,
  }) async {
    final data = await _client
        .from('shipments')
        .select('*, items:shipment_items(*)')
        .eq('departure_city', departureCity)
        .eq('arrival_city', arrivalCity)
        .eq('status', ShipmentStatus.posted.name)
        .order('created_at', ascending: false);
    return data.map((e) => ShipmentModel.fromJson(e)).toList();
  }

  @override
  Future<void> saveDraft(ShipmentModel draft) async {
    await _client.from('shipment_drafts').upsert(draft.toJson());
  }

  @override
  Future<ShipmentModel?> getDraft(String senderId) async {
    final data = await _client
        .from('shipment_drafts')
        .select()
        .eq('sender_id', senderId)
        .maybeSingle();
    return data != null ? ShipmentModel.fromJson(data) : null;
  }
}
