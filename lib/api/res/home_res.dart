import 'package:fit_well/api/res/exercise_res.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_res.g.dart';

@JsonSerializable(explicitToJson: true)
class HomeData {
  List<ExerciseType>? exerciseTypes;
  List<Exercise>? exercises;

  HomeData({
    this.exerciseTypes,
    this.exercises,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) =>
      _$HomeDataFromJson(json);

  Map<String, dynamic> toJson() => _$HomeDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Workout {
  String? profilePicture;
  int? todayProgressPoint;
  List<Exercise>? myFavorite;
  List<Exercise>? todayExercises;
  List<Exercise>? recentExercises;

  Workout({
    this.profilePicture,
    this.todayProgressPoint,
    this.myFavorite,
    this.todayExercises,
    this.recentExercises,
  });

  factory Workout.fromJson(Map<String, dynamic> json) =>
      _$WorkoutFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutToJson(this);
}
