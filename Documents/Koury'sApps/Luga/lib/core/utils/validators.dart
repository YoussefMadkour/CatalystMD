/// Validation utilities for phone, email, flight number, URL.
class Validators {
  Validators._();

  static final _phoneRegex = RegExp(r'^\+?[1-9]\d{7,14}$');
  static final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final _flightRegex = RegExp(r'^[A-Z]{2}\d{1,4}$');
  static final _urlRegex = RegExp(r'https?://[\w\-]+(\.[\w\-]+)+[/#?]?.*$');

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    if (!_phoneRegex.hasMatch(value)) return 'Enter a valid phone number';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return null; // optional
    if (!_emailRegex.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  static String? flightNumber(String? value) {
    if (value == null || value.isEmpty) return null; // optional
    if (!_flightRegex.hasMatch(value.toUpperCase())) return 'Enter a valid flight number (e.g. MS804)';
    return null;
  }

  static String? url(String? value) {
    if (value == null || value.isEmpty) return 'URL is required';
    if (!_urlRegex.hasMatch(value)) return 'Enter a valid URL';
    return null;
  }

  static String? required(String? value, [String field = 'This field']) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? minLength(String? value, int min, [String field = 'This field']) {
    if (value == null || value.length < min) return '$field must be at least $min characters';
    return null;
  }
}
