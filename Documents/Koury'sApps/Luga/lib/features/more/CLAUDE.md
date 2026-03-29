# more — spec

## What this feature does
The "More" tab — account management, settings, trust-building content,
legal pages, and utility screens. Low complexity, high completeness requirement
(Apple requires account deletion; trust pages convert skeptical new users).

## Screens
- `MoreScreen` — menu list: profile card at top, all menu items below
- `SettingsScreen` — language toggle, notification preferences, payout details link
- `HowItWorksScreen` — 3-step explainer: Post → Match → Deliver + Earn
- `TrustSafetyScreen` — guarantee details, KYC process, escrow explanation, prohibited items
- `NotificationsScreen` — notification center: all notifications, unread badges, deep links
- `DeleteAccountScreen` — account deletion with 30-day grace period

## State
- `SettingsNotifier (StateNotifier<SettingsState>)` — language, notification prefs
- `notificationsProvider (StreamProvider<List<NotificationModel>>)` — real-time notification list

## Data
- Models: `NotificationModel`
- Repository: `NotificationRepository`
- Table: `notifications` — see docs/schema.md

## MoreScreen layout
```
Profile card at top (tappable → OwnProfileScreen):
  Avatar (60px) | Display name | Unread badge (red dot if any)
  "عرض الملف الشخصي / View profile" button

Menu sections:
  ─── Account ───
  ⚙ Settings               → SettingsScreen
  💳 Payout details         → Stripe Express dashboard (WebView)
  👛 Wallet                 → WalletScreen
  🎁 Promo code / Refer     → referral code screen
  ─── Help ───
  ❓ How Luga works         → HowItWorksScreen
  🛡 Trust & Safety         → TrustSafetyScreen
  💬 Contact support        → opens email or WhatsApp (configurable)
  ─── Info ───
  📄 Terms of use           → WebView or embedded scroll view
  🔒 Privacy policy         → WebView or embedded scroll view
  ─── Danger ───
  🗑 Delete account         → DeleteAccountScreen
```

## NotificationsScreen
```
Top: "الإشعارات / Notifications" title + "Mark all read" button
Filter tabs: All | Unread

Each notification row (tappable → deep link):
  Left: type icon (colored circle — teal for booking, amber for payment, etc.)
  Center: title (bold if unread) + body (1 line, truncated) + relative time
  Right: unread dot (teal) if unread

Tapping notification:
  → Mark as read (update notifications.read = true)
  → Navigate to deep_link stored in notification row

Empty state: bell illustration + "لا توجد إشعارات حتى الآن / No notifications yet"
```

## Notification types + deep links
```dart
const notificationDeepLinks = {
  'new_offer':           '/offers/:id',
  'offer_accepted':      '/bookings/:id/summary',
  'booking_confirmed':   '/bookings/:id',
  'traveler_landed':     '/bookings/:id/handoff',
  'delivery_confirmed':  '/bookings/:id/rating',
  'payment_released':    '/wallet',
  'new_message':         '/inbox/:bookingId',
  'kyc_approved':        '/profile',
  'kyc_failed':          '/onboarding/kyc',
  'dispute_opened':      '/dispute/:bookingId',
  'dispute_resolved':    '/bookings/:id',
};
```

## DeleteAccountScreen — Apple App Store required
```
Screen content:
  Title: "حذف الحساب / Delete account"
  Warning card:
    "سيتم حذف حسابك وجميع بياناتك نهائياً بعد 30 يوماً.
     خلال هذه الفترة يمكنك التراجع بتسجيل الدخول مجدداً."

  Blocker check (shown if applicable):
    If user has active bookings:
      "لا يمكن حذف الحساب أثناء وجود حجوزات نشطة.
       أكمل أو ألغِ حجوزاتك أولاً."
      → CTA: "عرض الحجوزات النشطة" — disabled delete button

  If no active bookings:
    Reason dropdown (optional): Why are you leaving?
    "أنا متأكد — احذف حسابي" button (red, destructive)
    → Confirmation dialog: "هذا الإجراء لا يمكن التراجع عنه بعد 30 يوماً."
    → On confirm: set users.deletion_requested_at = NOW()
    → Sign out user
    → Show: "تم طلب الحذف. حسابك سيُحذف بعد 30 يوماً."
    → Supabase cron deletes account after 30 days if not cancelled
```

## HowItWorksScreen
```
Tab toggle: "للمرسِلين / For Senders" | "للمسافرين / For Travelers"

Senders tab:
  Step 1: 📦 انشر طلبك / Post your request
    "أضف غرضك مع صور وسعر مقترح"
  Step 2: 🤝 اختر مسافراً / Choose a traveler
    "تصفح المسافرين الموثوقين واعرض سعراً"
  Step 3: ✅ استلم غرضك / Receive your item
    "أكد الاستلام وأطلق الدفع — محمي بضمان $1,000"

Travelers tab:
  Step 1: ✈️ انشر رحلتك / Post your trip
    "أضف مسارك وما يمكنك حمله"
  Step 2: 📱 اقبل طلبات / Accept requests
    "تصفح الطلبات على مسارك واستلم الغرض"
  Step 3: 💰 اكسب المال / Earn money
    "سلّم الغرض واستلم مدفوعاتك خلال 24 ساعة"
```

## Business rules
- Account deletion blocked if user has active bookings (status not in completed/cancelled/refunded)
- 30-day grace period: user can log back in to cancel deletion request
- Supabase cron permanently deletes after 30 days (cascade deletes handle related data)
- Language change takes effect immediately — app does NOT need restart (Riverpod locale state)
- Notification deep links must work even if the booking/offer no longer exists (show graceful error)

## Acceptance criteria
- [ ] Account deletion blocked with clear message when active bookings exist
- [ ] Deletion sets deletion_requested_at — account NOT deleted immediately
- [ ] User signed out after requesting deletion
- [ ] Language toggle switches AR↔EN immediately with no restart
- [ ] Notification taps navigate to correct deep link
- [ ] Unread notification count badge appears on bottom nav "More" icon
- [ ] "Mark all read" updates all unread notifications
- [ ] Contact support opens correct channel (email or WhatsApp)
- [ ] ToS and Privacy Policy accessible without being logged in

## What NOT to build here
- Payout history → features/wallet/
- KYC re-verification → features/onboarding/
- Profile editing → features/profile/OwnProfileScreen
