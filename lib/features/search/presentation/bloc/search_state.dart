import 'package:equatable/equatable.dart';

import '../../../home/data/models/movie_model.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

/// Chưa tìm kiếm gì
class SearchInitial extends SearchState {
  const SearchInitial();
}

/// Đang tìm kiếm lần đầu
class SearchLoading extends SearchState {
  const SearchLoading();
}

/// Có kết quả
class SearchLoaded extends SearchState {
  final List<MovieModel> movies;
  final String query;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;

  const SearchLoaded({
    required this.movies,
    required this.query,
    required this.currentPage,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  SearchLoaded copyWith({
    List<MovieModel>? movies,
    String? query,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return SearchLoaded(
      movies: movies ?? this.movies,
      query: query ?? this.query,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props =>
      [movies, query, currentPage, hasMore, isLoadingMore];
}

/// Không tìm thấy kết quả
class SearchEmpty extends SearchState {
  final String query;

  const SearchEmpty(this.query);

  @override
  List<Object?> get props => [query];
}

/// Lỗi tìm kiếm
class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}
