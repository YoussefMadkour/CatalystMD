# Luga — External API integration patterns

## Rule: All API calls go through service classes in core/services/
Never call external APIs directly from features or providers.
Always use the service class. Always call from Supabase Edge Functions for server-side APIs.

---

## Supabase Edge Functions
Location: `supabase/functions/`
Runtime: Deno
Each function is a separate folder with `index.ts`

**Functions to create:**
```
supabase/functions/
├── send-message/         # Filter + insert chat message
├── create-payment-intent/ # Stripe payment intent for booking escrow
├── create-booking/       # Validate + create booking atomically
├── release-escrow/       # Delivery confirmed → capture payment → pay traveler
├── cancel-booking/       # Policy-based refund calculation
├── verify-flight/        # AviationStack call (hides API key)
├── scrape-product/       # URL → Open Graph metadata
├── persona-webhook/      # KYC completion → update kyc_level
├── stripe-webhook/       # Stripe payment + Connect payout events
├── create-instapay-payout/ # EGP payout to Egyptian travelers via InstaPay
└── expire-offers/        # Cron: expire offers after 6h
```

---

## AviationStack
**Use:** Flight number verification at trip posting
**Where:** Edge Function `verify-flight` only. API key never sent to client.
**Free tier:** 100 calls/month. Upgrade to $9.99/mo at 50+ trips/month.

```typescript
// supabase/functions/verify-flight/index.ts
const res = await fetch(
  `http://api.aviationstack.com/v1/flights?` +
  `access_key=${Deno.env.get('AVIATIONSTACK_KEY')}&` +
  `flight_iata=${flightNumber}`
);
const data = await res.json();
const flight = data.data?.[0];

// Validate: flight exists, route matches, date matches
const isValid = flight &&
  flight.departure.iata === originIata &&
  flight.arrival.iata === destIata &&
  flight.flight_date === departureDate;

return new Response(JSON.stringify({ verified: isValid, flight }));
```

**Key IATA codes for UAE→Egypt corridor:**
- Dubai: DXB | Abu Dhabi: AUH | Sharjah: SHJ
- Cairo: CAI | Alexandria: HBE

---

## Persona (KYC)
**Use:** Traveler identity verification
**Where:** `core/services/persona_service.dart` → opens WebView
**Cost:** $1.50 per verification check

```dart
// core/services/persona_service.dart
class PersonaService {
  static const String _baseUrl = 'https://withpersona.com/api/v1';

  Future<String> createInquiryUrl(String userId) async {
    final response = await supabase.functions.invoke('create-persona-inquiry',
      body: {'user_id': userId});
    return response.data['inquiry_url'] as String;
  }
}

// In KYC screen — open URL in WebView, catch completion redirect
WebViewController()
  ..setNavigationDelegate(NavigationDelegate(
    onNavigationRequest: (req) {
      if (req.url.contains('persona-complete')) {
        // Parse result from URL params
        _onKycComplete(req.url);
        return NavigationDecision.prevent;
      }
      return NavigationDecision.navigate;
    },
  ))
```

**Template ID:** Set in Supabase Edge Function env var `PERSONA_TEMPLATE_ID`
**Webhook:** `persona-webhook` Edge Function → update `users.kyc_level` + `users.kyc_status`

---

## Stripe (ALL payments — USD-first)
**Use:** Sender payments (Apple Pay / Google Pay primary, credit card fallback) + traveler payouts via Connect
**Where:** `core/services/stripe_service.dart` + Edge Functions
**Funds:** Land in Mercury Bank (USD). Convert to EGP via Wise on your schedule.
**Entity:** US LLC — Stripe US account.

**Important:** Egyptian-issued debit cards may fail 3DS. Credit cards and Apple/Google Pay work fine.
Show Apple Pay and Google Pay as the **primary** payment option in UI — most users will never see a card form.

```dart
// core/services/stripe_service.dart
class StripeService {
  // === SENDER PAYMENTS ===

