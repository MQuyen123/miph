import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../home/data/datasources/movie_remote_datasource.dart';
import '../../domain/repositories/movie_detail_repository.dart';
import '../models/movie_detail_model.dart';

class MovieDetailRepositoryImpl implements MovieDetailRepository {
  final MovieRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  MovieDetailRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Result<MovieDetailModel>> getMovieDetail(String slug) async {
    if (!await networkInfo.isConnected) {
      return const Failure(
        message: 'Không có kết nối mạng. Vui lòng kiểm tra lại.',
      );
    }

    try {
      final result = await remoteDataSource.getMovieDetail(slug);
      return Success(result);
    } on ServerException catch (e) {
      return Failure(message: e.message, statusCode: e.statusCode);
    }
  }
}
