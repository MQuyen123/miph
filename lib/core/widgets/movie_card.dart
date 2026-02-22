import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/data/models/movie_model.dart';
import '../theme/app_colors.dart';

/// Card hiển thị poster phim — dùng chung cho home grid, horizontal list, search
class MovieCard extends StatelessWidget {
  final MovieModel movie;
  final double? width;
  final double? height;
  final bool showQuality;
  final bool showEpisode;

  const MovieCard({
    super.key,
    required this.movie,
    this.width,
    this.height,
    this.showQuality = true,
    this.showEpisode = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/movie/${movie.slug}'),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.cardDark,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Poster image
            CachedNetworkImage(
              imageUrl: movie.posterUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(color: AppColors.shimmerBase),
              errorWidget: (_, __, ___) => Container(
                color: AppColors.cardDark,
                child: const Icon(Icons.movie, color: Colors.white38, size: 32),
              ),
            ),

            // Gradient overlay ở dưới
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 80,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.posterGradient,
                ),
              ),
            ),

            // Movie name
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Text(
                movie.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ),

            // Quality badge (top-left)
            if (showQuality && movie.quality != null)
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    movie.quality!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            // Episode badge (top-right)
            if (showEpisode && movie.episodeCurrent != null)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    movie.episodeCurrent!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