  // Called from BookingSummaryScreen — Stripe Payment Sheet
  // Apple Pay / Google Pay shown first, card form below
  Future<void> presentPaymentSheet(String clientSecret) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetData: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'Luga',
        // Apple Pay shown prominently on iOS
        applePay: const PaymentSheetApplePay(merchantCountryCode: 'US'),
        // Google Pay shown prominently on Android
        googlePay: const PaymentSheetGooglePay(
          merchantCountryCode: 'US',
          currencyCode: 'USD',
        ),
      ),
    );
    await Stripe.instance.presentPaymentSheet();
  }

  // === TRAVELER PAYOUTS ===

  // Stripe Connect — international travelers (USD payout)
  Future<String> createExpressAccountLink(String userId) async {
    final res = await supabase.functions.invoke('create-stripe-connect',
      body: {'user_id': userId});
    return res.data['url'] as String; // open in WebView
  }
}
```

**Edge Functions for Stripe:**
- `create-payment-intent` → creates Payment Intent with `capture_method: manual`, currency USD
- `create-booking` → validates offer + creates booking + holds payment
- `release-escrow` → captures the Payment Intent on delivery confirmed
- `cancel-booking` → cancels/refunds the Payment Intent
- `stripe-webhook` → handles payment events + Connect payout status

---

## InstaPay (Egyptian traveler payouts)
**Use:** EGP payouts to Egypt-based travelers who prefer local bank transfer
**Where:** Edge Function `create-instapay-payout`
**Flow:** Luga converts USD → EGP at market rate via Wise API, sends EGP to traveler's InstaPay-linked bank account
**When:** Triggered after delivery confirmed + escrow captured

```typescript
// supabase/functions/create-instapay-payout/index.ts
// 1. Calculate EGP amount from USD payout using Wise conversion rate
// 2. Initiate InstaPay transfer to traveler's bank account
// 3. Log in wallet_ledger with idempotency key
// 4. Update booking.payout_status
```

**Traveler setup:** Traveler provides bank name + account number (or IBAN) in payout settings.
**Fallback:** If InstaPay fails, offer Stripe Connect USD payout as alternative.

---

## Product URL Scraper
**Use:** Auto-fill item form from Amazon.ae, Noon, Shein, etc.
**Where:** Edge Function `scrape-product` (server-side — CORS + rate limiting)
**Cache:** Upstash Redis — 24h TTL per URL

```typescript
// supabase/functions/scrape-product/index.ts
const ALLOWED_DOMAINS = [
  'amazon.ae', 'amazon.com', 'noon.com', 'shein.com',
  'namshi.com', 'hm.com', 'zara.com', 'nike.com',
  'carrefouruae.com', 'sharafdg.com', 'asos.com'
];

// Check cache first (Upstash Redis)
// Fetch with iPhone user agent (avoids bot detection)
// Extract: og:title, og:image, og:description, product:price:amount
// Also try JSON-LD structured data for price
// Infer category from title keywords
// Return: { title, description, images[], price, currency, category }
```

**Flutter side:**
```dart
// core/services/scraper_service.dart
class ScraperService {
  Future<ScrapedProduct?> scrape(String url) async {
    try {
      final res = await supabase.functions.invoke('scrape-product',
        body: {'url': url});
      if (res.data['error'] != null) return null;
      return ScrapedProduct.fromJson(res.data);
    } catch (_) {
      return null; // Always fail gracefully — fall back to manual entry
    }
  }
}
```

---

## FCM (Push Notifications)
**Use:** All real-time user notifications
**Where:** `core/services/fcm_service.dart` + Edge Functions send via Firebase Admin SDK

```dart
// core/services/fcm_service.dart
class FcmService {
  Future<void> init() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Request permission
    await FirebaseMessaging.instance.requestPermission();

    // Save FCM token to users table
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) await _saveToken(token);
  }

  void _handleNotificationTap(RemoteMessage message) {
    final deepLink = message.data['deep_link'];
    if (deepLink != null) router.go(deepLink); // go_router navigation
  }
}
```

**Notification types and deep links:**
```
new_offer           → /offers/{shipment_id}
offer_accepted      → /bookings/{booking_id}/summary
booking_confirmed   → /bookings/{booking_id}
traveler_landed     → /bookings/{booking_id}/handoff
delivery_confirmed  → /bookings/{booking_id}/rating
payment_released    → /wallet
new_message         → /chat/{booking_id}
kyc_approved        → /profile
```

---

## Mixpanel Analytics
**Use:** Track all key user actions from day one
**Where:** `core/services/analytics_service.dart`

```dart
// core/services/analytics_service.dart
class AnalyticsService {
  static final _mixpanel = Mixpanel('YOUR_PROJECT_TOKEN');

  static void track(String event, [Map<String, dynamic>? props]) {
    _mixpanel.track(event, properties: props);
  }

  // Key events to track:
  // auth_completed, kyc_started, kyc_completed
  // trip_posted, shipment_posted, item_added_via_url, item_added_manual
  // offer_sent, offer_accepted, offer_declined, offer_expired
  // booking_created, pickup_confirmed, delivery_confirmed
  // escrow_released, dispute_opened
  // wallet_topup_started, wallet_topup_completed
  // chat_message_sent, chat_message_blocked
  // search_performed, traveler_card_tapped, shipment_card_tapped
}
```
