import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:smart_alarm/data/bar_chart_data.dart';
import 'package:provider/provider.dart';

class PieChartWidget extends StatefulWidget {

  final int time;

  const PieChartWidget({Key? key, required this.time}) : super(key: key);

  @override
  _PieChartWidgetState createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {

  @override
  Widget build(BuildContext context) {

    final List<PieGraphData> chartData = [
      PieGraphData('Sleep Time', widget.time, const Color.fromRGBO(235, 247, 255, 1)),
      PieGraphData('Not Sleep Time', 24 - widget.time, const Color(0xff012061))
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
}

class SleepTime extends ChangeNotifier{
  int _sleepTime = 0;

  SleepTime(this._sleepTime);

  int get sleepTime => _sleepTime;

  void setSleepTime(int time) {
    _sleepTime = time;
    notifyListeners(); // 값이 변할 때마다 플러터 프레임워크에 알려줍니다.
  }

}
