import '../../../../core/error/failures.dart';
import '../../data/models/movie_detail_model.dart';

/// Interface trừu tượng cho Movie Detail repository
abstract class MovieDetailRepository {
  Future<Result<MovieDetailModel>> getMovieDetail(String slug);
}
