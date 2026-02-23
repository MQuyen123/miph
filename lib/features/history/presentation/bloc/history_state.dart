import 'package:equatable/equatable.dart';

import '../../../watch/data/models/watch_position_model.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

class HistoryLoaded extends HistoryState {
  final List<WatchPosition> items;

  const HistoryLoaded(this.items);

  /// Lấy các phim chưa xem xong (cho "Tiếp tục xem")
  List<WatchPosition> get continueWatching =>
      items.where((item) => !item.isCompleted).toList();

  @override
  List<Object?> get props => [items];
}
