import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'record_data.dart';

part 'record_date_data.g.dart';

@JsonSerializable(explicitToJson: true)
class RecordDateData{
  String date;
  List<RecordData> record;

  RecordDateData({
    required this.date,
    required this.record,
  });

  // factory RecordDateData.fromJson(Map<String, dynamic> parsedJson){
  //   var recordFromJson = parsedJson['recordDate'] as List;
  //   List record = recordFromJson.map((i) => RecordData.fromJson(i)).toList();
  //
  //   return RecordDateData(
  //       date: parsedJson['date'],
  //       record : parsedJson['recode'],
  //   );
  // }
  //
  // Map<String, dynamic> toJson(){
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   var jsonrecord = jsonEncode(this.record);
  //   data['date'] = this.date;
  //   data['record'] = jsonrecord;
  //
  //   return data;
  // }

  factory RecordDateData.fromJson(Map<String, dynamic> json) => _$RecordDateDataFromJson(json);

  Map<String, dynamic> toJson() => _$RecordDateDataToJson(this);
}

