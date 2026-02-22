import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_new_movies.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetNewMovies getNewMovies;
  final GetCategories getCategories;

  HomeBloc({
    required this.getNewMovies,
    required this.getCategories,
  }) : super(const HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<LoadMoreMovies>(_onLoadMoreMovies);
    on<RefreshHome>(_onRefreshHome);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());

    // Gọi 2 API song song: phim mới + thể loại
    final results = await Future.wait([
      getNewMovies(1),
      getCategories(),
    ]);

    final moviesResult = results[0];
    final categoriesResult = results[1];

    if (moviesResult is Failure) {
      emit(HomeError((moviesResult as Failure).message));
      return;
    }

    final moviesSuccess = moviesResult as Success;
    final (movies, pagination) = moviesSuccess.data;

    // Categories có thể fail nhưng không block trang chủ
    final categories =
        categoriesResult is Success ? (categoriesResult as Success).data : [];

    emit(HomeLoaded(
      movies: movies,
      categories: List.from(categories),
      currentPage: pagination.currentPage,
      hasMore: pagination.hasNextPage,
    ));
  }

  Future<void> _onLoadMoreMovies(
    LoadMoreMovies event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is! HomeLoaded || !currentState.hasMore) return;
    if (currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.currentPage + 1;
    final result = await getNewMovies(nextPage);

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
        // Khi load more fail, giữ nguyên state cũ nhưng tắt loading
        emit(currentState.copyWith(isLoadingMore: false));
        // Có thể emit thêm snackbar event ở đây nếu cần
        addError(Exception(message));
    }
  }

  Future<void> _onRefreshHome(
    RefreshHome event,
    Emitter<HomeState> emit,
  ) async {
    // Reset về trang 1
    add(const LoadHomeData());
  }
}
