import 'dart:io';

/// Image compression, crop, resize before upload.
class ImageUtils {
  ImageUtils._();

  static const int maxWidthPx = 1024;
  static const int maxHeightPx = 1024;
  static const int qualityPercent = 80;

  static Future<File> compress(File file) async {
    // TODO: Use image package to compress
    return file;
  }

  static Future<File> resize(File file, {int? maxWidth, int? maxHeight}) async {
    // TODO: Use image package to resize
    return file;
  }
}
