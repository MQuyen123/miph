/// All API endpoint constants for phimapi.com.
class ApiConstants {
  ApiConstants._();

  /// Base URL
  static const String baseUrl = 'https://phimapi.com';

  /// Phim mới cập nhật — GET /danh-sach/phim-moi-cap-nhat?page={page}
  static const String newMovies = '/danh-sach/phim-moi-cap-nhat';

  /// Chi tiết phim — GET /phim/{slug}
  static const String movieDetail = '/phim';

  /// Tìm kiếm — GET /v1/api/tim-kiem?keyword={keyword}&page={page}
  static const String search = '/v1/api/tim-kiem';

  /// Danh sách phim theo loại — GET /v1/api/danh-sach/{type_list}?page={page}&...
  static const String movieList = '/v1/api/danh-sach';

  /// Thể loại — GET /the-loai
  static const String categories = '/the-loai';

  /// Quốc gia — GET /quoc-gia
  static const String countries = '/quoc-gia';

  /// Image WebP proxy — GET /image.php?url={url}
  static const String imageProxy = '/image.php?url=';

  /// Default items per page
  static const int defaultPageSize = 10;

  /// Build full image WebP URL from original URL.
  static String getWebPImageUrl(String originalUrl) {
    return '$baseUrl$imageProxy$originalUrl';
  }
}
