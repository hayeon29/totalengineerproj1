// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_date_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordDateData _$RecordDateDataFromJson(Map<String, dynamic> json) =>
    RecordDateData(
      date: json['date'] as String,
      record: (json['record'] as List<dynamic>)
          .map((e) => RecordData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RecordDateDataToJson(RecordDateData instance) =>
    <String, dynamic>{
      'date': instance.date,
      'record': instance.record.map((e) => e.toJson()).toList(),
    };
