import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MIHP',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFE50914),
            fontSize: 24,
          ),
        ),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: const Center(child: Text('Home Page — Coming Soon')),
    );
  }
}
