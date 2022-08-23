import 'package:flutter_test/flutter_test.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('Checking token and googleSignIn is saved locally or not', () async {
    final sharedPref = await SharedPreferences.getInstance();
    sharedPref.remove("token");
    sharedPref.remove("googleSignIn");

    String token = sharedPref.getString("token") ?? "";
    bool googleSignIn = sharedPref.getBool("googleSignIn") ?? false;
    expect(token, "");
    expect(googleSignIn, false);

    sharedPref.setString("token", "lskdjflksjd938759slm980wynop");
    sharedPref.setBool("googleSignIn", true);

    token = sharedPref.getString("token") ?? "";
    googleSignIn = sharedPref.getBool("googleSignIn") ?? false;
    
    expect(token, "lskdjflksjd938759slm980wynop");
    expect(googleSignIn, true);
  });
}
