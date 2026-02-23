import 'package:equatable/equatable.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

/// Tải lịch sử xem
class LoadHistory extends HistoryEvent {
  const LoadHistory();
}

/// Xóa một mục lịch sử
class RemoveHistoryItem extends HistoryEvent {
  final String movieSlug;
  final String episodeSlug;

  const RemoveHistoryItem({
    required this.movieSlug,
    required this.episodeSlug,
  });

  @override
  List<Object?> get props => [movieSlug, episodeSlug];
}

/// Xóa toàn bộ lịch sử
class ClearHistory extends HistoryEvent {
  const ClearHistory();
}
