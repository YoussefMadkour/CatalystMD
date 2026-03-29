import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/offer_model.dart';
import '../../../core/repositories/offer_repository.dart';

final offerNotifierProvider =
    StateNotifierProvider<OfferNotifier, AsyncValue<void>>((ref) {
  // TODO: Inject OfferRepository
  throw UnimplementedError();
});

class OfferNotifier extends StateNotifier<AsyncValue<void>> {
  OfferNotifier(this._repo) : super(const AsyncData(null));
  final OfferRepository _repo;

  Future<void> createOffer(OfferModel offer) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.createOffer(offer));
  }

  Future<void> counter(String offerId, double amount, {String? message}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.counterOffer(offerId, amount, message: message));
  }

  Future<void> accept(String offerId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.acceptOffer(offerId));
  }

  Future<void> decline(String offerId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.declineOffer(offerId));
  }
}
