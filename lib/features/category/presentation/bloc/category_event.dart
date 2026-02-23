import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

/// Load phim theo type
class LoadCategoryMovies extends CategoryEvent {
  final String type;
  final String? category;
  final String? country;
  final String? year;

  const LoadCategoryMovies({
    required this.type,
    this.category,
    this.country,
    this.year,
  });

  @override
  List<Object?> get props => [type, category, country, year];
}

/// Load thêm phim (pagination)
class LoadMoreCategoryMovies extends CategoryEvent {
  const LoadMoreCategoryMovies();
}
