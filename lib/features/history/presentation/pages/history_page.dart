import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../watch/data/models/watch_position_model.dart';
import '../bloc/history_bloc.dart';
import '../bloc/history_event.dart';
import '../bloc/history_state.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử xem'),
        centerTitle: true,
        actions: [
          BlocBuilder<HistoryBloc, HistoryState>(
            builder: (context, state) {
              if (state is HistoryLoaded && state.items.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.delete_sweep, color: Colors.white54),
                  tooltip: 'Xóa tất cả',
                  onPressed: () => _showClearDialog(context),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is HistoryLoaded) {
            if (state.items.isEmpty) {
              return _buildEmpty();
            }
            return _buildList(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.white12),
          SizedBox(height: 16),
          Text(
            'Chưa có lịch sử xem',
            style: TextStyle(color: Colors.white38, fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Bắt đầu xem phim để lưu lịch sử',
            style: TextStyle(color: Colors.white24, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, HistoryLoaded state) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        final item = state.items[index];
        return _HistoryTile(item: item);
      },
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: const Text('Xóa tất cả lịch sử?',
            style: TextStyle(color: Colors.white)),
        content: const Text(
          'Hành động này không thể hoàn tác.',
          style: TextStyle(color: Colors.white54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              context.read<HistoryBloc>().add(const ClearHistory());
              Navigator.pop(context);
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final WatchPosition item;

  const _HistoryTile({required this.item});

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('${item.movieSlug}_${item.episodeSlug}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: Colors.red.shade700,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        context.read<HistoryBloc>().add(RemoveHistoryItem(
              movieSlug: item.movieSlug,
              episodeSlug: item.episodeSlug,
            ));
      },
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 80,
            height: 50,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: item.posterUrl,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) =>
                      Container(color: AppColors.cardDark),
                ),
                // Progress bar overlay
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    value: item.progress.clamp(0.0, 1.0),
                    backgroundColor: Colors.black54,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
        title: Text(
          item.movieName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${item.episodeName} • ${_formatDuration(item.positionInSeconds)} / ${_formatDuration(item.durationInSeconds)}',
              style: const TextStyle(color: Colors.white38, fontSize: 12),
            ),
            Text(
              _formatTime(item.lastWatched),
              style: const TextStyle(color: Colors.white24, fontSize: 11),
            ),
          ],
        ),
        trailing: item.isCompleted
            ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
            : const Icon(Icons.play_circle_fill,
                color: AppColors.primary, size: 28),
        onTap: () {
          context.push('/watch/${item.movieSlug}/${item.episodeSlug}');
        },
      ),
    );
  }
}
