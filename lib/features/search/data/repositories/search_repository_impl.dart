import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/pagination_model.dart';
import '../../../../core/network/network_info.dart';
import '../../../home/data/datasources/movie_remote_datasource.dart';
import '../../../home/data/models/movie_model.dart';
import '../../domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final MovieRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SearchRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Result<(List<MovieModel>, PaginationModel)>> searchMovies(
    String keyword,
    int page,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Failure(
        message: 'Không có kết nối mạng. Vui lòng kiểm tra lại.',
      );
    }

    try {
      final result = await remoteDataSource.searchMovies(keyword, page);
      return Success(result);
    } on ServerException catch (e) {
      return Failure(message: e.message, statusCode: e.statusCode);
    }
  }

  @override
  Future<Result<(List<MovieModel>, PaginationModel)>> getMoviesByType(
    String type, {
    int page = 1,
    String? category,
    String? country,
    String? year,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Failure(message: 'Không có kết nối mạng.');
    }

    try {
      final result = await remoteDataSource.getMoviesByType(
        type,
        page: page,
        category: category,
        country: country,
        year: year,
      );
      return Success(result);
    } on ServerException catch (e) {
      return Failure(message: e.message, statusCode: e.statusCode);
    } catch (e) {
      return Failure(
        message: 'Không thể tải danh sách phim. Vui lòng thử lại sau.',
      );
    }
  }
}
