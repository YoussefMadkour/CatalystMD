import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/rating_model.dart';
import '../../repositories/rating_repository.dart';

class SupabaseRatingSource implements RatingRepository {
  SupabaseRatingSource(this._client);
  final SupabaseClient _client;

  @override
  Future<RatingModel> submitRating(RatingModel rating) async {
    final data = await _client.from('ratings').insert(rating.toJson()).select().single();
    return RatingModel.fromJson(data);
  }

  @override
  Future<List<RatingModel>> getUserRatings(String userId) async {
    final data = await _client.from('ratings').select().eq('to_user_id', userId).order('created_at', ascending: false);
    return data.map((e) => RatingModel.fromJson(e)).toList();
  }

  @override
  Future<double> getUserAverageRating(String userId) async {
    final data = await _client.from('ratings').select('score').eq('to_user_id', userId);
    if (data.isEmpty) return 0;
    final total = data.fold<int>(0, (sum, row) => sum + (row['score'] as int));
    return total / data.length;
  }

  @override
  Future<bool> hasRated(String bookingId, String fromUserId) async {
    final data = await _client.from('ratings').select('id').eq('booking_id', bookingId).eq('from_user_id', fromUserId).maybeSingle();
    return data != null;
  }
}
