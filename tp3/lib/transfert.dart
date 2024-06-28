import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transfert.g.dart';

@JsonSerializable()
class Task {
  Task();

  @JsonKey(includeFromJson: false, includeToJson: false)
  String id = '';

  String userid = '';
  String name = '';
  int percentageDone = 0;
  double percentageTimeSpent = 0;
  String deadline = '';
  String creationDate = '';
  String photoId = '';

  factory Task.fromJson(Map<String, dynamic> json) =>
      _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
