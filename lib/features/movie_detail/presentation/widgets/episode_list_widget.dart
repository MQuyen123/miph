import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/movie_detail_model.dart';
import '../../data/models/episode_model.dart';

/// Widget hiển thị danh sách tập phim, grouped by server
class EpisodeListWidget extends StatefulWidget {
  final MovieDetailModel movie;
  final String? currentEpisodeSlug;

  const EpisodeListWidget({
    super.key,
    required this.movie,
    this.currentEpisodeSlug,
  });

  @override
  State<EpisodeListWidget> createState() => _EpisodeListWidgetState();
}

class _EpisodeListWidgetState extends State<EpisodeListWidget> {
  int _selectedServerIndex = 0;

  @override
  Widget build(BuildContext context) {
    final episodes = widget.movie.episodes;
    if (episodes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Server tabs (nếu có nhiều server)
        if (episodes.length > 1)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(episodes.length, (index) {
                  final isSelected = index == _selectedServerIndex;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(episodes[index].serverName),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      onSelected: (_) =>
                          setState(() => _selectedServerIndex = index),
                    ),
                  );
                }),
              ),
            ),
          ),

        const SizedBox(height: 12),

        // Episode grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildEpisodeGrid(episodes[_selectedServerIndex]),
        ),
      ],
    );
  }

  Widget _buildEpisodeGrid(EpisodeServerModel server) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: server.episodes.map((ep) {
        final isCurrentEp = ep.slug == widget.currentEpisodeSlug;

        return InkWell(
          onTap: () {
            context.push('/watch/${widget.movie.slug}/${ep.slug}');
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            constraints: const BoxConstraints(minWidth: 52),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isCurrentEp ? AppColors.primary : AppColors.cardDark,
              borderRadius: BorderRadius.circular(8),
              border: isCurrentEp
                  ? null
                  : Border.all(color: Colors.white12, width: 0.5),
            ),
            child: Text(
              ep.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isCurrentEp ? Colors.white : Colors.white70,
                fontSize: 13,
                fontWeight: isCurrentEp ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
