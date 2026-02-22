import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/pagination_model.dart';
import '../../../../core/network/network_info.dart';
import '../../../category/data/models/category_model.dart';
import '../../../category/data/models/country_model.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/movie_remote_datasource.dart';
import '../models/movie_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final MovieRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Result<(List<MovieModel>, PaginationModel)>> getNewMovies(
      int page) async {
    if (!await networkInfo.isConnected) {
      return const Failure(
        message: 'Không có kết nối mạng. Vui lòng kiểm tra lại.',
      );
    }

    try {
      final result = await remoteDataSource.getNewMovies(page);
      return Success(result);
    } on ServerException catch (e) {
      return Failure(message: e.message, statusCode: e.statusCode);
    }
  }

  @override
  Future<Result<List<CategoryModel>>> getCategories() async {
    if (!await networkInfo.isConnected) {
      return const Failure(message: 'Không có kết nối mạng.');
    }

    try {
      final result = await remoteDataSource.getCategories();
      return Success(result);
    } on ServerException catch (e) {
      return Failure(message: e.message, statusCode: e.statusCode);
    }
  }

  @override
  Future<Result<List<CountryModel>>> getCountries() async {
    if (!await networkInfo.isConnected) {
      return const Failure(message: 'Không có kết nối mạng.');
    }

    try {
      final result = await remoteDataSource.getCountries();
      return Success(result);
    } on ServerException catch (e) {
      return Failure(message: e.message, statusCode: e.statusCode);
    }
  }
}
