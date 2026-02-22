import 'package:flutter/material.dart';

import '../../../../core/widgets/movie_card.dart';
import '../../data/models/movie_model.dart';

/// Horizontal scrollable row phim — dùng cho "Phim Mới Cập Nhật" section
class MovieHorizontalList extends StatelessWidget {
  final String title;
  final List<MovieModel> movies;
  final VoidCallback? onSeeAll;

  const MovieHorizontalList({
    super.key,
    required this.title,
    required this.movies,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (onSeeAll != null)
                TextButton(
                  onPressed: onSeeAll,
                  child: const Text(
                    'Xem tất cả',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Horizontal scroll
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: movies.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              return MovieCard(
                movie: movies[index],
                width: 130,
                height: 200,
              );
            },
          ),
        ),
      ],
    );
  }
}
