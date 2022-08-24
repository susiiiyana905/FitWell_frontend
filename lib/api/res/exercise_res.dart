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
class Step {
  @JsonKey(name: "_id")
  String? id;

  List<String>? step;
  String? image;
  Exercise? exercise;

  Step({
    this.id,
    this.step,
    this.image,
    this.exercise,
  });

  factory Step.fromJson(Map<String, dynamic> json) =>
      _$StepFromJson(json);

  Map<String, dynamic> toJson() => _$StepToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CompletedExercise {
  @JsonKey(name: "_id")
  String? id;

  List<String>? step;
  String? image;
  Exercise? exercise;

  CompletedExercise({
    this.id,
    this.step,
    this.image,
    this.exercise,
  });

  factory CompletedExercise.fromJson(Map<String, dynamic> json) =>
      _$CompletedExerciseFromJson(json);

  Map<String, dynamic> toJson() => _$CompletedExerciseToJson(this);
}