import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Load dữ liệu trang chủ (phim mới + thể loại)
class LoadHomeData extends HomeEvent {
  const LoadHomeData();
}

/// Load thêm phim (pagination)
class LoadMoreMovies extends HomeEvent {
  const LoadMoreMovies();
}

/// Pull-to-refresh
class RefreshHome extends HomeEvent {
  const RefreshHome();
}
