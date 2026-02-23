import '../../movie_detail/data/models/episode_model.dart';

/// Quản lý nguồn video với fallback logic
/// Thử server 1, nếu lỗi → server 2 → server 3...
class VideoSourceManager {
  final List<EpisodeServerModel> servers;

  VideoSourceManager(this.servers);

  /// Lấy URL video cho tập phim cụ thể
  /// Ưu tiên link_m3u8, fallback sang link_embed
  String? getVideoUrl(int serverIndex, String episodeSlug) {
    if (serverIndex < 0 || serverIndex >= servers.length) return null;

    final server = servers[serverIndex];
    final episode = server.episodes.firstWhere(
      (ep) => ep.slug == episodeSlug,
      orElse: () => const EpisodeModel(
        name: '',
        slug: '',
        filename: '',
        linkEmbed: '',
        linkM3u8: '',
      ),
    );

    if (episode.linkM3u8.isNotEmpty) return episode.linkM3u8;
    if (episode.linkEmbed.isNotEmpty) return episode.linkEmbed;
    return null;
  }

  /// Thử tìm URL từ server tiếp theo (fallback)
  /// Trả về (serverIndex, url) hoặc null nếu hết server
  (int, String)? findNextAvailableSource(
    int currentServerIndex,
    String episodeSlug,
  ) {
    for (var i = currentServerIndex + 1; i < servers.length; i++) {
      final url = getVideoUrl(i, episodeSlug);
      if (url != null && url.isNotEmpty) {
        return (i, url);
      }
    }
    return null;
  }

  /// Lấy danh sách tên server
  List<String> get serverNames => servers.map((s) => s.serverName).toList();

  /// Tìm episode tiếp theo trong cùng server
  EpisodeModel? getNextEpisode(int serverIndex, String currentEpisodeSlug) {
    if (serverIndex < 0 || serverIndex >= servers.length) return null;

    final episodes = servers[serverIndex].episodes;
    final currentIndex =
        episodes.indexWhere((ep) => ep.slug == currentEpisodeSlug);

    if (currentIndex < 0 || currentIndex >= episodes.length - 1) return null;
    return episodes[currentIndex + 1];
  }

  /// Tìm episode trước đó trong cùng server
  EpisodeModel? getPreviousEpisode(int serverIndex, String currentEpisodeSlug) {
    if (serverIndex < 0 || serverIndex >= servers.length) return null;

    final episodes = servers[serverIndex].episodes;
    final currentIndex =
        episodes.indexWhere((ep) => ep.slug == currentEpisodeSlug);

    if (currentIndex <= 0) return null;
    return episodes[currentIndex - 1];
  }
}
