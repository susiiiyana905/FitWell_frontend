import 'dart:convert';
import 'dart:io';

import 'package:fit_well/api/res/home_res.dart';
import 'package:http/http.dart';

import '../log_status.dart';
import '../urls.dart';

class CompletedHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<Map> completeExercise(String exerciseId) async {
    try {
      final response = await post(
        Uri.parse(routeUrl + CompletedUrls.completeExercise),
        body: {"exerciseId": exerciseId},
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );

      return {
        "statusCode": response.statusCode,
        "body": jsonDecode(response.body)
      };
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<Workout> myExercises() async {
    try {
      final response = await get(
        Uri.parse(routeUrl + CompletedUrls.myExercises),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );

      final resData = jsonDecode(response.body);

      return Workout.fromJson(resData);
    } catch (error) {
      return Future.error(error);
    }
  }
}
