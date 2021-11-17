import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:smart_alarm/data/bar_chart_data.dart';
import 'dart:ui' as ui;

void main(){
  runApp(PieChart());
}

class PieChart extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PieChartWidget(),
    );
  }
}

class PieChartWidget extends StatefulWidget {
  const PieChartWidget({Key? key}) : super(key: key);

  @override
  _PieChartWidgetState createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {

  @override
  Widget build(BuildContext context) {
    int sleepTimeTotal = _getSleepTime();

    final List<PieGraphData> chartData = [
      PieGraphData('Sleep Time', sleepTimeTotal, const Color.fromRGBO(235, 247, 255, 1)),
      PieGraphData('Not Sleep Time', 24 - sleepTimeTotal, const Color(0xff012061))
    ];
    return Scaffold(
        body: Center(
            child: Container(
                child: SfCircularChart(
                    series: <CircularSeries>[
                      PieSeries<PieGraphData, String>(
                          dataSource: chartData,
                          pointColorMapper:(PieGraphData data,  _) => data.color,
                          xValueMapper: (PieGraphData data, _) => data.x,
                          yValueMapper: (PieGraphData data, _) => data.y,
                          // Radius of pie
                          radius: '100%'
                      )
                    ]
                )
            )
        )
    );
  }

  int _getSleepTime(){
    return Random().nextInt(23) + 1;
  }
}
