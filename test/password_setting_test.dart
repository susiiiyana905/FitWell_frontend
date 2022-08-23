import 'package:fitwell_frontend/screen/setting/password_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  testWidgets("PasswordSetting", (WidgetTester tester) async {
    // Executing the actual test
    await tester.pumpWidget(MaterialApp(home: PasswordSetting()));

    // Checking outputs
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.byType(Column), findsOneWidget);
    expect(find.byType(Form), findsOneWidget);
    expect(find.byIcon(FontAwesomeIcons.solidEyeSlash), findsNWidgets(2));
  });
}
