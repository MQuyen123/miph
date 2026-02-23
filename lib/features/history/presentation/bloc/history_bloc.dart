import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../watch/data/models/watch_position_model.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(const HistoryInitial()) {
    on<LoadHistory>(_onLoad);
    on<RemoveHistoryItem>(_onRemove);
    on<ClearHistory>(_onClear);
  }

  Box get _box => Hive.box(AppConstants.watchHistoryBox);

  void _onLoad(LoadHistory event, Emitter<HistoryState> emit) {
    final items = WatchPosition.getAll();
    emit(HistoryLoaded(items));
  }

  void _onRemove(RemoveHistoryItem event, Emitter<HistoryState> emit) {
    final key = '${event.movieSlug}_${event.episodeSlug}';
    _box.delete(key);
    final items = WatchPosition.getAll();
    emit(HistoryLoaded(items));
  }

  void _onClear(ClearHistory event, Emitter<HistoryState> emit) {
    _box.clear();
    emit(const HistoryLoaded([]));
  }
}
