import 'package:equatable/equatable.dart';

import '../../../home/data/models/movie_model.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

class CategoryLoading extends CategoryState {
  const CategoryLoading();
}

class CategoryLoaded extends CategoryState {
  final List<MovieModel> movies;
  final String type;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;

  const CategoryLoaded({
    required this.movies,
    required this.type,
    required this.currentPage,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  CategoryLoaded copyWith({
    List<MovieModel>? movies,
    String? type,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return CategoryLoaded(
      movies: movies ?? this.movies,
      type: type ?? this.type,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props =>
      [movies, type, currentPage, hasMore, isLoadingMore];
}

class CategoryError extends CategoryState {
  final String message;

  const CategoryError(this.message);

  @override
  List<Object?> get props => [message];
}
