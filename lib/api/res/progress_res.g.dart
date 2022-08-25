// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Progress _$ProgressFromJson(Map<String, dynamic> json) => Progress(
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      progress: json['progress'] as int?,
      tmp: json['tmp'] as int?,
      pmp: json['pmp'] as int?,
    )..id = json['_id'] as String?;

Map<String, dynamic> _$ProgressToJson(Progress instance) => <String, dynamic>{
      '_id': instance.id,
      'user': instance.user?.toJson(),
      'progress': instance.progress,
      'tmp': instance.tmp,
      'pmp': instance.pmp,
    };

ProgressData _$ProgressDataFromJson(Map<String, dynamic> json) => ProgressData(
      progress: json['progress'] == null
          ? null
          : Progress.fromJson(json['progress'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProgressDataToJson(ProgressData instance) =>
    <String, dynamic>{
      'progress': instance.progress?.toJson(),
    };

TopProgress _$TopProgressFromJson(Map<String, dynamic> json) => TopProgress(
      progressPoints: (json['progressPoints'] as List<dynamic>?)
          ?.map((e) => Progress.fromJson(e as Map<String, dynamic>))
          .toList(),
      tmpPoints: (json['tmpPoints'] as List<dynamic>?)
          ?.map((e) => Progress.fromJson(e as Map<String, dynamic>))
          .toList(),
      pmpPoints: (json['pmpPoints'] as List<dynamic>?)
          ?.map((e) => Progress.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TopProgressToJson(TopProgress instance) =>
    <String, dynamic>{
      'progressPoints':
          instance.progressPoints?.map((e) => e.toJson()).toList(),
      'tmpPoints': instance.tmpPoints?.map((e) => e.toJson()).toList(),
      'pmpPoints': instance.pmpPoints?.map((e) => e.toJson()).toList(),
    };
