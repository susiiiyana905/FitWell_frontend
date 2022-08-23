import 'package:fitwell_frontend/screen/authentication/forget_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("ForgotPassword", (WidgetTester tester) async {
    // Finding the required widgets
    final email = find.byKey(ValueKey("email"));
    final password = find.byKey(ValueKey("password"));

    // Executing the actual test
    await tester.pumpWidget(MaterialApp(home: ForgetPassword()));
    await tester.enterText(email, "gaurisharma358@gmail.com");
    await tester.enterText(password, "Guava@003");
    await tester.pump();

    // Checking outputs
    expect(find.text("gaurisharma358@gmail.com"), findsOneWidget);
    expect(find.text("Guava@003"), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byType(Form), findsOneWidget);
  });
}
