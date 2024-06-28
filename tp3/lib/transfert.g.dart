// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task()
  ..userid = json['userid'] as String
  ..name = json['name'] as String
  ..percentageDone = (json['percentageDone'] as num).toInt()
  ..percentageTimeSpent = (json['percentageTimeSpent'] as num).toDouble()
  ..deadline = json['deadline'] as String
  ..creationDate = json['creationDate'] as String
  ..photoId = json['photoId'] as String;

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'userid': instance.userid,
      'name': instance.name,
      'percentageDone': instance.percentageDone,
      'percentageTimeSpent': instance.percentageTimeSpent,
      'deadline': instance.deadline,
      'creationDate': instance.creationDate,
      'photoId': instance.photoId,
    };
