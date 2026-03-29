/// KYC verification via Persona WebView flow.
class PersonaService {
  PersonaService._();

  static Future<String> startVerification({
    required String userId,
    required String templateId,
  }) async {
    // TODO: Return Persona inquiry URL for WebView
    throw UnimplementedError();
  }

  static Future<bool> checkVerificationStatus(String inquiryId) async {
    // TODO: Poll Persona API for verification status
    throw UnimplementedError();
  }
}
