# chat — spec

## What this feature does
In-app messaging between matched traveler and sender per booking.
Pre-payment: max 10 messages (conversion gate to booking).
Post-payment: unlimited. All messages server-side filtered before storage.
Auto-closes to read-only 72h after delivery_confirmed.

## Screens
- `InboxScreen` — list of all conversations: avatar, last message preview, unread count badge, timestamp
- `ConversationScreen` — real-time chat with message bubbles, input bar, pre-payment gate banner

## Widgets
- `MessageBubble` — sender right-aligned (AppColors.primaryLight bg), traveler left-aligned (AppColors.surface bg), timestamps below, system messages centered (grey, italic)
- `MessageInputBar` — text field + send button. Arabic RTL text input handled automatically via locale.
- `PrePaymentGateBanner` — yellow banner: "7 of 10 messages used — Book to keep chatting". Shown from message 7 onward.
- `BookingShortcutCard` — inline CTA shown at message 10: "Ready to book? Lock this deal." with Book button.

## State
- `ChatNotifier (StateNotifier<ChatState>)` — send message (via Edge Function), message count tracking
- `messagesProvider (StreamProvider<List<MessageModel>>)` — real-time via Supabase Realtime
- `inboxProvider (StreamProvider<List<ConversationSummary>>)` — all conversations with metadata

## Data
- Models: `MessageModel`, `ConversationSummary`
- Repository: `ChatRepository` → `SupabaseChatRepository`
- Table: `messages` — see docs/schema.md

## Sending messages — always via Edge Function
```dart
// WRONG — bypasses filter
await supabase.from('messages').insert({...});

// RIGHT — server-side filter runs first
final result = await supabase.functions.invoke('send-message', body: {
  'booking_id': bookingId,
  'body': messageText,
});

switch (result.data['error']) {
  case 'CONTACT_INFO_DETECTED':
    LugaSnackbar.warn(context, 'لا يمكن مشاركة أرقام الهاتف في المحادثة');
    // Message was NOT sent — do not add to local list optimistically
    break;
  case 'SOCIAL_HANDLE_DETECTED':
    LugaSnackbar.warn(context, 'لا يمكن مشاركة حسابات التواصل الاجتماعي');
    break;
  case 'OFF_APP_PAYMENT':
    LugaSnackbar.warn(context, 'جميع المدفوعات تتم داخل التطبيق فقط');
    break;
  case 'MESSAGE_LIMIT_REACHED':
    // Show BookingShortcutCard inline
    break;
}
```

## Filter patterns (enforced in Edge Function send-message)
```typescript
const PATTERNS = {
  egyptianPhone:   /(\+?20|0)?1[0-2,5][0-9]{8}/g,
  uaePhone:        /(\+?971|0)?5[0-9]{8}/g,
  saudiPhone:      /(\+?966|0)?5[0-9]{8}/g,
  genericIntl:     /\+?[0-9\s\-().]{9,15}/g,
  socialHandle:    /@[a-zA-Z0-9_.]{2,}/g,
  whatsapp:        /wa\.me\//gi,
  telegram:        /t\.me\//gi,
  instagram:       /instagram\.com/gi,
  tiktok:          /tiktok\.com/gi,
  instapay:        /instapay/gi,
  vodafoneCash:    /vodafone.?cash/gi,
  directPayment:   /pay.?(me|you|directly)/gi,
  outsideApp:      /outside.?(app|luga)/gi,
};
// Blocked messages: store with flagged=true, flag_reason set, return error
// NOT silently dropped — stored for admin review in Supabase Studio
```

## Pre-payment message limit
```typescript
// In Edge Function send-message:
const booking = await getBooking(bookingId);
if (booking.status === 'awaiting_payment') {
  const { count } = await supabase
    .from('messages')
    .select('*', { count: 'exact', head: true })
    .eq('booking_id', bookingId)
    .eq('is_system', false);

  if (count >= 10) {
    return { error: 'MESSAGE_LIMIT_REACHED', count: 10 };
  }
  // Return current count so Flutter can show "7 of 10"
  return { ..., pre_payment_count: count + 1 };
}
```

## Realtime subscription
```dart
// In ConversationScreen
final messages = ref.watch(messagesProvider(bookingId));
return messages.when(
  data: (msgs) => ListView.builder(
    reverse: true,           // newest at bottom
    itemCount: msgs.length,
    itemBuilder: (_, i) => MessageBubble(
      message: msgs[i],
      isMe: msgs[i].senderId == currentUserId,
    ),
  ),
  loading: () => LugaShimmer.chatList(),
  error: (e, _) => LugaEmptyState.error(
    onRetry: () => ref.refresh(messagesProvider(bookingId)),
  ),
);
```

## Arabic text input
```dart
// MessageInputBar text field
TextField(
  // Do NOT set textDirection manually — let locale handle it
  // Flutter + IBM Plex Arabic handles mixed AR/EN automatically
  keyboardType: TextInputType.multiline,
  maxLines: 4,
  textAlignVertical: TextAlignVertical.center,
)
// Test on real Arabic-locale Android device — mixed AR+EN numbers
// must render correctly (e.g. "أريد iPhone 15" should display properly)
```

## Business rules
- ALL messages sent via Edge Function — never direct DB insert from client
- Blocked messages stored with flagged=true — NOT silently dropped
- Pre-payment limit: 10 messages — enforced server-side, client shows count
- System messages (booking status updates) do NOT count toward 10-message limit
- Chat read-only 72h after delivery_confirmed — no new inserts permitted
- Phone reveal (for door delivery) happens in HandoffScreen — NEVER via chat
- Report button available on long-press of any message

## Acceptance criteria
- [ ] Egyptian phone regex (+2010...) blocked — sender sees Arabic explanation
- [ ] UAE phone regex (+9715...) blocked
- [ ] Social @handle blocked
- [ ] WhatsApp link (wa.me/) blocked
- [ ] "Instapay" text blocked
- [ ] Blocked messages stored with flagged=true (verify in Supabase Studio)
- [ ] Pre-payment count shows "7 of 10 messages used" from message 7
- [ ] BookingShortcutCard shown inline at message 10 — message NOT sent
- [ ] Messages load under 1 second on real 4G (test on physical device)
- [ ] Mixed Arabic + English + numbers renders correctly on Android 10+
- [ ] Chat shows read-only banner 72h after delivery_confirmed

## What NOT to build here
- Offer negotiation → features/offers/
- Handoff coordination (post-landing) → features/bookings/HandoffScreen
- Phone number reveal → features/bookings/HandoffScreen only
