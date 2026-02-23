import 'package:hive/hive.dart';

/// Model lưu vị trí xem phim — persist vào Hive
class WatchPosition {
  final String movieSlug;
  final String episodeSlug;
  final String episodeName;
  final String movieName;
  final String posterUrl;
  final int positionInSeconds;
  final int durationInSeconds;
  final DateTime lastWatched;

  WatchPosition({
    required this.movieSlug,
    required this.episodeSlug,
    required this.episodeName,
    required this.movieName,
    required this.posterUrl,
    required this.positionInSeconds,
    required this.durationInSeconds,
    required this.lastWatched,
  });

  /// Phần trăm đã xem
  double get progress =>
      durationInSeconds > 0 ? positionInSeconds / durationInSeconds : 0;

  /// Đã xem xong chưa (>= 90%)
  bool get isCompleted => progress >= 0.9;

  Map<String, dynamic> toJson() => {
        'movieSlug': movieSlug,
        'episodeSlug': episodeSlug,
        'episodeName': episodeName,
        'movieName': movieName,
        'posterUrl': posterUrl,
        'positionInSeconds': positionInSeconds,
        'durationInSeconds': durationInSeconds,
        'lastWatched': lastWatched.toIso8601String(),
      };

  factory WatchPosition.fromJson(Map<dynamic, dynamic> json) {
    return WatchPosition(
      movieSlug: json['movieSlug'] as String? ?? '',
      episodeSlug: json['episodeSlug'] as String? ?? '',
      episodeName: json['episodeName'] as String? ?? '',
      movieName: json['movieName'] as String? ?? '',
      posterUrl: json['posterUrl'] as String? ?? '',
      positionInSeconds: json['positionInSeconds'] as int? ?? 0,
      durationInSeconds: json['durationInSeconds'] as int? ?? 0,
      lastWatched: json['lastWatched'] != null
          ? DateTime.parse(json['lastWatched'] as String)
          : DateTime.now(),
    );
  }

  /// Lưu vào Hive box
  static Future<void> save(WatchPosition position) async {
    final box = Hive.box('watch_history');
    final key = '${position.movieSlug}_${position.episodeSlug}';
    await box.put(key, position.toJson());
  }

  /// Lấy vị trí xem cuối cùng
  static WatchPosition? get(String movieSlug, String episodeSlug) {
    final box = Hive.box('watch_history');
    final key = '${movieSlug}_$episodeSlug';
    final data = box.get(key);
    if (data == null) return null;
    return WatchPosition.fromJson(data as Map<dynamic, dynamic>);
  }

  /// Lấy tất cả lịch sử xem, sắp xếp theo thời gian mới nhất
  static List<WatchPosition> getAll() {
    final box = Hive.box('watch_history');
    final positions = <WatchPosition>[];
    for (final key in box.keys) {
      final data = box.get(key);
      if (data != null) {
        positions.add(WatchPosition.fromJson(data as Map<dynamic, dynamic>));
      }
    }
    positions.sort((a, b) => b.lastWatched.compareTo(a.lastWatched));
    return positions;
  }
}
