import 'package:supabase_flutter/supabase_flutter.dart';

/// ALL payments via Stripe. Apple Pay / Google Pay primary, card fallback.
/// Funds land in Mercury Bank (USD). See docs/api.md for full integration spec.
class StripeService {
  StripeService._();

  static Future<void> initialize(String publishableKey) async {
    // TODO: Stripe.publishableKey = publishableKey;
    // TODO: Stripe.merchantIdentifier = 'merchant.com.luga';
    // TODO: await Stripe.instance.applySettings();
  }

  // === SENDER PAYMENTS ===

  /// Present Stripe Payment Sheet with Apple Pay / Google Pay prominently shown.
  /// Card form is the fallback below digital wallets.
  static Future<void> presentPaymentSheet(String clientSecret) async {
    // TODO: Implement with flutter_stripe
    // await Stripe.instance.initPaymentSheet(
    //   paymentSheetData: SetupPaymentSheetParameters(
    //     paymentIntentClientSecret: clientSecret,
    //     merchantDisplayName: 'Luga',
    //     applePay: const PaymentSheetApplePay(merchantCountryCode: 'US'),
    //     googlePay: const PaymentSheetGooglePay(
    //       merchantCountryCode: 'US',
    //       currencyCode: 'USD',
    //     ),
    //   ),
    // );
    // await Stripe.instance.presentPaymentSheet();
    throw UnimplementedError();
  }

  /// Create payment intent via Edge Function. Returns client secret.
  /// Uses capture_method: manual for escrow hold pattern.
  static Future<String> createPaymentIntent({
    required double amountUsd,
    required String bookingId,
    required String idempotencyKey,
  }) async {
    final res = await Supabase.instance.client.functions.invoke(
      'create-payment-intent',
      body: {
        'amount_cents': (amountUsd * 100).round(),
        'currency': 'usd',
        'booking_id': bookingId,
        'idempotency_key': idempotencyKey,
      },
    );
    return res.data['client_secret'] as String;
  }

  // === TRAVELER PAYOUTS ===

  /// Create Stripe Connect Express account link for international travelers.
  static Future<String> createExpressAccountLink(String userId) async {
    final res = await Supabase.instance.client.functions.invoke(
      'create-stripe-connect',
      body: {'user_id': userId},
    );
    return res.data['url'] as String;
  }
}
