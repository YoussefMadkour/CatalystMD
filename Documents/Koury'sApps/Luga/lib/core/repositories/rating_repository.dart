import '../models/rating_model.dart';

abstract class RatingRepository {
  Future<RatingModel> submitRating(RatingModel rating);
  Future<List<RatingModel>> getUserRatings(String userId);
  Future<double> getUserAverageRating(String userId);
  Future<bool> hasRated(String bookingId, String fromUserId);
}
