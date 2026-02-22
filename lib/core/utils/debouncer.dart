import 'dart:async';

/// Timer-based debouncer for search input.
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 500)});

  /// Run the action after the delay, cancelling any previous pending call.
  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Cancel any pending action.
  void cancel() {
    _timer?.cancel();
  }

  /// Dispose the timer.
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
