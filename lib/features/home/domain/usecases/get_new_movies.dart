import '../../../../core/error/failures.dart';
import '../../../../core/models/pagination_model.dart';
import '../../data/models/movie_model.dart';
import '../repositories/home_repository.dart';

/// UseCase: Lấy danh sách phim mới cập nhật (có phân trang)
class GetNewMovies {
  final HomeRepository repository;

  GetNewMovies(this.repository);

  Future<Result<(List<MovieModel>, PaginationModel)>> call(int page) {
    return repository.getNewMovies(page);
  }
}
