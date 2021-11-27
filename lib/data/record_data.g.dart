// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordData _$RecordDataFromJson(Map<String, dynamic> json) => RecordData(
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      oxygenSatur:
          (json['oxygenSatur'] as List<dynamic>).map((e) => e as int).toList(),
      heartRate:
          (json['heartRate'] as List<dynamic>).map((e) => e as int).toList(),
      sound: (json['sound'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$RecordDataToJson(RecordData instance) =>
    <String, dynamic>{
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'oxygenSatur': instance.oxygenSatur,
      'heartRate': instance.heartRate,
      'sound': instance.sound,
    };
