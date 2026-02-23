import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../home/data/models/movie_model.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(const FavoriteInitial()) {
    on<LoadFavorites>(_onLoad);
    on<ToggleFavorite>(_onToggle);
    on<RemoveFavorite>(_onRemove);
  }

  Box get _box => Hive.box(AppConstants.favoritesBox);

  List<MovieModel> _getAllFavorites() {
    final movies = <MovieModel>[];
    for (final key in _box.keys) {
      final data = _box.get(key);
      if (data != null) {
        movies.add(MovieModel.fromJson(Map<String, dynamic>.from(data as Map)));
      }
    }
    return movies.reversed.toList(); // mới nhất trước
  }

  void _onLoad(LoadFavorites event, Emitter<FavoriteState> emit) {
    emit(FavoriteLoaded(_getAllFavorites()));
  }

  void _onToggle(ToggleFavorite event, Emitter<FavoriteState> emit) {
    final slug = event.movie.slug;
    if (_box.containsKey(slug)) {
      _box.delete(slug);
    } else {
      _box.put(slug, event.movie.toJson());
    }
    emit(FavoriteLoaded(_getAllFavorites()));
  }

  void _onRemove(RemoveFavorite event, Emitter<FavoriteState> emit) {
    _box.delete(event.slug);
    emit(FavoriteLoaded(_getAllFavorites()));
  }
}
