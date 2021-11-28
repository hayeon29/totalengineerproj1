import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_alarm/widget/oxygen_satur_chart_widget.dart' as oxygenChart;
import 'package:smart_alarm/widget/heart_rate_chart_widget.dart' as HeartRateChart;
import 'package:smart_alarm/widget/sound_chart_widget.dart' as SoundChart;

void main(){
  runApp(graphMeasure());
}

class graphMeasure extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RealtimeGraph(),
    );
  }
}

class RealtimeGraph extends StatefulWidget {
  const RealtimeGraph({Key? key}) : super(key: key);

  @override
  _RealtimeGraphState createState() => _RealtimeGraphState();
}

class _RealtimeGraphState extends State<RealtimeGraph> {

  StreamController<int> streamController = StreamController<int>();
  StreamController<int> streamController1 = StreamController<int>();
  StreamController<int> streamController2 = StreamController<int>();

  String oneMinuteBreathAvg = "0";
  String apneaCount = "0";

  @override
  initState(){
    Timer.periodic(const Duration(seconds: 1), updateDataSource);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  //1. 산소포화도
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      '실시간 산소포화도 그래프',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 0.85,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                      ),
                      color: const Color(0xffffffff),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: StreamBuilder<int>(
                            stream: streamController.stream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return oxygenChart.LineChartWidget(count: snapshot.data!);
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: Container(color: Colors.transparent),
                  ),
                  // 2. 심박수
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      '실시간 심박수 그래프',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 0.85,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                      ),
                      color: const Color(0xffffffff),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: StreamBuilder<int>(
                            stream: streamController1.stream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return HeartRateChart.HeartRateChartWidget(count: snapshot.data!);
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: Container(color: Colors.transparent),
                  ),
                  //3. 소리
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      '실시간 소리 그래프',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 0.85,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                      ),
                      color: const Color(0xffffffff),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: StreamBuilder<int>(
                          stream: streamController2.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return SoundChart.SoundChartWidget(count: snapshot.data!);
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
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

  void updateDataSource(Timer timer) {
    int chartTime = DateTime.now().second % 30;
    streamController.add(Random().nextInt(50) + 50);
    streamController1.add(Random().nextInt(50) + 50);
    streamController2.add(Random().nextInt(50) + 50);
    //if(isApnea = true 라면){
    //  record_data 리스트에 센서에서 받아온 값을 넣음
    //  List.add(value1, value2, value3);
    //  if(무호흡에서 벗어났다고 생각하면){
    //    isApnea = false 로 변환
    //    record_date_data.record_data.add(List);
    //  }
    //}
    //else{ //isApnea = false 라면
    //  측정한 세 값을 어떻게 계산해서 변수에 넣음
    //  if(값이 무호흡이라고 추측된다면){
    //    isApnea(bool) = true 로 변환
    //  }
    //}
  }
}



