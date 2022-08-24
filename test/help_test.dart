import 'package:fit_well/screen/help.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("Help", (WidgetTester tester) async {
    // Executing the actual test
    await tester.pumpWidget(MaterialApp(home: Help()));

    // Checking outputs
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.text("Help"), findsOneWidget);
    expect(find.text("Data Insertion"), findsOneWidget);
    expect(find.text("Data Visualization"), findsOneWidget);
    expect(find.text("Progress Point and Achievement"), findsOneWidget);
    expect(find.text("Data Privacy"), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward_ios), findsNWidgets(4));
  });
}
