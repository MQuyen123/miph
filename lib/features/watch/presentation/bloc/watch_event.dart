import 'package:equatable/equatable.dart';

abstract class WatchEvent extends Equatable {
  const WatchEvent();

  @override
  List<Object?> get props => [];
}

/// Mở tập phim để xem
class LoadEpisode extends WatchEvent {
  final String movieSlug;
  final String episodeSlug;

  const LoadEpisode({
    required this.movieSlug,
    required this.episodeSlug,
  });

  @override
  List<Object?> get props => [movieSlug, episodeSlug];
}

/// Đổi server phát phim
class ChangeServer extends WatchEvent {
  final int serverIndex;

  const ChangeServer(this.serverIndex);

  @override
  List<Object?> get props => [serverIndex];
}

/// Chuyển sang tập tiếp theo
class NextEpisode extends WatchEvent {
  const NextEpisode();
}

/// Lưu vị trí xem hiện tại
class SaveWatchPosition extends WatchEvent {
  final int positionInSeconds;
  final int durationInSeconds;

  const SaveWatchPosition({
    required this.positionInSeconds,
    required this.durationInSeconds,
  });

  @override
  List<Object?> get props => [positionInSeconds, durationInSeconds];
}

/// Video bị lỗi — thử fallback server
class VideoError extends WatchEvent {
  const VideoError();
}
