import 'package:equatable/equatable.dart';

import '../../../movie_detail/data/models/movie_detail_model.dart';
import '../../data/video_source_manager.dart';

abstract class WatchState extends Equatable {
  const WatchState();

  @override
  List<Object?> get props => [];
}

class WatchInitial extends WatchState {
  const WatchInitial();
}

class WatchLoading extends WatchState {
  const WatchLoading();
}

class WatchReady extends WatchState {
  final MovieDetailModel movie;
  final String videoUrl;
  final String currentEpisodeSlug;
  final String currentEpisodeName;
  final int currentServerIndex;
  final VideoSourceManager sourceManager;
  final int resumePositionSeconds;

  const WatchReady({
    required this.movie,
    required this.videoUrl,
    required this.currentEpisodeSlug,
    required this.currentEpisodeName,
    required this.currentServerIndex,
    required this.sourceManager,
    this.resumePositionSeconds = 0,
  });

  /// Có tập tiếp theo không
  bool get hasNextEpisode =>
      sourceManager.getNextEpisode(currentServerIndex, currentEpisodeSlug) !=
      null;

  /// Có tập trước không
  bool get hasPreviousEpisode =>
      sourceManager.getPreviousEpisode(
          currentServerIndex, currentEpisodeSlug) !=
      null;

  WatchReady copyWith({
    MovieDetailModel? movie,
    String? videoUrl,
    String? currentEpisodeSlug,
    String? currentEpisodeName,
    int? currentServerIndex,
    VideoSourceManager? sourceManager,
    int? resumePositionSeconds,
  }) {
    return WatchReady(
      movie: movie ?? this.movie,
      videoUrl: videoUrl ?? this.videoUrl,
      currentEpisodeSlug: currentEpisodeSlug ?? this.currentEpisodeSlug,
      currentEpisodeName: currentEpisodeName ?? this.currentEpisodeName,
      currentServerIndex: currentServerIndex ?? this.currentServerIndex,
      sourceManager: sourceManager ?? this.sourceManager,
      resumePositionSeconds:
          resumePositionSeconds ?? this.resumePositionSeconds,
    );
  }

  @override
  List<Object?> get props => [
        movie.slug,
        videoUrl,
        currentEpisodeSlug,
        currentServerIndex,
        resumePositionSeconds,
      ];
}

class WatchError extends WatchState {
  final String message;

  const WatchError(this.message);

  @override
  List<Object?> get props => [message];
}
