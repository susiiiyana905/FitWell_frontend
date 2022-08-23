import 'package:fitwell_frontend/screen/authentication/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("Sign Up form", (WidgetTester tester) async {
    // Finding the required widgets
    final emailTxt = find.byKey(ValueKey("email"));
    final profileNameTxt = find.byKey(ValueKey("profileName"));
    final pwTxt = find.byKey(ValueKey("password"));
    final confirmPwTxt = find.byKey(ValueKey("confirmPassword"));

    // Executing the actual test
    await tester.pumpWidget(MaterialApp(home: SignUp()));
    await tester.enterText(emailTxt, "nishan@gmail.com");
    await tester.enterText(profileNameTxt, "nrb");
    await tester.enterText(pwTxt, "12345678");
    await tester.enterText(confirmPwTxt, "12345678");
    await tester.pump();

    // Checking outputs
    expect(find.text("nishan@gmail.com"), findsOneWidget);
    expect(find.text("nrb"), findsOneWidget);
    expect(find.text("12345678"), findsNWidgets(2));
    expect(find.byType(TextFormField), findsNWidgets(4));
  });
}
