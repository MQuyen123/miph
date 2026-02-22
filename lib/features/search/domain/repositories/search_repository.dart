import '../../../../core/error/failures.dart';
import '../../../../core/models/pagination_model.dart';
import '../../../home/data/models/movie_model.dart';

/// Interface trừu tượng cho Search repository
abstract class SearchRepository {
  Future<Result<(List<MovieModel>, PaginationModel)>> searchMovies(
    String keyword,
    int page,
  );

  Future<Result<(List<MovieModel>, PaginationModel)>> getMoviesByType(
    String type, {
    int page = 1,
    String? category,
    String? country,
    String? year,
  });
}
