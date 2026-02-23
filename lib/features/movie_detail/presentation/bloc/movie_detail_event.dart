import 'package:equatable/equatable.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Load chi tiết phim theo slug
class LoadMovieDetail extends MovieDetailEvent {
  final String slug;

  const LoadMovieDetail(this.slug);

  @override
  List<Object?> get props => [slug];
}
