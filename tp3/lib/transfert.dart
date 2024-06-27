import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transfert.g.dart';

@JsonSerializable()
class Task {
  Task();

  String userid = '';
  String name = '';
  int percentageDone = 0;
  double percentageTimeSpent = 0;
  String deadline = '';
  int photoId = 0;

  factory Task.fromJson(Map<String, dynamic> json) =>
      _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
