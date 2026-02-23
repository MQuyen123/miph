import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../features/watch/data/models/watch_position_model.dart';

/// Widget "Tiếp tục xem" hiển thị trên trang chủ
class ContinueWatchingWidget extends StatelessWidget {
  final List<WatchPosition> items;

  const ContinueWatchingWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Icon(Icons.play_circle_fill, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'Tiếp tục xem',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return _ContinueCard(item: items[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _ContinueCard extends StatelessWidget {
  final WatchPosition item;

  const _ContinueCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/watch/${item.movieSlug}/${item.episodeSlug}');
      },
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with progress
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 80,
                width: 140,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: item.posterUrl,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) =>
                          Container(color: AppColors.cardDark),
                    ),
                    // Play icon overlay
                    Container(
                      color: Colors.black26,
                      child: const Center(
                        child: Icon(
                          Icons.play_circle_outline,
                          color: Colors.white70,
                          size: 36,
                        ),
                      ),
                    ),
                    // Progress bar
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: LinearProgressIndicator(
                        value: item.progress.clamp(0.0, 1.0),
                        backgroundColor: Colors.black54,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary),
                        minHeight: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Movie name
            Text(
              item.movieName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            // Episode name
            Text(
              item.episodeName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white38, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
