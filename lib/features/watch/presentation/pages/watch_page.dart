import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/theme/app_colors.dart';
import '../bloc/watch_bloc.dart';
import '../bloc/watch_event.dart';
import '../bloc/watch_state.dart';
import '../widgets/server_selector.dart';
import '../widgets/video_controls_overlay.dart';

class WatchPage extends StatefulWidget {
  final String movieSlug;
  final String episodeSlug;

  const WatchPage({
    super.key,
    required this.movieSlug,
    required this.episodeSlug,
  });

  @override
  State<WatchPage> createState() => _WatchPageState();
}

class _WatchPageState extends State<WatchPage> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  Timer? _saveTimer;
  bool _isLocked = false;
  String? _currentVideoUrl;

  @override
  void dispose() {
    _saveTimer?.cancel();
    _disposeControllers();
    // Restore portrait orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  void _disposeControllers() {
    _chewieController?.dispose();
    _videoController?.dispose();
    _chewieController = null;
    _videoController = null;
  }

  Future<void> _initializePlayer(String url, {int resumeSeconds = 0}) async {
    if (_currentVideoUrl == url) return;
    _currentVideoUrl = url;

    _saveTimer?.cancel();
    _disposeControllers();

    try {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(url));

      await _videoController!.initialize();

      if (resumeSeconds > 0) {
        await _videoController!.seekTo(Duration(seconds: resumeSeconds));
      }

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        placeholder: Container(color: Colors.black),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.white54, size: 42),
                const SizedBox(height: 12),
                Text(
                  'Không phát được video',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<WatchBloc>().add(const VideoError());
                  },
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Thử server khác'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                ),
              ],
            ),
          );
        },
      );

      // Auto-save position mỗi 10 giây
      _saveTimer = Timer.periodic(const Duration(seconds: 10), (_) {
        _saveCurrentPosition();
      });

      // Listener cho auto next episode
      _videoController!.addListener(_onVideoPositionChanged);

      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) {
        context.read<WatchBloc>().add(const VideoError());
      }
    }
  }

  void _onVideoPositionChanged() {
    if (_videoController == null) return;
    final position = _videoController!.value.position;
    final duration = _videoController!.value.duration;

    // Auto next episode khi xem hết
    if (duration.inSeconds > 0 &&
        position.inSeconds >= duration.inSeconds - 2 &&
        !_videoController!.value.isPlaying) {
      _videoController!.removeListener(_onVideoPositionChanged);
      context.read<WatchBloc>().add(const NextEpisode());
    }
  }

  void _saveCurrentPosition() {
    if (_videoController == null || !_videoController!.value.isInitialized) {
      return;
    }
    final position = _videoController!.value.position.inSeconds;
    final duration = _videoController!.value.duration.inSeconds;
    if (duration > 0) {
      context.read<WatchBloc>().add(SaveWatchPosition(
            positionInSeconds: position,
            durationInSeconds: duration,
          ));
    }
  }

  void _seekRelative(int seconds) {
    if (_videoController == null) return;
    final current = _videoController!.value.position;
    final target = current + Duration(seconds: seconds);
    _videoController!.seekTo(target);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<WatchBloc, WatchState>(
        listener: (context, state) {
          if (state is WatchReady) {
            _initializePlayer(
              state.videoUrl,
              resumeSeconds: state.resumePositionSeconds,
            );
          }
        },
        builder: (context, state) {
          if (state is WatchLoading || state is WatchInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is WatchError) {
            return _buildError(state.message);
          }

          if (state is WatchReady) {
            return _buildContent(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.white24),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Quay lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WatchReady state) {
    return SafeArea(
      child: Column(
        children: [
          // Video Player
          _buildVideoPlayer(state),

          // Scrollable content below video
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Movie title + episode
                  _buildMovieInfo(state),

                  // Server selector
                  ServerSelector(
                    serverNames: state.sourceManager.serverNames,
                    currentServerIndex: state.currentServerIndex,
                    onServerChanged: (index) {
                      context.read<WatchBloc>().add(ChangeServer(index));
                    },
                  ),

                  // Episode list
                  _buildEpisodeList(context, state),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer(WatchReady state) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            color: Colors.black,
            child: _chewieController != null &&
                    _videoController != null &&
                    _videoController!.value.isInitialized
                ? Chewie(controller: _chewieController!)
                : const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2,
                    ),
                  ),
          ),
        ),

        // Custom overlay (double-tap zones + lock)
        Positioned.fill(
          child: VideoControlsOverlay(
            isLocked: _isLocked,
            onDoubleTapLeft: () => _seekRelative(-10),
            onDoubleTapRight: () => _seekRelative(10),
            onToggleLock: () => setState(() => _isLocked = !_isLocked),
          ),
        ),

        // Back button + lock button
        if (!_isLocked)
          Positioned(
            top: 4,
            left: 4,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                _saveCurrentPosition();
                context.pop();
              },
            ),
          ),

        if (!_isLocked)
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              icon: Icon(
                _isLocked ? Icons.lock : Icons.lock_open,
                color: Colors.white,
              ),
              onPressed: () => setState(() => _isLocked = !_isLocked),
            ),
          ),
      ],
    );
  }

  Widget _buildMovieInfo(WatchReady state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.movie.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Đang xem: ${state.currentEpisodeName}',
            style: const TextStyle(color: AppColors.primary, fontSize: 13),
          ),
          if (state.hasNextEpisode) ...[
            const SizedBox(height: 8),
            InkWell(
              onTap: () => context.read<WatchBloc>().add(const NextEpisode()),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary, width: 0.5),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.skip_next, color: AppColors.primary, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Tập tiếp theo',
                      style: TextStyle(color: AppColors.primary, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEpisodeList(BuildContext context, WatchReady state) {
    if (state.currentServerIndex >= state.movie.episodes.length) {
      return const SizedBox.shrink();
    }

    final server = state.movie.episodes[state.currentServerIndex];
    final episodes = server.episodes;

    if (episodes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(
            'Danh sách tập',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: episodes.map((ep) {
              final isCurrent = ep.slug == state.currentEpisodeSlug;
              return InkWell(
                onTap: isCurrent
                    ? null
                    : () {
                        context.read<WatchBloc>().add(LoadEpisode(
                              movieSlug: state.movie.slug,
                              episodeSlug: ep.slug,
                            ));
                      },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  constraints: const BoxConstraints(minWidth: 48),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isCurrent ? AppColors.primary : AppColors.cardDark,
                    borderRadius: BorderRadius.circular(8),
                    border: isCurrent
                        ? null
                        : Border.all(color: Colors.white12, width: 0.5),
                  ),
                  child: Text(
                    ep.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isCurrent ? Colors.white : Colors.white70,
                      fontSize: 12,
                      fontWeight:
                          isCurrent ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
