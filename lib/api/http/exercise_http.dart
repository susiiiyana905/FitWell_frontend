import 'dart:convert';
import 'dart:io';

import 'package:fit_well/api/res/exercise_res.dart';
import 'package:http/http.dart';

import '../log_status.dart';
import '../urls.dart';

class ExerciseHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<List<Exercise>> getExercises(String exerciseTypeId) async {
    try {
      final response = await post(
        Uri.parse(routeUrl + ExerciseUrls.getExercise),
        body: {"exerciseTypeId": exerciseTypeId},
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );

      List resData = jsonDecode(response.body);

      return resData.map((e) => Exercise.fromJson(e)).toList();
    } catch (error) {
      return Future.error(error);
    }
  }
}
