import '../../../category/data/models/category_model.dart';
import '../../../category/data/models/country_model.dart';
import '../../../movie_detail/data/models/movie_detail_model.dart';
import '../../../../core/models/pagination_model.dart';
import '../models/movie_model.dart';

/// Interface cho remote data source — tất cả API calls liên quan đến phim
abstract class MovieRemoteDataSource {
  /// Lấy danh sách phim mới cập nhật
  /// GET /danh-sach/phim-moi-cap-nhat?page={page}
  Future<(List<MovieModel>, PaginationModel)> getNewMovies(int page);

  /// Lấy chi tiết phim theo slug
  /// GET /phim/{slug}
  Future<MovieDetailModel> getMovieDetail(String slug);

  /// Tìm kiếm phim
  /// GET /v1/api/tim-kiem?keyword={keyword}&limit={limit}&page={page}
  Future<(List<MovieModel>, PaginationModel)> searchMovies(
    String keyword,
    int page, {
    int limit = 10,
  });

  /// Lấy danh sách phim theo loại (phim-bo, phim-le, hoat-hinh, tv-shows)
  /// GET /v1/api/danh-sach/{type}?page={page}&category={category}...
  Future<(List<MovieModel>, PaginationModel)> getMoviesByType(
    String type, {
    int page = 1,
    String? category,
    String? country,
    String? year,
    String? sortField,
  });

  /// Lấy danh sách thể loại
  /// GET /the-loai
  Future<List<CategoryModel>> getCategories();

  /// Lấy danh sách quốc gia
  /// GET /quoc-gia
  Future<List<CountryModel>> getCountries();
}
