import 'package:equatable/equatable.dart';

class PaginationModel extends Equatable {
  final int totalItems;
  final int totalItemsPerPage;
  final int currentPage;
  final int totalPages;

  const PaginationModel({
    required this.totalItems,
    required this.totalItemsPerPage,
    required this.currentPage,
    required this.totalPages,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      totalItems: json['totalItems'] as int? ?? 0,
      totalItemsPerPage: json['totalItemsPerPage'] as int? ?? 10,
      currentPage: json['currentPage'] as int? ?? 1,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }

  /// Empty pagination — dùng khi API trả về null
  factory PaginationModel.empty() {
    return const PaginationModel(
      totalItems: 0,
      totalItemsPerPage: 10,
      currentPage: 1,
      totalPages: 1,
    );
  }

  bool get hasNextPage => currentPage < totalPages;

  @override
  List<Object?> get props =>
      [totalItems, totalItemsPerPage, currentPage, totalPages];
}
