import 'package:json_annotation/json_annotation.dart';

part 'exercise_res.g.dart';

@JsonSerializable()
class ExerciseType {
  @JsonKey(name: "_id")
  String? id;

  String? name;
  String? image;

  ExerciseType({
    this.id,
    this.name,
    this.image,
  });

  factory ExerciseType.fromJson(Map<String, dynamic> json) =>
      _$ExerciseTypeFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseTypeToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Exercise {
  @JsonKey(name: "_id")
  String? id;

  String? name;
  String? description;
  String? image;
  ExerciseType? exerciseType;

  Exercise({
    this.id,
    this.name,
    this.description,
    this.image,
    this.exerciseType,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ExerciseStep {
  @JsonKey(name: "_id")
  String? id;

  List<String>? step;
  String? image;
  Exercise? exerciseName;

  ExerciseStep({
    this.id,
    this.step,
    this.image,
    this.exerciseName,
  });

  factory ExerciseStep.fromJson(Map<String, dynamic> json) =>
      _$ExerciseStepFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseStepToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CompletedExercise {
  @JsonKey(name: "_id")
  String? id;

  Exercise? exercise;

  CompletedExercise({
    this.id,
    this.exercise,
  });

  factory CompletedExercise.fromJson(Map<String, dynamic> json) =>
      _$CompletedExerciseFromJson(json);

  Map<String, dynamic> toJson() => _$CompletedExerciseToJson(this);
}