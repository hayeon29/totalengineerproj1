import 'dart:async';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_alarm/widget/oxygen_satur_chart_widget.dart' as oxygenChart;
import 'package:smart_alarm/widget/heart_rate_chart_widget.dart' as HeartRateChart;
import 'package:smart_alarm/widget/sound_chart_widget.dart' as SoundChart;


class RealtimeGraph extends StatefulWidget {
  const RealtimeGraph({Key? key, required this.device}) : super(key: key);
  final BluetoothDevice device;
  @override
  _RealtimeGraphState createState() => _RealtimeGraphState();
}

class _RealtimeGraphState extends State<RealtimeGraph> {

  StreamController<int> streamController = StreamController<int>();
  StreamController<int> streamController1 = StreamController<int>();
  StreamController<int> streamController2 = StreamController<int>();
  StreamController<double> streamController3 = StreamController<double>();

  double bpm = 0;
  int apnea = 1;
  bool isApnea = false;
  int start = 1;

  var _flutterLocalNotificationsPlugin;

  late Timer timer;

  @override
  initState(){
    super.initState();
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  void dispose() {
    if(timer.isActive){
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: BackButton(
            color: Colors.white
        ),
        title: Text("????????? ?????? ?????????"),
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
                  //1. ???????????????
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      '????????? ??????????????? ?????????',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 0.9,
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
                  // 2. ?????????
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      '????????? ????????? ?????????',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 0.9,
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
                  //3. ??????
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      '????????? ?????? ?????????',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 0.9,
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
                  Row(
                    mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          '?????? ????????? ???',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: StreamBuilder<double>(
                          stream: streamController3.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                '${snapshot.data!.toStringAsFixed(2)}' + '???',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
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
                          '????????? ?????? ??????',
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
                          '$apnea' + '???',
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
                    height: 70,
                  ),
                  RaisedButton(
                    onPressed: _showNotification,
                    child: Text('Show Notification'),
                  ),
                  RaisedButton(
                    onPressed: (){
                      timer = Timer.periodic(const Duration(seconds: 1), updateDataSource);
                    },
                    child: Text('?????? ??????'),
                  ),
                  RaisedButton(
                    onPressed: (){
                      timer.cancel();
                      streamController.close();
                      streamController1.close();
                      streamController2.close();
                    },
                    child: Text('?????? ??????'),
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }

  Future<void> _showNotification() async {
    var android = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max, priority: Priority.high);

    var ios = IOSNotificationDetails();
    var detail = NotificationDetails(android: android, iOS: ios);

    String currentDate = DateFormat('MM??? dd??? hh:mm:ss').format(DateTime.now());

    await _flutterLocalNotificationsPlugin.show(
      0,
      '????????? ??????',
      '$currentDate?????? ???????????? ?????????????????????',
      detail,
    );
  }

  double cumulativeAverage (double prevAvg, int newNumber, int listLength) {
    double oldWeight = (listLength - 1) / listLength;
    double newWeight = 1 / listLength;
    return (prevAvg * oldWeight) + (newNumber * newWeight);
  }

  void updateDataSource(Timer timer) {
    int randValue = Random().nextInt(50) + 50;
    int randValue1 = Random().nextInt(50) + 50;
    int randValue2 = Random().nextInt(50) + 50;
    streamController.add(randValue);
    streamController1.add(randValue1);
    streamController2.add(randValue2);
    if(isApnea == true){

    }
    else{
      bpm = cumulativeAverage(bpm, randValue1, start++);
      streamController3.add(bpm);
    }
    //if(isApnea = true ??????){
    //  record_data ???????????? ???????????? ????????? ?????? ??????
    //  List.add(value1, value2, value3);
    //  if(??????????????? ??????????????? ????????????){
    //    isApnea = false ??? ??????
    //    record_date_data.record_data.add(List);
    //  }
    //}
    //else{ //isApnea = false ??????
    //  ????????? ??? ?????? ????????? ???????????? ????????? ??????
    //  if(?????? ?????????????????? ???????????????){
    //    isApnea(bool) = true ??? ??????
    //  }
    //}
  }
}

class _customAppbar {
}


