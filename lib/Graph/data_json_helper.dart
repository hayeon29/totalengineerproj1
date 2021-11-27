import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:smart_alarm/data/record_date_data.dart';

Future<String> _loadPageAsset(String date) async{
  return await rootBundle.loadString('assets/data_${date}.json');
}

Future loadPage(String date) async{
  String jsonString = await _loadPageAsset(date);
  final jsonResponse = json.decode(jsonString);
  RecordDateData recodedatedata = new RecordDateData.fromJson(jsonResponse);
  print(recodedatedata.date);
}