import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../movie_detail/domain/usecases/get_movie_detail.dart';
import '../../data/models/watch_position_model.dart';
import '../../data/video_source_manager.dart';
import 'watch_event.dart';
import 'watch_state.dart';

class WatchBloc extends Bloc<WatchEvent, WatchState> {
  final GetMovieDetail getMovieDetail;

  WatchBloc({required this.getMovieDetail}) : super(const WatchInitial()) {
    on<LoadEpisode>(_onLoadEpisode);
    on<ChangeServer>(_onChangeServer);
    on<NextEpisode>(_onNextEpisode);
    on<SaveWatchPosition>(_onSavePosition);
    on<VideoError>(_onVideoError);
  }

  Future<void> _onLoadEpisode(
    LoadEpisode event,
    Emitter<WatchState> emit,
  ) async {
    emit(const WatchLoading());

    final result = await getMovieDetail(event.movieSlug);

    switch (result) {
      case Success(:final data):
        final sourceManager = VideoSourceManager(data.episodes);

        // Thử tìm video URL từ server đầu tiên
        String? videoUrl;
        int serverIndex = 0;

        for (var i = 0; i < data.episodes.length; i++) {
          final url = sourceManager.getVideoUrl(i, event.episodeSlug);
          if (url != null && url.isNotEmpty) {
            videoUrl = url;
            serverIndex = i;
            break;
          }
        }

        if (videoUrl == null) {
          emit(const WatchError(
            'Không tìm thấy nguồn phát cho tập này. Vui lòng thử tập khác.',
          ));
          return;
        }

        // Tìm tên tập hiện tại
        String episodeName = event.episodeSlug;
        for (final server in data.episodes) {
          for (final ep in server.episodes) {
            if (ep.slug == event.episodeSlug) {
              episodeName = ep.name;
              break;
            }
          }
        }

        // Kiểm tra resume position
        final savedPosition = WatchPosition.get(
          event.movieSlug,
          event.episodeSlug,
        );
        final resumeSeconds =
            (savedPosition != null && !savedPosition.isCompleted)
                ? savedPosition.positionInSeconds
                : 0;

        emit(WatchReady(
          movie: data,
          videoUrl: videoUrl,
          currentEpisodeSlug: event.episodeSlug,
          currentEpisodeName: episodeName,
          currentServerIndex: serverIndex,
          sourceManager: sourceManager,
          resumePositionSeconds: resumeSeconds,
        ));

      case Failure(:final message):
        emit(WatchError(message));
    }
  }

  void _onChangeServer(
    ChangeServer event,
    Emitter<WatchState> emit,
  ) {
    final currentState = state;
    if (currentState is! WatchReady) return;

    final url = currentState.sourceManager.getVideoUrl(
      event.serverIndex,
      currentState.currentEpisodeSlug,
    );

    if (url == null || url.isEmpty) {
      emit(const WatchError('Server này không có link phát.'));
      return;
    }

    emit(currentState.copyWith(
      videoUrl: url,
      currentServerIndex: event.serverIndex,
      resumePositionSeconds: 0,
    ));
  }

  void _onNextEpisode(
    NextEpisode event,
    Emitter<WatchState> emit,
  ) {
    final currentState = state;
    if (currentState is! WatchReady) return;

    final nextEp = currentState.sourceManager.getNextEpisode(
      currentState.currentServerIndex,
      currentState.currentEpisodeSlug,
    );

    if (nextEp == null) return;

    // Load tập mới
    add(LoadEpisode(
      movieSlug: currentState.movie.slug,
      episodeSlug: nextEp.slug,
    ));
  }

  Future<void> _onSavePosition(
    SaveWatchPosition event,
    Emitter<WatchState> emit,
  ) async {
    final currentState = state;
    if (currentState is! WatchReady) return;

    await WatchPosition.save(WatchPosition(
      movieSlug: currentState.movie.slug,
      episodeSlug: currentState.currentEpisodeSlug,
      episodeName: currentState.currentEpisodeName,
      movieName: currentState.movie.name,
      posterUrl: currentState.movie.posterUrl,
      positionInSeconds: event.positionInSeconds,
      durationInSeconds: event.durationInSeconds,
      lastWatched: DateTime.now(),
    ));
  }

  void _onVideoError(
    VideoError event,
    Emitter<WatchState> emit,
  ) {
    final currentState = state;
    if (currentState is! WatchReady) return;

    // Thử fallback sang server tiếp theo
    final fallback = currentState.sourceManager.findNextAvailableSource(
      currentState.currentServerIndex,
      currentState.currentEpisodeSlug,
    );

    if (fallback != null) {
      final (serverIndex, url) = fallback;
      emit(currentState.copyWith(
        videoUrl: url,
        currentServerIndex: serverIndex,
        resumePositionSeconds: 0,
      ));
    } else {
      emit(const WatchError(
        'Tất cả server đều không phát được. Vui lòng thử lại sau.',
      ));
    }
  }
}
