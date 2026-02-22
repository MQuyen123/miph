import 'package:equatable/equatable.dart';

class MovieModel extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String originName;
  final String posterUrl;
  final String thumbUrl;
  final int year;
  final String? type;
  final String? status;
  final String? episodeCurrent;
  final String? quality;
  final String? lang;
  final String? time;
  final bool? subDocquyen;
  final bool? chieurap;
  final TmdbInfo? tmdb;
  final List<CategoryRef>? categories;
  final List<CountryRef>? countries;
  final DateTime? modifiedTime;

  const MovieModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.originName,
    required this.posterUrl,
    required this.thumbUrl,
    required this.year,
    this.type,
    this.status,
    this.episodeCurrent,
    this.quality,
    this.lang,
    this.time,
    this.subDocquyen,
    this.chieurap,
    this.tmdb,
    this.categories,
    this.countries,
    this.modifiedTime,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    // poster_url có thể là URL đầy đủ hoặc relative path
    String posterUrl = json['poster_url'] as String? ?? '';
    if (posterUrl.isNotEmpty && !posterUrl.startsWith('http')) {
      posterUrl = 'https://phimimg.com/$posterUrl';
    }

    String thumbUrl = json['thumb_url'] as String? ?? '';
    if (thumbUrl.isNotEmpty && !thumbUrl.startsWith('http')) {
      thumbUrl = 'https://phimimg.com/$thumbUrl';
    }

    return MovieModel(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      originName: json['origin_name'] as String? ?? '',
      posterUrl: posterUrl,
      thumbUrl: thumbUrl,
      year: json['year'] as int? ?? 0,
      type: json['type'] as String?,
      status: json['status'] as String?,
      episodeCurrent: json['episode_current'] as String?,
      quality: json['quality'] as String?,
      lang: json['lang'] as String?,
      time: json['time'] as String?,
      subDocquyen: json['sub_docquyen'] as bool?,
      chieurap: json['chieurap'] as bool?,
      tmdb: json['tmdb'] != null
          ? TmdbInfo.fromJson(json['tmdb'] as Map<String, dynamic>)
          : null,
      categories: (json['category'] as List<dynamic>?)
          ?.map((e) => CategoryRef.fromJson(e as Map<String, dynamic>))
          .toList(),
      countries: (json['country'] as List<dynamic>?)
          ?.map((e) => CountryRef.fromJson(e as Map<String, dynamic>))
          .toList(),
      modifiedTime: json['modified'] != null
          ? DateTime.tryParse(
              (json['modified'] as Map<String, dynamic>)['time'] as String? ??
                  '',
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'slug': slug,
      'origin_name': originName,
      'poster_url': posterUrl,
      'thumb_url': thumbUrl,
      'year': year,
      'type': type,
      'episode_current': episodeCurrent,
      'quality': quality,
      'lang': lang,
    };
  }

  @override
  List<Object?> get props => [id, slug];
}

class TmdbInfo extends Equatable {
  final String? type;
  final String? id;
  final int? season;
  final double voteAverage;
  final int voteCount;

  const TmdbInfo({
    this.type,
    this.id,
    this.season,
    this.voteAverage = 0,
    this.voteCount = 0,
  });

  factory TmdbInfo.fromJson(Map<String, dynamic> json) {
    return TmdbInfo(
      type: json['type'] as String?,
      id: json['id']?.toString(),
      season: json['season'] as int?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
      voteCount: json['vote_count'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [type, id, season, voteAverage, voteCount];
}

class CategoryRef extends Equatable {
  final String id;
  final String name;
  final String slug;

  const CategoryRef({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory CategoryRef.fromJson(Map<String, dynamic> json) {
    return CategoryRef(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [id, slug];
}

class CountryRef extends Equatable {
  final String id;
  final String name;
  final String slug;

  const CountryRef({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory CountryRef.fromJson(Map<String, dynamic> json) {
    return CountryRef(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [id, slug];
}
