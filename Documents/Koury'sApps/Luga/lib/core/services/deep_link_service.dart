/// Deep link handling for go_router + app links.
class DeepLinkService {
  DeepLinkService._();

  static Future<void> initialize() async {
    // TODO: Initialize deep link handling
  }

  static String generateShareLink({
    required String type,
    required String id,
  }) {
    // TODO: Generate shareable deep link
    return 'https://luga.app/$type/$id';
  }
}
