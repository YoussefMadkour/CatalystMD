import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/trip_model.dart';
import '../../repositories/trip_repository.dart';

class SupabaseTripSource implements TripRepository {
  SupabaseTripSource(this._client);

  final SupabaseClient _client;

  @override
  Future<List<TripModel>> getTrips({String? travelerId, TripStatus? status}) async {
    var query = _client.from('trips').select();
    if (travelerId != null) query = query.eq('traveler_id', travelerId);
    if (status != null) query = query.eq('status', status.name);
    final data = await query.order('departure_date');
    return data.map((e) => TripModel.fromJson(e)).toList();
  }

  @override
  Future<TripModel> getTrip(String id) async {
    final data = await _client.from('trips').select().eq('id', id).single();
    return TripModel.fromJson(data);
  }

  @override
  Future<TripModel> createTrip(TripModel trip) async {
    final data = await _client.from('trips').insert(trip.toJson()).select().single();
    return TripModel.fromJson(data);
  }

  @override
  Future<TripModel> updateTrip(TripModel trip) async {
    final data = await _client.from('trips').update(trip.toJson()).eq('id', trip.id).select().single();
    return TripModel.fromJson(data);
  }

  @override
  Future<void> deleteTrip(String id) async {
    await _client.from('trips').delete().eq('id', id);
  }

  @override
  Future<List<TripModel>> searchTrips({
    required String departureCity,
    required String arrivalCity,
    DateTime? date,
    String? category,
  }) async {
    var query = _client
        .from('trips')
        .select()
        .eq('departure_city', departureCity)
        .eq('arrival_city', arrivalCity)
        .eq('status', TripStatus.active.name);
    final data = await query.order('departure_date');
    return data.map((e) => TripModel.fromJson(e)).toList();
  }

  @override
  Future<void> saveDraft(TripModel draft) async {
    await _client.from('trip_drafts').upsert(draft.toJson());
  }

  @override
  Future<TripModel?> getDraft(String travelerId) async {
    final data = await _client
        .from('trip_drafts')
        .select()
        .eq('traveler_id', travelerId)
        .maybeSingle();
    return data != null ? TripModel.fromJson(data) : null;
  }
}
