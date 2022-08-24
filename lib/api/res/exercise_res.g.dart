// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExerciseType _$ExerciseTypeFromJson(Map<String, dynamic> json) => ExerciseType(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$ExerciseTypeToJson(ExerciseType instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'image': instance.image,
    };

Exercise _$ExerciseFromJson(Map<String, dynamic> json) => Exercise(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      exerciseType: json['exerciseType'] == null
          ? null
          : ExerciseType.fromJson(json['exerciseType'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ExerciseToJson(Exercise instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'exerciseType': instance.exerciseType?.toJson(),
    };

Step _$StepFromJson(Map<String, dynamic> json) => Step(
      id: json['_id'] as String?,
      step: (json['step'] as List<dynamic>?)?.map((e) => e as String).toList(),
      image: json['image'] as String?,
      exercise: json['exercise'] == null
          ? null
          : Exercise.fromJson(json['exercise'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StepToJson(Step instance) => <String, dynamic>{
      '_id': instance.id,
      'step': instance.step,
      'image': instance.image,
      'exercise': instance.exercise?.toJson(),
    };

CompletedExercise _$CompletedExerciseFromJson(Map<String, dynamic> json) =>
    CompletedExercise(
      id: json['_id'] as String?,
      step: (json['step'] as List<dynamic>?)?.map((e) => e as String).toList(),
      image: json['image'] as String?,
      exercise: json['exercise'] == null
          ? null
          : Exercise.fromJson(json['exercise'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CompletedExerciseToJson(CompletedExercise instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'step': instance.step,
      'image': instance.image,
      'exercise': instance.exercise?.toJson(),
    };
