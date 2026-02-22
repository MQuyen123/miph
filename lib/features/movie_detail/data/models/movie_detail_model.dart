import 'package:equatable/equatable.dart';

import 'episode_model.dart';
import '../../../home/data/models/movie_model.dart';

class MovieDetailModel extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String originName;
  final String content;
  final String type;
  final String status;
  final String posterUrl;
  final String thumbUrl;
  final bool isCopyright;
  final bool subDocquyen;
  final bool chieurap;
  final String trailerUrl;
  final String time;
  final String episodeCurrent;
  final String episodeTotal;
  final String quality;
  final String lang;
  final String notify;
  final String showtimes;
  final int year;
  final int view;
  final List<String> actors;
  final List<String> directors;
  final List<CategoryRef> categories;
  final List<CountryRef> countries;
  final List<EpisodeServerModel> episodes;
  final TmdbInfo? tmdb;
  final DateTime? createdTime;
  final DateTime? modifiedTime;

  const MovieDetailModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.originName,
    required this.content,
    required this.type,
    required this.status,
    required this.posterUrl,
    required this.thumbUrl,
    required this.isCopyright,
    required this.subDocquyen,
    required this.chieurap,
    required this.trailerUrl,
    required this.time,
    required this.episodeCurrent,
    required this.episodeTotal,
    required this.quality,
    required this.lang,
    required this.notify,
    required this.showtimes,
    required this.year,
    required this.view,
    required this.actors,
    required this.directors,
    required this.categories,
    required this.countries,
    required this.episodes,
    this.tmdb,
    this.createdTime,
    this.modifiedTime,
  });

  factory MovieDetailModel.fromJson(
    Map<String, dynamic> movieJson,
    List<dynamic> episodesJson,
  ) {
    return MovieDetailModel(
      id: movieJson['_id'] as String? ?? '',
      name: movieJson['name'] as String? ?? '',
      slug: movieJson['slug'] as String? ?? '',
      originName: movieJson['origin_name'] as String? ?? '',
      content: movieJson['content'] as String? ?? '',
      type: movieJson['type'] as String? ?? '',
      status: movieJson['status'] as String? ?? '',
      posterUrl: movieJson['poster_url'] as String? ?? '',
      thumbUrl: movieJson['thumb_url'] as String? ?? '',
      isCopyright: movieJson['is_copyright'] as bool? ?? false,
      subDocquyen: movieJson['sub_docquyen'] as bool? ?? false,
      chieurap: movieJson['chieurap'] as bool? ?? false,
      trailerUrl: movieJson['trailer_url'] as String? ?? '',
      time: movieJson['time'] as String? ?? '',
      episodeCurrent: movieJson['episode_current'] as String? ?? '',
      episodeTotal: movieJson['episode_total'] as String? ?? '',
      quality: movieJson['quality'] as String? ?? '',
      lang: movieJson['lang'] as String? ?? '',
      notify: movieJson['notify'] as String? ?? '',
      showtimes: movieJson['showtimes'] as String? ?? '',
      year: movieJson['year'] as int? ?? 0,
      view: movieJson['view'] as int? ?? 0,
      actors: (movieJson['actor'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      directors: (movieJson['director'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      categories: (movieJson['category'] as List<dynamic>?)
              ?.map((e) => CategoryRef.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      countries: (movieJson['country'] as List<dynamic>?)
              ?.map((e) => CountryRef.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      episodes: episodesJson
          .map((e) => EpisodeServerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      tmdb: movieJson['tmdb'] != null
          ? TmdbInfo.fromJson(movieJson['tmdb'] as Map<String, dynamic>)
          : null,
      createdTime: movieJson['created'] != null
          ? DateTime.tryParse(
              (movieJson['created'] as Map<String, dynamic>)['time']
                      as String? ??
                  '',
            )
          : null,
      modifiedTime: movieJson['modified'] != null
          ? DateTime.tryParse(
              (movieJson['modified'] as Map<String, dynamic>)['time']
                      as String? ??
                  '',
            )
          : null,
    );
  }

  /// Kiểm tra phim lẻ (single) hay phim bộ (series/hoathinh/tvshows)
  bool get isSingleMovie => type == 'single';

  @override
  List<Object?> get props => [id, slug];
}
