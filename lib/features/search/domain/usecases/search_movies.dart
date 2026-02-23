import '../../../../core/error/failures.dart';
import '../../../../core/models/pagination_model.dart';
import '../../../home/data/models/movie_model.dart';
import '../repositories/search_repository.dart';

/// UseCase: Tìm kiếm phim theo từ khóa
class SearchMovies {
  final SearchRepository repository;

  SearchMovies(this.repository);

  Future<Result<(List<MovieModel>, PaginationModel)>> call(
    String keyword,
    int page,
  ) {
    return repository.searchMovies(keyword, page);
  }
}
