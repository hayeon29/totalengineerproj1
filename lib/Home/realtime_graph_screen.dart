import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:smart_alarm/widget/line_chart_widget.dart' as linechart;
import 'package:date_format/date_format.dart';
import 'package:smart_alarm/widget/bar_chart_widget.dart' as barchart;
import 'package:intl/intl.dart';

class RealtimeGraph extends StatefulWidget {

  const RealtimeGraph({Key? key, required this.device}) : super(key: key);
  final BluetoothDevice device;

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


  late Timer _timer;
  String _startTime = DateTime
      .now()
      .second <= 30 ?
  formatDate(DateTime.now(), [hh, ':', nn, ':00',]) : formatDate(
      DateTime.now(), [hh, ':', nn, ':30',]);
  String _endTime = DateTime
      .now()
      .second <= 30 ?
  formatDate(DateTime.now(), [hh, ':', nn, ':30',]) :
  formatDate(
      DateTime.now().add(const Duration(minutes: 1)), [hh, ':', nn, ':00',]);

  static double timeCount = 0;
  static double totalTimeCount = 0;
  String oneMinuteBreathAvg = "0";
  String apneaCount = "0";


  @override
  Widget build(BuildContext context) {
    String _startMinute = formatDate(
        DateTime.now(), [hh, ':', getStartMinuteString(), ':00']);
    String _endMinute = formatDate(
        DateTime.now().add(const Duration(minutes: 5)),
        [hh, ':', getEndMinuteString(), ':00']);
    return Scaffold(

      appBar: AppBar(
        leading: BackButton(
            color: Colors.white
        ),
        title: Text("실시간 측정 그래프"),
        backgroundColor: const Color(0xff012061),
        elevation: 0.0,
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: widget.device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback? onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () => widget.device.disconnect();
                  text = 'DISCONNECT';
                break;
              case BluetoothDeviceState.disconnected:
                onPressed = () => widget.device.connect();
                text = 'CONNECT';
                break;
              default:
                onPressed = null;
                text = snapshot.data.toString().substring(21).toUpperCase();
                break;
              }
            return FlatButton(
              onPressed: onPressed,
              child: Text(
                text,
                style: Theme
                    .of(context)
                    .primaryTextTheme
                    .button
                    ?.copyWith(color: Colors.white),
              ));
              },
      )],
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
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  @override
  initState() {
    super.initState();
    _getTime();
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
          getTextStyles: (context, value) =>
          const TextStyle(
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
          getTextStyles: (context, value) =>
          const TextStyle(
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

  void _getTime() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (DateTime
          .now()
          .second % 30 == 0) {
        setState(() {
          _startTime = formatDate(DateTime.now(), [hh, ':', nn, ':', ss,]);
          _endTime = formatDate(DateTime.now().add(const Duration(seconds: 30)),
              [hh, ':', nn, ':', ss,]);
        });
        totalTimeCount = 0;
        timeCount = 0;
      }
    });
  }

  String getStartMinuteString() {
    var f = NumberFormat('00');
    return f.format((5 * (DateTime
        .now()
        .minute ~/ 5))).toString();
  }

  String getEndMinuteString() {
    var f = NumberFormat('00');
    return f.format((5 * (DateTime
        .now()
        .add(const Duration(minutes: 5))
        .minute ~/ 5))).toString();
  }
}

class _customAppbar {
}



