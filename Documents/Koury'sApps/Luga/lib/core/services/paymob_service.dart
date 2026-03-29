/// InstaPay payout service for Egypt-based travelers.
/// Converts USD earnings to EGP and sends via InstaPay bank transfer.
/// See docs/api.md for integration spec.
class InstapayPayoutService {
  InstapayPayoutService._();

  /// Request EGP payout to traveler's InstaPay-linked bank account.
  /// Conversion from USD at market rate via Wise.
  static Future<PayoutResult> requestPayout({
    required String userId,
    required double amountUsd,
    required String bankAccountIban,
    required String idempotencyKey,
  }) async {
    // TODO: Call Edge Function create-instapay-payout
    throw UnimplementedError();
  }
}

class PayoutResult {
  const PayoutResult({
    required this.status,
    required this.amountEgp,
    required this.exchangeRate,
    this.transactionId,
  });

  final PayoutStatus status;
  final double amountEgp;
  final double exchangeRate;
  final String? transactionId;
}

enum PayoutStatus { pending, processing, completed, failed }
