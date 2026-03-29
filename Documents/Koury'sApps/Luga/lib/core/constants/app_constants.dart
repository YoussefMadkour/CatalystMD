/// API keys refs, timeouts, limits.
abstract final class AppConstants {
  // Supabase — replace with env vars in production
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  // Timeouts
  static const apiTimeout = Duration(seconds: 30);
  static const otpTimeout = Duration(seconds: 60);
  static const offerExpiry = Duration(hours: 6);

  // Limits
  static const maxOfferRounds = 3;
  static const maxItemsPerShipment = 10;
  static const maxImageSizeMb = 5;
  static const maxWeightKg = 30.0;
  static const minPrice = 5.0;

  // Draft auto-save interval
  static const draftSaveInterval = Duration(seconds: 10);
}
