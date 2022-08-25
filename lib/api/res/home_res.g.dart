// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeData _$HomeDataFromJson(Map<String, dynamic> json) => HomeData(
      exerciseTypes: (json['exerciseTypes'] as List<dynamic>?)
          ?.map((e) => ExerciseType.fromJson(e as Map<String, dynamic>))
          .toList(),
      exercises: (json['exercises'] as List<dynamic>?)
          ?.map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeDataToJson(HomeData instance) => <String, dynamic>{
      'exerciseTypes': instance.exerciseTypes?.map((e) => e.toJson()).toList(),
      'exercises': instance.exercises?.map((e) => e.toJson()).toList(),
    };

Workout _$WorkoutFromJson(Map<String, dynamic> json) => Workout(
      profilePicture: json['profilePicture'] as String?,
      todayProgressPoint: json['todayProgressPoint'] as int?,
      myFavorite: (json['myFavorite'] as List<dynamic>?)
          ?.map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      todayExercises: (json['todayExercises'] as List<dynamic>?)
          ?.map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      recentExercises: (json['recentExercises'] as List<dynamic>?)
          ?.map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WorkoutToJson(Workout instance) => <String, dynamic>{
      'profilePicture': instance.profilePicture,
      'todayProgressPoint': instance.todayProgressPoint,
      'myFavorite': instance.myFavorite?.map((e) => e.toJson()).toList(),
      'todayExercises':
          instance.todayExercises?.map((e) => e.toJson()).toList(),
      'recentExercises':
          instance.recentExercises?.map((e) => e.toJson()).toList(),
    };
