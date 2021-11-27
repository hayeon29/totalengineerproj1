import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_alarm/widget/oxygen_satur_chart_widget.dart' as linechart;
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

  String oneMinuteBreathAvg = "0";
  String apneaCount = "0";

  @override
  initState(){
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
                        child:HeartRateChart.HeartRateChartWidget(),
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
                        child:linechart.LineChartWidget() ,
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
                        child:SoundChart.SoundChartWidget() ,
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
}




