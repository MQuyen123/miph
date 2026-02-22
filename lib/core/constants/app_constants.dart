/// App-wide constants.
class AppConstants {
  AppConstants._();

  /// App name
  static const String appName = 'MIHP';

  /// Search debounce duration
  static const Duration searchDebounceDuration = Duration(milliseconds: 500);

  /// Auto-save video position interval
  static const Duration videoPositionSaveInterval = Duration(seconds: 10);

  /// Carousel auto-play interval
  static const Duration carouselAutoPlayInterval = Duration(seconds: 5);

  /// Number of featured movies in carousel
  static const int carouselItemCount = 5;

  /// Hive box names
  static const String favoritesBox = 'favorites';
  static const String watchHistoryBox = 'watch_history';
  static const String searchHistoryBox = 'search_history';

  /// Max search history items to keep
  static const int maxSearchHistoryItems = 20;
}
