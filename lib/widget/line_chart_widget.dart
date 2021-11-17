import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:smart_alarm/data/bar_chart_data.dart';

class LineChartWidget extends StatefulWidget {
  @override
  LineChartWidgetState createState() => LineChartWidgetState();
}


class LineChartWidgetState extends State<LineChartWidget>{
  List<GraphData> chartData = [];
  List<int> timeData = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
                          16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29];

  late ChartSeriesController _chartSeriesController;

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), updateDataSource);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> color = <Color>[];
    color.add(Color(0xff012061));
    color.add(Color(0xff7030A0));

    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(0.5);

    final LinearGradient gradientColors = LinearGradient(colors: color, stops: stops);

    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SfCartesianChart(
                plotAreaBorderWidth: 0,
                series: <LineSeries<GraphData, int>>[
                  LineSeries<GraphData, int>(
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesController = controller;
                    },
                    dataSource: chartData,
                    xValueMapper: (GraphData g, _) => g.x,
                    yValueMapper: (GraphData g, _) => g.y,
                    color: Color(0xff012061)
                  )
                ],
                primaryXAxis: NumericAxis(
                    isVisible: false,
                    majorGridLines: const MajorGridLines(width: 0),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    interval: 3,
                    minimum: 0,
                    maximum: 29,
                ),
                primaryYAxis: NumericAxis(
                    isVisible: false,
                    axisLine: const AxisLine(width: 0),
                    majorTickLines: const MajorTickLines(size: 0),
                    minimum: 50,
                    maximum: 100,
                )
            )
        )
    );
  }


  void updateDataSource(Timer timer) {
    int time = DateTime.now().second % 30;
    if(time == 0){
      chartData.clear();
      _chartSeriesController.updateDataSource(
          removedDataIndexes: timeData
      );
    }
    chartData.add(GraphData(time, (Random().nextInt(50))+50));
    _chartSeriesController.updateDataSource(
        addedDataIndex: time
    );
  }

}
