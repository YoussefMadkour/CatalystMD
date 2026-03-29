import '../models/trip_model.dart';

abstract class TripRepository {
  Future<List<TripModel>> getTrips({String? travelerId, TripStatus? status});
  Future<TripModel> getTrip(String id);
  Future<TripModel> createTrip(TripModel trip);
  Future<TripModel> updateTrip(TripModel trip);
  Future<void> deleteTrip(String id);
  Future<List<TripModel>> searchTrips({
    required String departureCity,
    required String arrivalCity,
    DateTime? date,
    String? category,
  });
  Future<void> saveDraft(TripModel draft);
  Future<TripModel?> getDraft(String travelerId);
}
