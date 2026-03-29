import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/offer_model.dart';
import '../../repositories/offer_repository.dart';

class SupabaseOfferSource implements OfferRepository {
  SupabaseOfferSource(this._client);
  final SupabaseClient _client;

  @override
  Future<OfferModel> createOffer(OfferModel offer) async {
    final data = await _client.from('offers').insert(offer.toJson()).select().single();
    return OfferModel.fromJson(data);
  }

  @override
  Future<OfferModel> counterOffer(String offerId, double newAmount, {String? message}) async {
    // TODO: Implement counter offer via Edge Function
    throw UnimplementedError();
  }

  @override
  Future<OfferModel> acceptOffer(String offerId) async {
    final data = await _client.from('offers').update({'status': 'accepted'}).eq('id', offerId).select().single();
    return OfferModel.fromJson(data);
  }

  @override
  Future<OfferModel> declineOffer(String offerId) async {
    final data = await _client.from('offers').update({'status': 'declined'}).eq('id', offerId).select().single();
    return OfferModel.fromJson(data);
  }

  @override
  Stream<List<OfferModel>> watchOfferThread(String shipmentId, String tripId) {
    return _client
        .from('offers')
        .stream(primaryKey: ['id'])
        .eq('shipment_id', shipmentId)
        .map((rows) => rows.map((e) => OfferModel.fromJson(e)).toList());
  }

  @override
  Future<List<OfferModel>> getOffersForShipment(String shipmentId) async {
    final data = await _client.from('offers').select().eq('shipment_id', shipmentId).order('created_at');
    return data.map((e) => OfferModel.fromJson(e)).toList();
  }

  @override
  Future<List<OfferModel>> getOffersForTrip(String tripId) async {
    final data = await _client.from('offers').select().eq('trip_id', tripId).order('created_at');
    return data.map((e) => OfferModel.fromJson(e)).toList();
  }
}
