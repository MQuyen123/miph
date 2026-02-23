import '../../../../core/error/failures.dart';
import '../../data/models/movie_detail_model.dart';
import '../repositories/movie_detail_repository.dart';

/// UseCase: Lấy chi tiết phim theo slug
class GetMovieDetail {
  final MovieDetailRepository repository;

  GetMovieDetail(this.repository);

  Future<Result<MovieDetailModel>> call(String slug) {
    return repository.getMovieDetail(slug);
  }
}
