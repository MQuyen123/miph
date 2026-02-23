import '../../../../core/error/failures.dart';
import '../../../../core/models/pagination_model.dart';
import '../../../home/data/models/movie_model.dart';
import '../repositories/search_repository.dart';

/// UseCase: Lấy phim theo loại (phim-bo, phim-le, hoat-hinh, tv-shows)
class GetMoviesByType {
  final SearchRepository repository;

  GetMoviesByType(this.repository);

  Future<Result<(List<MovieModel>, PaginationModel)>> call(
    String type, {
    int page = 1,
    String? category,
    String? country,
    String? year,
  }) {
    return repository.getMoviesByType(
      type,
      page: page,
      category: category,
      country: country,
      year: year,
    );
  }
}
