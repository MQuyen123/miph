import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mihp/injection_container.dart';
import 'package:mihp/main.dart';

void main() {
  setUpAll(() async {
    // Đăng ký tất cả dependencies trước khi chạy test
    await initDependencies();
  });

  testWidgets('App should build without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const MihpApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
