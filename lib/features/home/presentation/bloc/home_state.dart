import 'package:equatable/equatable.dart';

import '../../../category/data/models/category_model.dart';
import '../../data/models/movie_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<MovieModel> movies;
  final List<CategoryModel> categories;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;

  const HomeLoaded({
    required this.movies,
    required this.categories,
    required this.currentPage,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  HomeLoaded copyWith({
    List<MovieModel>? movies,
    List<CategoryModel>? categories,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return HomeLoaded(
      movies: movies ?? this.movies,
      categories: categories ?? this.categories,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  /// 5 phim đầu tiên để hiển thị trong carousel
  List<MovieModel> get featuredMovies =>
      movies.length >= 5 ? movies.sublist(0, 5) : movies;

  @override
  List<Object?> get props =>
      [movies, categories, currentPage, hasMore, isLoadingMore];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
