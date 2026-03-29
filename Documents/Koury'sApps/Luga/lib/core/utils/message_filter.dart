/// Client-side regex filter for phone/social/off-app patterns.
/// NOTE: The real enforcement happens server-side in the Edge Function.
/// This is a UX hint only — not a security boundary.
class MessageFilter {
  MessageFilter._();

  static final _patterns = [
    RegExp(r'\+?\d{7,15}'),                     // Phone numbers
    RegExp(r'@[\w.]+', caseSensitive: false),    // Social handles
    RegExp(r'whatsapp|telegram|signal|viber|wechat', caseSensitive: false),
    RegExp(r'instagram|facebook|twitter|snap', caseSensitive: false),
    RegExp(r'[\w.]+@[\w.]+\.\w{2,}'),           // Emails
  ];

  static bool containsOffPlatformContact(String text) {
    return _patterns.any((pattern) => pattern.hasMatch(text));
  }

  static String sanitize(String text) {
    var result = text;
    for (final pattern in _patterns) {
      result = result.replaceAll(pattern, '[removed]');
    }
    return result;
  }
}
