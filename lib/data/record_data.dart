import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'record_data.g.dart';

@JsonSerializable()
class RecordData{
  String startTime;
  String endTime;
  List<int> oxygenSatur;
  List<int> heartRate;
  List<int> sound;

  RecordData({
    required this.startTime,
    required this.endTime,
    required this.oxygenSatur,
    required this.heartRate,
    required this.sound,
  });

  // factory RecordData.fromJson(Map<String, dynamic> parsedJson){
  //   var oxygenSaturList = parsedJson['oxygetnSatur'] as List;
  //   var heartRateList = parsedJson['heartRate'] as List;
  //   var soundList = parsedJson['sound'] as List;
  //
  //   List<int> oxygenSatur = oxygenSaturList.cast<int>();
  //   List<int> heartRate = heartRateList.cast<int>();
  //   List<int> sound = soundList.cast<int>();
  //
  //   return new RecordData(
  //       startTime: parsedJson['startTime'],
  //       endTime: parsedJson['endTime'],
  //       oxygenSatur: oxygenSatur,
  //       heartRate: heartRate,
  //       sound: sound
  //   );
  // }
  //
  // Map<String, dynamic> toJson(){
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   String jsonOxygenSatur = jsonEncode(this.oxygenSatur);
  //   String jsonheartRate = jsonEncode(this.heartRate);
  //   String jsonSound = jsonEncode(this.sound);
  //   data['startTime'] = this.startTime;
  //   data['endTime'] = this.endTime;
  //   data['oxygenSatur'] = jsonOxygenSatur;
  //   data['heartRate'] = jsonheartRate;
  //   data['sound'] = jsonSound;
  //   return data;
  // }
  factory RecordData.fromJson(Map<String, dynamic> json) => _$RecordDataFromJson(json);

  Map<String, dynamic> toJson() => _$RecordDataToJson(this);
}