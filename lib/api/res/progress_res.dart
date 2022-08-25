import 'package:fit_well/api/res/user_res.dart';
import 'package:json_annotation/json_annotation.dart';

part 'progress_res.g.dart';

@JsonSerializable(explicitToJson: true)
class Progress {
  @JsonKey(name: "_id")
  String? id;

  User? user;
  int? progress;
  int? tmp;
  int? pmp;

  Progress({
    this.user,
    this.progress,
    this.tmp,
    this.pmp,
  });

  factory Progress.fromJson(Map<String, dynamic> json) =>
      _$ProgressFromJson(json);

  Map<String, dynamic> toJson() => _$ProgressToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ProgressData {
  Progress? progress;

  ProgressData({
    this.progress,
  });

  factory ProgressData.fromJson(Map<String, dynamic> json) =>
      _$ProgressDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProgressDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TopProgress {
  List<Progress>? progressPoints;
  List<Progress>? tmpPoints;
  List<Progress>? pmpPoints;

  TopProgress({
    this.progressPoints,
    this.tmpPoints,
    this.pmpPoints,
  });

  factory TopProgress.fromJson(Map<String, dynamic> json) =>
      _$TopProgressFromJson(json);

  Map<String, dynamic> toJson() => _$TopProgressToJson(this);
}
