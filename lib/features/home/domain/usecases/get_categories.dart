import '../../../../core/error/failures.dart';
import '../../../category/data/models/category_model.dart';
import '../repositories/home_repository.dart';

/// UseCase: Lấy danh sách thể loại phim
class GetCategories {
  final HomeRepository repository;

  GetCategories(this.repository);

  Future<Result<List<CategoryModel>>> call() {
    return repository.getCategories();
  }
}
