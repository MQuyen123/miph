import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../favorite/presentation/bloc/favorite_bloc.dart';
import '../../../favorite/presentation/bloc/favorite_event.dart';
import '../../../favorite/presentation/bloc/favorite_state.dart';
import '../../../home/data/models/movie_model.dart';
import '../../data/models/movie_detail_model.dart';
import '../bloc/movie_detail_bloc.dart';
import '../bloc/movie_detail_event.dart';
import '../bloc/movie_detail_state.dart';
import '../widgets/episode_list_widget.dart';

class MovieDetailPage extends StatelessWidget {
  final String slug;

  const MovieDetailPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieDetailBloc, MovieDetailState>(
      builder: (context, state) {
        if (state is MovieDetailLoading || state is MovieDetailInitial) {
          return _buildLoadingScaffold(context);
        }

        if (state is MovieDetailError) {
          return _buildErrorScaffold(context, state.message);
        }

        if (state is MovieDetailLoaded) {
          return _buildContent(context, state.movie);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }

  Widget _buildErrorScaffold(BuildContext context, String message) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.white24),
            const SizedBox(height: 16),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white54)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () =>
                  context.read<MovieDetailBloc>().add(LoadMovieDetail(slug)),
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, MovieDetailModel movie) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── SliverAppBar with backdrop poster ──
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.backgroundDark,
            actions: [
              BlocBuilder<FavoriteBloc, FavoriteState>(
                builder: (context, favState) {
                  final isFav = favState is FavoriteLoaded &&
                      favState.isFavorite(movie.slug);
                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.white,
                    ),
                    onPressed: () {
                      context.read<FavoriteBloc>().add(
                            ToggleFavorite(MovieModel(
                              id: movie.id,
                              name: movie.name,
                              slug: movie.slug,
                              originName: movie.originName,
                              posterUrl: movie.posterUrl,
                              thumbUrl: movie.thumbUrl,
                              year: movie.year,
                            )),
                          );
                    },
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: movie.thumbUrl.isNotEmpty
                        ? movie.thumbUrl
                        : movie.posterUrl,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) =>
                        Container(color: AppColors.cardDark),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black,
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Movie Info ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    movie.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (movie.originName.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      movie.originName,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],

                  const SizedBox(height: 12),

                  // Info badges row
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      if (movie.year > 0) _InfoChip('${movie.year}'),
                      if (movie.quality.isNotEmpty) _InfoChip(movie.quality),
                      if (movie.lang.isNotEmpty) _InfoChip(movie.lang),
                      if (movie.time.isNotEmpty) _InfoChip(movie.time),
                      if (movie.episodeCurrent.isNotEmpty)
                        _InfoChip(movie.episodeCurrent),
                      if (movie.tmdb != null && movie.tmdb!.voteAverage > 0)
                        _InfoChip(
                          '⭐ ${movie.tmdb!.voteAverage.toStringAsFixed(1)}',
                          color: AppColors.warning,
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Play button
                  if (movie.episodes.isNotEmpty &&
                      movie.episodes.first.episodes.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final firstEp =
                              movie.episodes.first.episodes.first.slug;
                          context.push('/watch/${movie.slug}/$firstEp');
                        },
                        icon: const Icon(Icons.play_arrow, size: 28),
                        label: Text(
                          movie.isSingleMovie ? 'Xem Phim' : 'Xem Tập 1',
                          style: const TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Categories & Countries
                  if (movie.categories.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: movie.categories.map((cat) {
                        return ActionChip(
                          label: Text(cat.name,
                              style: const TextStyle(fontSize: 12)),
                          visualDensity: VisualDensity.compact,
                          onPressed: () =>
                              context.push('/category/${cat.slug}'),
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 16),

                  // Description
                  if (movie.content.isNotEmpty) ...[
                    const Text(
                      'Nội dung phim',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _ExpandableText(text: _stripHtml(movie.content)),
                  ],

                  const SizedBox(height: 16),

                  // Actors
                  if (movie.actors.isNotEmpty &&
                      movie.actors.first.isNotEmpty) ...[
                    const Text(
                      'Diễn viên',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.actors.join(', '),
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Episodes section title
                  if (movie.episodes.isNotEmpty) ...[
                    const Text(
                      'Danh sách tập',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ),

          // ── Episode List ──
          if (movie.episodes.isNotEmpty)
            SliverToBoxAdapter(
              child: EpisodeListWidget(movie: movie),
            ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  /// Xóa HTML tags khỏi content
  static String _stripHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .trim();
  }
}

/// Chip nhỏ hiển thị info (year, quality, etc.)
class _InfoChip extends StatelessWidget {
  final String label;
  final Color? color;

  const _InfoChip(this.label, {this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (color ?? Colors.white).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: (color ?? Colors.white24),
          width: 0.5,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color ?? Colors.white70,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Text expandable — show 3 lines, tap to expand
class _ExpandableText extends StatefulWidget {
  final String text;

  const _ExpandableText({required this.text});

  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          maxLines: _expanded ? null : 3,
          overflow: _expanded ? null : TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        if (widget.text.length > 150)
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _expanded ? 'Thu gọn' : 'Xem thêm',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
