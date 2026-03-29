import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/booking_model.dart';
import '../../../core/repositories/booking_repository.dart';

final bookingNotifierProvider =
    StateNotifierProvider.family<BookingNotifier, AsyncValue<BookingModel?>, String>(
  (ref, bookingId) {
    // TODO: Inject BookingRepository
    throw UnimplementedError();
  },
);

class BookingNotifier extends StateNotifier<AsyncValue<BookingModel?>> {
  BookingNotifier(this._repo, this._bookingId) : super(const AsyncLoading());
  final BookingRepository _repo;
  final String _bookingId;

  Future<void> load() async {
    state = await AsyncValue.guard(() => _repo.getBooking(_bookingId));
  }

  Future<void> confirmPickup(String photoUrl) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.confirmPickup(_bookingId, photoUrl));
  }

  Future<void> confirmDelivery(String photoUrl) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.confirmDelivery(_bookingId, photoUrl));
  }
}
