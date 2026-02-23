import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../search/domain/usecases/get_movies_by_type.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetMoviesByType getMoviesByType;

  String _currentType = '';
  String? _currentCategory;
  String? _currentCountry;
  String? _currentYear;

  CategoryBloc({required this.getMoviesByType})
      : super(const CategoryInitial()) {
    on<LoadCategoryMovies>(_onLoadCategoryMovies);
    on<LoadMoreCategoryMovies>(_onLoadMore);
  }

  Future<void> _onLoadCategoryMovies(
    LoadCategoryMovies event,
    Emitter<CategoryState> emit,
  ) async {
    _currentType = event.type;
    _currentCategory = event.category;
    _currentCountry = event.country;
    _currentYear = event.year;

    emit(const CategoryLoading());

    final result = await getMoviesByType(
      event.type,
      page: 1,
      category: event.category,
      country: event.country,
      year: event.year,
    );

    switch (result) {
      case Success(:final data):
        final (movies, pagination) = data;
        emit(CategoryLoaded(
          movies: movies,
          type: event.type,
          currentPage: pagination.currentPage,
          hasMore: pagination.hasNextPage,
        ));
      case Failure(:final message):
        emit(CategoryError(message));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreCategoryMovies event,
    Emitter<CategoryState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CategoryLoaded || !currentState.hasMore) return;
    if (currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.currentPage + 1;
    final result = await getMoviesByType(
      _currentType,
      page: nextPage,
      category: _currentCategory,
      country: _currentCountry,
      year: _currentYear,
    );

    switch (result) {
      case Success(:final data):
        final (newMovies, pagination) = data;
        emit(currentState.copyWith(
          movies: [...currentState.movies, ...newMovies],
          currentPage: pagination.currentPage,
          hasMore: pagination.hasNextPage,
          isLoadingMore: false,
        ));
      case Failure(:final message):
        emit(currentState.copyWith(isLoadingMore: false));
        addError(Exception(message));
    }
  }
}
