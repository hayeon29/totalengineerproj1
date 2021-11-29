import 'dart:async';
import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:smart_alarm/data/bar_chart_data.dart';

class HeartRateChartWidget extends StatefulWidget {
  final int count;

  const HeartRateChartWidget({Key? key, required this.count}) : super(key: key);
  @override
  HeartRateChartWidgetState createState() => HeartRateChartWidgetState();
}


class HeartRateChartWidgetState extends State<HeartRateChartWidget>{
  List<GraphData> chartData = [];
  List<int> timeData = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
    16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29];

  late ChartSeriesController _chartSeriesController;

  String _startTime = DateTime.now().second <= 30 ?
  formatDate(DateTime.now(), [hh, ':', nn, ':00',]) : formatDate(DateTime.now(), [hh, ':', nn, ':30',]);
  String _endTime = DateTime.now().second <= 30 ?
  formatDate(DateTime.now(), [hh, ':', nn, ':30',]) :
  formatDate(DateTime.now().add(const Duration(minutes: 1)), [hh, ':', nn, ':00',]);

  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), updateDataSource);
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          SfCartesianChart(
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
                    color: Colors.black,
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
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

    );
  }

  void updateDataSource(Timer timer) {
    int chartTime = DateTime.now().second % 30;
    if(chartTime == 0){
      chartData.clear();
      _chartSeriesController.updateDataSource(
          removedDataIndexes: timeData
      );
      setState((){
        _startTime = formatDate(DateTime.now(), [hh, ':', nn, ':', ss,]);
        _endTime = formatDate(DateTime.now().add(const Duration(seconds: 30)), [hh, ':', nn, ':', ss,]);
      });
    }
    chartData.add(GraphData(chartTime, widget.count));
    _chartSeriesController.updateDataSource(
        addedDataIndex: chartTime
    );
  }

}