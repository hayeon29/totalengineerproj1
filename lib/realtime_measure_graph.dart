import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_alarm/widget/line_chart_widget.dart' as linechart;
import 'package:date_format/date_format.dart';
import 'package:smart_alarm/widget/bar_chart_widget.dart' as barchart;
import 'package:intl/intl.dart';

void main(){
  runApp(graphMeasure());
}

class graphMeasure extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: graphMeasureStart(),
    );
  }
}


class graphMeasureStart extends StatefulWidget {
  const graphMeasureStart({Key? key}) : super(key: key);

  @override
  _graphMeasureStartState createState() => _graphMeasureStartState();
}

class _graphMeasureStartState extends State<graphMeasureStart> {

  late Timer _timer;
  String _startTime = DateTime.now().second <= 30 ?
    formatDate(DateTime.now(), [hh, ':', nn, ':00',]) : formatDate(DateTime.now(), [hh, ':', nn, ':30',]);
  String _endTime = DateTime.now().second <= 30 ?
    formatDate(DateTime.now(), [hh, ':', nn, ':30',]) :
    formatDate(DateTime.now().add(const Duration(minutes: 1)), [hh, ':', nn, ':00',]);

  static double timeCount = 0;
  static double totalTimeCount = 0;
  String oneMinuteBreathAvg = "0";
  String apneaCount = "0";

  @override
  initState(){

    super.initState();
    _getTime();
  }

  @override
  Widget build(BuildContext context) {
    String _startMinute = formatDate(DateTime.now(), [hh, ':', getStartMinuteString(), ':00']);
    String _endMinute = formatDate(DateTime.now(), [hh, ':', getEndMinuteString(), ':00']);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: BackButton(
            color: Colors.white
        ),
        title: Text("실시간 측정 그래프"),
        backgroundColor: const Color(0xff012061),
        elevation: 0.0,
      ),
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xff012061),
                    const Color(0xff7030A0),
                  ],
                )
            ),
            child: Column(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 3/2,
                  child:Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    color: const Color(0xffffffff),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child:linechart.LineChartWidget() ,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        '$_startTime',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        '$_endTime',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                  child: Container(color: Colors.transparent),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      '실시간 호흡 수 그래프',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                AspectRatio(
                  aspectRatio: 3/2,
                  child:Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    color: const Color(0xffffffff),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child:barchart.BarChartWidget(),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        '$_startMinute',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        '$_endMinute',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 70,
                  child: Container(color: Colors.transparent),
                ),
                Row(
                  mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        '평균 1분당 호흡 횟수',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        '$oneMinuteBreathAvg' + '회/m',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                  child: Container(color: Colors.transparent),
                ),
                Row(
                  mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        '무호흡 감지 횟수',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        '$apneaCount' + '회',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ),
        ],
      ),
    );
  }

  void _getTime() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if(DateTime.now().second % 30 == 0){
          setState((){
            _startTime = formatDate(DateTime.now(), [hh, ':', nn, ':', ss,]);
            _endTime = formatDate(DateTime.now().add(const Duration(seconds: 30)), [hh, ':', nn, ':', ss,]);
          });
         totalTimeCount = 0;
         timeCount = 0;
        }
    });
  }

  String getStartMinuteString() {
    var f = NumberFormat('00');
    return f.format((5 * (DateTime.now().minute ~/ 5))).toString();
  }

  String getEndMinuteString() {
   var f = NumberFormat('00');
   return f.format((5 * (DateTime.now().add(const Duration(minutes: 5)).minute ~/ 5))).toString();
  }
}


