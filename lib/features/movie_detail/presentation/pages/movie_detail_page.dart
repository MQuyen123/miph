import 'package:flutter/material.dart';

class MovieDetailPage extends StatelessWidget {
  final String slug;

  const MovieDetailPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(slug)),
      body: Center(child: Text('Movie Detail: $slug')),
    );
  }
}
