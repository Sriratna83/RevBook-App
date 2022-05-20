// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:revbook_app/main.dart';
import 'package:revbook_app/view/screens/book_detail_screen.dart';

void main() {
  testWidgets('finds a Text widget', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Text('E'),
      ),
    ));

    // Find a widget that displays the letter 'H'.
    expect(find.text('E'), findsOneWidget);
  });
}
