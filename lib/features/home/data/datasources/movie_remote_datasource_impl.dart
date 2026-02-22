import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/models/pagination_model.dart';
import '../../../../core/network/dio_client.dart';
import '../../../category/data/models/category_model.dart';
import '../../../category/data/models/country_model.dart';
import '../../../movie_detail/data/models/movie_detail_model.dart';
import '../models/movie_model.dart';
import 'movie_remote_datasource.dart';

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final DioClient _dioClient;

  MovieRemoteDataSourceImpl(this._dioClient);

  @override
  Future<(List<MovieModel>, PaginationModel)> getNewMovies(int page) async {
    try {
      final response = await _dioClient.get(
        '${ApiConstants.newMovies}?page=$page',
      );
      final data = response.data as Map<String, dynamic>;

      if (data['status'] != true) {
        throw ServerException(
          message: data['msg'] as String? ?? 'Lỗi không xác định',
        );
      }

      final items = (data['items'] as List<dynamic>)
          .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
          .toList();

      final pagination = PaginationModel.fromJson(
        data['pagination'] as Map<String, dynamic>,
      );

      return (items, pagination);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Không thể tải danh sách phim: $e');
    }
  }

  @override
  Future<MovieDetailModel> getMovieDetail(String slug) async {
    try {
      final response = await _dioClient.get(
        '${ApiConstants.movieDetail}/$slug',
      );
      final data = response.data as Map<String, dynamic>;

      if (data['status'] != true) {
        throw ServerException(
          message: data['msg'] as String? ?? 'Không tìm thấy phim',
        );
      }

      return MovieDetailModel.fromJson(
        data['movie'] as Map<String, dynamic>,
        data['episodes'] as List<dynamic>,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Không thể tải chi tiết phim: $e');
    }
  }

  @override
  Future<(List<MovieModel>, PaginationModel)> searchMovies(
    String keyword,
    int page, {
    int limit = 10,
  }) async {
    try {
      final response = await _dioClient.get(
        '${ApiConstants.search}?keyword=$keyword&limit=$limit&page=$page',
      );
      final data = response.data as Map<String, dynamic>;

      if (data['status'] != 'success') {
        throw ServerException(
          message: data['msg'] as String? ?? 'Lỗi tìm kiếm',
        );
      }

      final responseData = data['data'] as Map<String, dynamic>;

      final items = (responseData['items'] as List<dynamic>)
          .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
          .toList();

      final params = responseData['params'] as Map<String, dynamic>;
      final pagination = PaginationModel.fromJson(
        params['pagination'] as Map<String, dynamic>,
      );

      return (items, pagination);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Không thể tìm kiếm phim: $e');
    }
  }

  @override
  Future<(List<MovieModel>, PaginationModel)> getMoviesByType(
    String type, {
    int page = 1,
    String? category,
    String? country,
    String? year,
    String? sortField,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': '$page',
      };
      if (category != null) queryParams['category'] = category;
      if (country != null) queryParams['country'] = country;
      if (year != null) queryParams['year'] = year;
      if (sortField != null) queryParams['sort_field'] = sortField;

      final queryString =
          queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');

      final response = await _dioClient.get(
        '${ApiConstants.movieList}/$type?$queryString',
      );
      final data = response.data as Map<String, dynamic>;

      if (data['status'] != 'success') {
        throw ServerException(
          message: data['msg'] as String? ?? 'Lỗi tải danh sách phim',
        );
      }

      final responseData = data['data'] as Map<String, dynamic>;

      final items = (responseData['items'] as List<dynamic>)
          .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
          .toList();

      final params = responseData['params'] as Map<String, dynamic>;
      final pagination = PaginationModel.fromJson(
        params['pagination'] as Map<String, dynamic>,
      );

      return (items, pagination);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Không thể tải danh sách phim: $e');
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dioClient.get(ApiConstants.categories);
      final data = response.data as List<dynamic>;

      return data
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: 'Không thể tải danh sách thể loại: $e');
    }
  }

  @override
  Future<List<CountryModel>> getCountries() async {
    try {
      final response = await _dioClient.get(ApiConstants.countries);
      final data = response.data as List<dynamic>;

      return data
          .map((e) => CountryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: 'Không thể tải danh sách quốc gia: $e');
    }
  }
}
