import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

/// User thay đổi từ khóa tìm kiếm (sẽ được debounce)
class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

/// Load thêm kết quả (pagination)
class SearchLoadMore extends SearchEvent {
  const SearchLoadMore();
}

/// Xóa kết quả tìm kiếm
class SearchCleared extends SearchEvent {
  const SearchCleared();
}
