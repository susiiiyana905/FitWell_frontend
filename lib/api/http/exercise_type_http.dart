import 'dart:convert';
import 'dart:io';

import 'package:fit_well/api/res/home_res.dart';
import 'package:http/http.dart';

import '../log_status.dart';
import '../urls.dart';

class ExerciseTypeHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<HomeData> exerciseTypes() async {
    try {
      final response = await get(
        Uri.parse(routeUrl + TypeUrls.getExerciseTypes),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );

      final resData = jsonDecode(response.body);

      return HomeData.fromJson(resData);
    } catch (error) {
      return Future.error(error);
    }
  }
}
