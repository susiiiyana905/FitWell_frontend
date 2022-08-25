import 'dart:convert';
import 'dart:io';

import 'package:fit_well/api/res/exercise_res.dart';
import 'package:http/http.dart';

import '../log_status.dart';
import '../urls.dart';

class ExerciseStepHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<List<ExerciseStep>> getExerciseSteps(String exerciseId) async {
    try {
      final response = await post(
        Uri.parse(routeUrl + StepUrls.getSteps),
        body: {"exerciseId": exerciseId},
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );

      List resData = jsonDecode(response.body);

      return resData.map((e) => ExerciseStep.fromJson(e)).toList();
    } catch (error) {
      return Future.error(error);
    }
  }
}
