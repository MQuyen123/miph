import 'package:equatable/equatable.dart';

/// Model quốc gia — parse từ /quoc-gia API
class CountryModel extends Equatable {
  final String id;
  final String name;
  final String slug;

  const CountryModel({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [id, slug];
}
