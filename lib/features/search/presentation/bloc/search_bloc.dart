import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/search_movies.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMovies searchMovies;

  Timer? _debounceTimer;

  SearchBloc({required this.searchMovies}) : super(const SearchInitial()) {
    on<SearchQueryChanged>(_onQueryChanged);
    on<SearchLoadMore>(_onLoadMore);
    on<SearchCleared>(_onCleared);
  }

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();

    // Cancel previous debounce
    _debounceTimer?.cancel();

    if (query.isEmpty) {
      emit(const SearchInitial());
      return;
    }

    emit(const SearchLoading());

    // Debounce 500ms
    final completer = Completer<void>();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      completer.complete();
    });

    try {
      await completer.future;
    } catch (_) {
      return;
    }

    // Thực hiện tìm kiếm
    final result = await searchMovies(query, 1);

    switch (result) {
      case Success(:final data):
        final (movies, pagination) = data;
        if (movies.isEmpty) {
          emit(SearchEmpty(query));
        } else {
          emit(SearchLoaded(
            movies: movies,
            query: query,
            currentPage: pagination.currentPage,
            hasMore: pagination.hasNextPage,
          ));
        }
      case Failure(:final message):
        emit(SearchError(message));
    }
  }

  Future<void> _onLoadMore(
    SearchLoadMore event,
    Emitter<SearchState> emit,
  ) async {
    final currentState = state;
    if (currentState is! SearchLoaded || !currentState.hasMore) return;
    if (currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.currentPage + 1;
    final result = await searchMovies(currentState.query, nextPage);

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

  void _onCleared(SearchCleared event, Emitter<SearchState> emit) {
    _debounceTimer?.cancel();
    emit(const SearchInitial());
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
