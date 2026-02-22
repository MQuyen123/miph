import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  final String type;

  const CategoryPage({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thể loại')),
      body: Center(child: Text('Category: $type')),
    );
  }
}
