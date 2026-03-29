/// Single source of truth for all fee logic.
///
/// Sender pays 10% service fee, traveler pays 10% commission,
/// 20% of Luga's cut goes to protection fund,
/// courier add-on splits 80/20, floor price per category.
class PriceCalculator {
  PriceCalculator._();

  static const double senderServiceFeeRate = 0.10;
  static const double travelerCommissionRate = 0.10;
  static const double protectionFundRate = 0.20;
  static const double courierTravelerSplit = 0.80;
  static const double courierPlatformSplit = 0.20;

  static const Map<String, double> _categoryFloors = {
    'electronics': 50.0,
    'clothing': 20.0,
    'cosmetics': 15.0,
    'food': 10.0,
    'documents': 5.0,
    'medicine': 25.0,
    'accessories': 15.0,
    'other': 10.0,
  };

  static double floorFor(String category) {
    return _categoryFloors[category.toLowerCase()] ?? _categoryFloors['other']!;
  }

  static PriceBreakdown calculate({
    required double itemPrice,
    required String category,
    double courierFee = 0,
  }) {
    final floor = floorFor(category);
    final effectivePrice = itemPrice < floor ? floor : itemPrice;

    final serviceFee = effectivePrice * senderServiceFeeRate;
    final commission = effectivePrice * travelerCommissionRate;
    final platformRevenue = serviceFee + commission;
    final protectionFund = platformRevenue * protectionFundRate;

    final courierTravelerPortion = courierFee * courierTravelerSplit;
    final courierPlatformPortion = courierFee * courierPlatformSplit;

    return PriceBreakdown(
      itemPrice: effectivePrice,
      serviceFee: serviceFee,
      commission: commission,
      protectionFund: protectionFund,
      courierFee: courierFee,
      courierTravelerPortion: courierTravelerPortion,
      courierPlatformPortion: courierPlatformPortion,
      senderTotal: effectivePrice + serviceFee + courierFee,
      travelerPayout: effectivePrice - commission + courierTravelerPortion,
      total: effectivePrice + serviceFee + courierFee,
    );
  }
}

class PriceBreakdown {
  const PriceBreakdown({
    required this.itemPrice,
    required this.serviceFee,
    required this.commission,
    required this.protectionFund,
    required this.courierFee,
    required this.courierTravelerPortion,
    required this.courierPlatformPortion,
    required this.senderTotal,
    required this.travelerPayout,
    required this.total,
  });

  final double itemPrice;
  final double serviceFee;
  final double commission;
  final double protectionFund;
  final double courierFee;
  final double courierTravelerPortion;
  final double courierPlatformPortion;
  final double senderTotal;
  final double travelerPayout;
  final double total;
}
