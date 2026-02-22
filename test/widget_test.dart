import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mihp/main.dart';

void main() {
  testWidgets('App should build without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const MihpApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
