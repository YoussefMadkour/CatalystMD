import '../models/offer_model.dart';

abstract class OfferRepository {
  Future<OfferModel> createOffer(OfferModel offer);
  Future<OfferModel> counterOffer(String offerId, double newAmount, {String? message});
  Future<OfferModel> acceptOffer(String offerId);
  Future<OfferModel> declineOffer(String offerId);
  Stream<List<OfferModel>> watchOfferThread(String shipmentId, String tripId);
  Future<List<OfferModel>> getOffersForShipment(String shipmentId);
  Future<List<OfferModel>> getOffersForTrip(String tripId);
}
