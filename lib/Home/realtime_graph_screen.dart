import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RealtimeGraph extends StatefulWidget {
  const RealtimeGraph({Key? key}) : super(key: key);

  @override
  _RealtimeGraphState createState() => _RealtimeGraphState();
}

class _RealtimeGraphState extends State<RealtimeGraph> {
  int bpm = 10;
  int apnea = 1;

  List<Color> gradientColors = [
    const Color(0xff7030a0),
    const Color(0xff072063),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color.fromARGB(255, 3, 30, 97),
      //TODO: 테마색 입힐것
      appBar: AppBar(
        title: const Text('실시간 그래프')
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container( // 실시간 센서값
              padding: EdgeInsets.all(20), //TODO: 이거 안먹히는 이유??
              height: 500,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color.fromARGB(255, 3, 30, 97))
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: LineChart(sampleData()),
              )

            ),
        
            Container( // 실시간 센서값
              padding: EdgeInsets.all(20),
              height: 500,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color.fromARGB(255, 3, 30, 97))
              ),

            ),

            ListTile( // 기타 데이터
              title: Text('평균 1분당 호흡 횟수'),
              trailing: Text('$bpm회/m')
            ),

            ListTile( // 기타 데이터
              title: Text('무호흡 감지 횟수'),
              trailing: Text('$apnea회'),
            ),

          ],
        ),
      ),
    );
  }
  LineChartData sampleData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 0.5,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 0.5,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          // 그래프의 x축 라벨
          // TODO: 실시간으로 표현되도록 만들어야함, DB에서 넘겨받을때 측정 시작시간과 종료시간 기록필요
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return '2:00';
              case 5:
                return '5:00';
              case 8:
                return '8:00';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10';
              case 3:
                return '30';
              case 5:
                return '50';
            }
            return '';
          },
          reservedSize: 24,
        ),
      ),
      // 표 그리는 위젯
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: false,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData( //그래프 아래영역 색칠
            show: true,
            colors:
            gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}
