import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/booking_model.dart';
import '../../repositories/booking_repository.dart';

class SupabaseBookingSource implements BookingRepository {
  SupabaseBookingSource(this._client);
  final SupabaseClient _client;

  @override
  Future<BookingModel> createBooking(BookingModel booking) async {
    final data = await _client.from('bookings').insert(booking.toJson()).select().single();
    return BookingModel.fromJson(data);
  }

  @override
  Future<BookingModel> getBooking(String id) async {
    final data = await _client.from('bookings').select().eq('id', id).single();
    return BookingModel.fromJson(data);
  }

  @override
  Future<List<BookingModel>> getUserBookings(String userId) async {
    final data = await _client.from('bookings').select()
        .or('sender_id.eq.$userId,traveler_id.eq.$userId')
        .order('created_at', ascending: false);
    return data.map((e) => BookingModel.fromJson(e)).toList();
  }

  @override
  Future<BookingModel> updateStatus(String id, BookingStatus status) async {
    final data = await _client.from('bookings').update({'status': status.name}).eq('id', id).select().single();
    return BookingModel.fromJson(data);
  }

  @override
  Future<BookingModel> confirmPickup(String id, String photoUrl) async {
    final data = await _client.from('bookings').update({
      'status': BookingStatus.pickedUp.name,
      'pickup_photo_url': photoUrl,
      'pickup_confirmed_at': DateTime.now().toIso8601String(),
    }).eq('id', id).select().single();
    return BookingModel.fromJson(data);
  }

  @override
  Future<BookingModel> confirmDelivery(String id, String photoUrl) async {
    final data = await _client.from('bookings').update({
      'status': BookingStatus.delivered.name,
      'delivery_photo_url': photoUrl,
      'delivery_confirmed_at': DateTime.now().toIso8601String(),
    }).eq('id', id).select().single();
    return BookingModel.fromJson(data);
  }

  @override
  Stream<BookingModel> watchBooking(String id) {
    return _client
        .from('bookings')
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .map((rows) => BookingModel.fromJson(rows.first));
  }
}
