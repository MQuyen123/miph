import '../constants/api_constants.dart';

/// Helper to convert image URLs to optimized WebP format via phimapi proxy.
class ImageUrlHelper {
  ImageUrlHelper._();

  /// Convert original image URL to WebP proxy URL.
  /// If the URL is already a WebP proxy URL, return as-is.
  static String toWebP(String? originalUrl) {
    if (originalUrl == null || originalUrl.isEmpty) {
      return '';
    }
    if (originalUrl.contains('image.php?url=')) {
      return originalUrl;
    }
    return ApiConstants.getWebPImageUrl(originalUrl);
  }

  /// Get poster URL (uses WebP proxy).
  static String getPosterUrl(String? url) => toWebP(url);

  /// Get thumbnail URL (uses WebP proxy).
  static String getThumbUrl(String? url) => toWebP(url);
}
