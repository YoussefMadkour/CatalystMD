import '../models/booking_model.dart';

abstract class BookingRepository {
  Future<BookingModel> createBooking(BookingModel booking);
  Future<BookingModel> getBooking(String id);
  Future<List<BookingModel>> getUserBookings(String userId);
  Future<BookingModel> updateStatus(String id, BookingStatus status);
  Future<BookingModel> confirmPickup(String id, String photoUrl);
  Future<BookingModel> confirmDelivery(String id, String photoUrl);
  Stream<BookingModel> watchBooking(String id);
}
