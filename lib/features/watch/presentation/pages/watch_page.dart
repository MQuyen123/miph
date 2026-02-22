import 'package:flutter/material.dart';

class WatchPage extends StatelessWidget {
  final String movieSlug;
  final String episodeSlug;

  const WatchPage({
    super.key,
    required this.movieSlug,
    required this.episodeSlug,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$movieSlug - $episodeSlug')),
      body: const Center(child: Text('Watch Page — Coming Soon')),
    );
  }
}
