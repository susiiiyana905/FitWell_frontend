// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:fitwell_frontend/api/model/user_model.dart';
import 'package:http/http.dart';

import '../../urls.dart';

class LoginHttp {
  final routeUrl = ApiUrls.routeUrl;

  Future<Map> login(String email, String password) async {
    try {
      Map<String, String> userData = {
        "email": email,
        "password": password,
      };

      final response = await post(Uri.parse(routeUrl + Authentication.login),
          body: userData);

      return {
        "statusCode": response.statusCode,
        "body": jsonDecode(response.body) as Map,
      };
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<Map> googleSignIn(UploadGoogleUser userDetails) async {
    try {
      Map<String, String> userData = {
        "email": userDetails.email!,
        "profilePicture": userDetails.profilePicture!,
        "profileName": userDetails.profileName!,
      };

      final response = await post(
        Uri.parse(routeUrl + Authentication.googleSignIn),
        body: userData,
      );

      return {
        "statusCode": response.statusCode,
        "body": jsonDecode(response.body) as Map,
      };
    } catch (error) {
      return Future.error(error);
    }
  }
}
