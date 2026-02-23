import 'package:equatable/equatable.dart';

import '../../../home/data/models/movie_model.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteState {
  const FavoriteInitial();
}

class FavoriteLoaded extends FavoriteState {
  final List<MovieModel> movies;

  const FavoriteLoaded(this.movies);

  bool isFavorite(String slug) => movies.any((m) => m.slug == slug);

  @override
  List<Object?> get props => [movies];
}
