import 'package:equatable/equatable.dart';

import '../../../home/data/models/movie_model.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object?> get props => [];
}

/// Tải danh sách yêu thích
class LoadFavorites extends FavoriteEvent {
  const LoadFavorites();
}

/// Thêm/bỏ phim yêu thích (toggle)
class ToggleFavorite extends FavoriteEvent {
  final MovieModel movie;

  const ToggleFavorite(this.movie);

  @override
  List<Object?> get props => [movie];
}

/// Xóa phim khỏi yêu thích
class RemoveFavorite extends FavoriteEvent {
  final String slug;

  const RemoveFavorite(this.slug);

  @override
  List<Object?> get props => [slug];
}
