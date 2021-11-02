import 'dart:async';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:smart_alarm/data/bar_chart_data.dart';

void main(){
  runApp(StartApp());
}

class StartApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BarChartWidget(),
    );
  }
}

class BarChartWidget extends StatefulWidget{
  @override
  BarChartWidgetState createState() => BarChartWidgetState();
}

class BarChartWidgetState extends State<BarChartWidget>{

  late ChartSeriesController _chartSeriesController;
  int xCount = (DateTime.now().minute % 5) * 2 + (DateTime.now().second / 30 < 0 ? 0 : 1);
  List<GraphwithColorData> chartData = [];

  void initState(){
    Timer.periodic(const Duration(seconds: 1), updateDataSource);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SfCartesianChart(
                plotAreaBorderWidth: 0,
                series: <ColumnSeries<GraphwithColorData,int>>[
                  ColumnSeries<GraphwithColorData, int>(
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesController = controller;
                    },
                    width: 0.4,
                    dataSource: chartData,
                    xValueMapper: (GraphwithColorData g, _) => g.x,
                    yValueMapper: (GraphwithColorData g, _) => g.y,
                    pointColorMapper: (GraphwithColorData g, _) => g.color,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  )
                ],
                primaryXAxis: NumericAxis(
                  isVisible: false,
                  //majorGridLines: const MajorGridLines(width: 0),
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  minimum: 0,
                  maximum: 9,
                ),
                primaryYAxis: NumericAxis(
                  isVisible: false,
                  plotBands: <PlotBand>[
                    PlotBand(
                        start: 15,
                        end: 15,
                        borderColor: Colors.red,
                        borderWidth: 2
                    )
                  ],
                  axisLine: const AxisLine(width: 0),
                  //majorTickLines: const MajorTickLines(size: 0),
                  minimum: 0,
                  maximum: 30,
                )
            )
        )
    );
  }


  void updateDataSource(Timer timer) {
    xCount = (DateTime.now().minute % 5) * 2 + (DateTime.now().second / 30 < 1 ? 0 : 1);
    if(xCount == 0){
      chartData.clear();
      _chartSeriesController.updateDataSource(
          removedDataIndexes: <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
      );
    }

    if(DateTime.now().second % 30 == 0){
      int RandInt = Random().nextInt(10) + 10;

      if(RandInt < 15){
        chartData.add(GraphwithColorData(xCount, RandInt, Colors.yellow));
      }
      else{
        chartData.add(GraphwithColorData(xCount, RandInt, Color(0xff012061)));
      }
      _chartSeriesController.updateDataSource(
          addedDataIndex: xCount
      );
    }
  }
}
