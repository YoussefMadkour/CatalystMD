import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/user_model.dart';
import '../../../core/models/rating_model.dart';

final userProfileProvider = FutureProvider.family<UserModel, String>((ref, userId) async {
  // TODO: Fetch user profile
  throw UnimplementedError();
});

final userRatingsProvider = FutureProvider.family<List<RatingModel>, String>((ref, userId) async {
  // TODO: Fetch user ratings
  return [];
});
