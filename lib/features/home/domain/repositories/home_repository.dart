import '../../../../core/error/failures.dart';
import '../../../../core/models/pagination_model.dart';
import '../../../category/data/models/category_model.dart';
import '../../../category/data/models/country_model.dart';
import '../../data/models/movie_model.dart';

/// Interface trừu tượng cho Home repository
abstract class HomeRepository {
  Future<Result<(List<MovieModel>, PaginationModel)>> getNewMovies(int page);
  Future<Result<List<CategoryModel>>> getCategories();
  Future<Result<List<CountryModel>>> getCountries();
}
