import 'package:equatable/equatable.dart';

/// Một server chứa danh sách tập phim
/// API trả về: { "server_name": "...", "server_data": [...] }
class EpisodeServerModel extends Equatable {
  final String serverName;
  final List<EpisodeModel> episodes;

  const EpisodeServerModel({
    required this.serverName,
    required this.episodes,
  });

  factory EpisodeServerModel.fromJson(Map<String, dynamic> json) {
    return EpisodeServerModel(
      serverName: json['server_name'] as String? ?? '',
      episodes: (json['server_data'] as List<dynamic>?)
              ?.map((e) => EpisodeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [serverName, episodes];
}

/// Thông tin một tập phim
class EpisodeModel extends Equatable {
  final String name;
  final String slug;
  final String filename;
  final String linkEmbed;
  final String linkM3u8;

  const EpisodeModel({
    required this.name,
    required this.slug,
    required this.filename,
    required this.linkEmbed,
    required this.linkM3u8,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      filename: json['filename'] as String? ?? '',
      linkEmbed: json['link_embed'] as String? ?? '',
      linkM3u8: json['link_m3u8'] as String? ?? '',
    );
  }

  /// Kiểm tra tập có link phát được không
  bool get hasPlayableLink => linkM3u8.isNotEmpty;

  @override
  List<Object?> get props => [slug, linkM3u8];
}
