import 'package:equatable/equatable.dart';

import '../../data/models/movie_detail_model.dart';

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object?> get props => [];
}

class MovieDetailInitial extends MovieDetailState {
  const MovieDetailInitial();
}

class MovieDetailLoading extends MovieDetailState {
  const MovieDetailLoading();
}

class MovieDetailLoaded extends MovieDetailState {
  final MovieDetailModel movie;

  const MovieDetailLoaded(this.movie);

  @override
  List<Object?> get props => [movie];
}

class MovieDetailError extends MovieDetailState {
  final String message;

  const MovieDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
