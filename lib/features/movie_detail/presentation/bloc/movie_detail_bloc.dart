import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_movie_detail.dart';
import 'movie_detail_event.dart';
import 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;

  MovieDetailBloc({required this.getMovieDetail})
      : super(const MovieDetailInitial()) {
    on<LoadMovieDetail>(_onLoadMovieDetail);
  }

  Future<void> _onLoadMovieDetail(
    LoadMovieDetail event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(const MovieDetailLoading());

    final result = await getMovieDetail(event.slug);

    switch (result) {
      case Success(:final data):
        emit(MovieDetailLoaded(data));
      case Failure(:final message):
        emit(MovieDetailError(message));
    }
  }
}
