import 'dart:io';
import 'dart:math';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_alarm/Graph/db_helper.dart';
import 'package:smart_alarm/data/bar_chart_data.dart';
import 'package:smart_alarm/data/record_data.dart';
import 'package:smart_alarm/data/record_date_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'graph_bloc.dart';
import 'graph_model.dart';

import 'package:smart_alarm/widget/calendar_widget.dart' as calendar;
import 'package:smart_alarm/widget/pie_chart_widget.dart';
import 'package:smart_alarm/data/calendar_data.dart';

void main(){
  runApp(GraphWatch());
}

class GraphWatch extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GraphScreen(),
    );
  }
}


class GraphScreen extends StatefulWidget {
  const GraphScreen({Key? key}) : super(key: key);

  @override
  _GraphScreenState createState() => _GraphScreenState();

}

class _GraphScreenState extends State<GraphScreen> {

  DBHelper helper = DBHelper();

  final GraphBloc bloc = GraphBloc();
  RecordDateData test = RecordDateData(
    date: "20211128",
    record: [
      RecordData(
        startTime: "02:20:13",
        endTime: "03:20:32",
        oxygenSatur: [13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32],
        heartRate: [32,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13],
        sound: [25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25]
      ),
      RecordData(
          startTime: "03:22:13",
          endTime: "03:23:30",
          oxygenSatur: [13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30],
          heartRate: [32,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15],
          sound: [25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25]
      ),
      RecordData(
          startTime: "04:40:34",
          endTime: "04:40:55",
          oxygenSatur: [13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32],
          heartRate: [32,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13],
          sound: [25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25]
      ),
      RecordData(
          startTime: "04:45:55",
          endTime: "04:46:12",
          oxygenSatur: [13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32],
          heartRate: [32,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13],
          sound: [25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25]
      ),
    ]
  );
  
  late List testRecord;
  late List<RecordData> testCastRecord;

  late File jsonFile;
  late Directory dir;
  String fileName = "recordData";
  bool fileExists = false;
  bool _visibility = false;
  int graphIndex = 0;
  int time = 8;
  int acount = 10;
  List<RecordData> graphRecord = [
        RecordData(
            startTime: "00:00:00",
            endTime: "00:00:00",
            oxygenSatur: [],
            heartRate: [],
            sound: []
        ),
      ];

  List<GraphData> oxygen = [];
  List<GraphData> heart = [];
  List<GraphData> sound = [];

  Future<List<RdiData>> getRDIValue() async {
    String currentMonth = DateFormat('MM').format(currentDate);
    List<RdiData> rdiValue = await helper.getRDIData(currentMonth);

    return rdiValue;
  }

  Future<RecordDateData> readJson() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path;
    print(path);
    String current = DateFormat('yyyyMMdd').format(currentDate);
    final File file = File('$path/recordData${current}.json');
    String contents = await file.readAsString();
    //final String contents = await rootBundle.loadString('$path/recordData$current.json');
    //String contents = await DefaultAssetBundle.of(context).loadString("$path/recordData_$current.json");
    final data = await json.decode(contents);
    return RecordDateData.fromJson(data);
  }

  Future<File> writeCounter(String data) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path;
    print(path);
    String current = DateFormat('yyyyMMdd').format(currentDate);
    final File file = File('$path/recordData$current.json');

    // Write the file
    return file.writeAsString('$data');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String, dynamic> record = test.toJson();
    String testString = json.encode(record);
    writeCounter(testString).then((result)=>{
      print(result.toString())
    });
    readJson().then((result)=>{
      print(result.toString())
    });
    for(int i = 0; i < graphs.length; i++){
      helper.insertData(graphs[i]);
    }
    //helper.deleteAllDogs();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('??????????????????'),
        backgroundColor: const Color(0xff012061),
        elevation: 0.0,
      ),
      body:

      //?????????
      //?????? ????????? ??? ????????? ????????? ??? => FutureBuilder ??????
      //FutureBuilder(
      //future: DBHelper().getAllDogs(), // ????????? Future ??? ????????????.

      //BLoc ?????? : StreamController ??? ?????? StreamBuilder ??? ??????
        ListView(
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
                  children: [
                    Container(
                      height: 400,
                      child: SizedBox(child: calendar.CalendarWidget()),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState((){
                          _visibility = false;
                          time = Random().nextInt(23);
                        });
                      },
                      child: Text(
                        '?????? ??????'
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft ,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                            DateFormat('MM??? dd???(EEE)').format(currentDate),
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FutureBuilder<Graph>(
                      future: helper.getGraph(DateFormat('yyyyMMdd').format(currentDate)),
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          DateTime startTime = DateTime.parse('${snapshot.data!.date}T${snapshot.data!.checkStart}');
                          DateTime endTime = DateTime.parse('${snapshot.data!.date}T${snapshot.data!.checkEnd}');

                          int? acountValue = snapshot.data!.Acount;

                          int sleepTime = endTime.difference(startTime).inHours;
                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(32)),
                            ),
                            color: const Color(0xffffffff),
                            child: Column(
                              children: [
                                PieGraph(sleepTime, acountValue!),
                                SizedBox(
                                  height: 50,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      '?????? ?????? ????????? ?????? ???',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      '${snapshot.data!.avgAcount}???',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      '?????? ?????? ?????? ????????? ?????? ???',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      '${snapshot.data!.Acount}???',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          );
                        }
                        else if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(fontSize: 15),
                            ),
                          );
                        }
                        else{
                          return CircularProgressIndicator();
                        }
                      }
                    ),
                    FutureBuilder<RecordDateData> (
                      future: readJson(),
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          graphRecord = snapshot.data!.record;
                          final testData = snapshot.data!.record;
                          return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(vertical:10),
                              itemCount: testData.length,
                              itemBuilder: (BuildContext context, int index){
                                return GestureDetector(
                                  onTap: () {
                                    //????????? ????????????
                                    setState((){
                                      graphIndex = index;
                                      oxygen.clear();
                                      heart.clear();
                                      sound.clear();
                                      for(int i = 0; i < testData[index].oxygenSatur.length; i++){
                                        oxygen.add(GraphData(i, testData[index].oxygenSatur[i]));
                                        heart.add(GraphData(i, testData[index].heartRate[i]));
                                        sound.add(GraphData(i, testData[index].sound[i]));
                                      }
                                      _visibility = true;
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        child: Container(
                                          width: MediaQuery.of(context).size.width,
                                          child: Card(
                                            elevation: 4,
                                            color: const Color(0xffffffff),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                '${testData[index].startTime} ~ ${testData[index].endTime}',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        }
                        else if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '???????????? ????????????',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }
                        else{
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                    Visibility(
                      child: recordedGraph(graphRecord[graphIndex].startTime, graphRecord[graphIndex].endTime, oxygen),
                      visible: _visibility,
                    ),
                    Visibility(
                      child: recordedGraph(graphRecord[graphIndex].startTime, graphRecord[graphIndex].endTime, heart),
                      visible: _visibility,
                    ),
                    Visibility(
                      child: recordedGraph(graphRecord[graphIndex].startTime, graphRecord[graphIndex].endTime, sound),
                      visible: _visibility,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left : 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'RDI',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    FutureBuilder<List<RdiData>>(
                      future: getRDIValue(),
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          return rdiGraph(snapshot.data!);
                        }
                        else if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(fontSize: 15),
                            ),
                          );
                        }
                        else{
                          return CircularProgressIndicator();
                        }
                      }
                    ),
                  ],
                ),
            ),
          ],
        ),
    );
  }

  Widget rdiGraph(List<RdiData> rdiList){

    TooltipBehavior _tooltipBehavior = TooltipBehavior(
        enable: true,
        tooltipPosition: TooltipPosition.auto
    );

    List<GraphwithColorData> rdiValueWithColor = [];
    for(int i = 0; i < rdiList.length; i++){
      if(rdiList[i].rdiValue! < 15){
        rdiValueWithColor.add(GraphwithColorData(int.parse(rdiList[i].date!), rdiList[i].rdiValue!, Colors.greenAccent));
      }
      else if(rdiList[i].rdiValue! < 30){
        rdiValueWithColor.add(GraphwithColorData(int.parse(rdiList[i].date!), rdiList[i].rdiValue!, Colors.yellow));
      }
      else{
        rdiValueWithColor.add(GraphwithColorData(int.parse(rdiList[i].date!), rdiList[i].rdiValue!, Colors.red));
      }
    }

    return AspectRatio(
      aspectRatio: 3/2,
      child:Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        color: const Color(0xffffffff),
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child:SafeArea(
              child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SfCartesianChart(
                      plotAreaBorderWidth: 0,
                      series: <ColumnSeries<GraphwithColorData,int>>[
                        ColumnSeries<GraphwithColorData, int>(
                          width: 0.4,
                          dataSource: rdiValueWithColor,
                          xValueMapper: (GraphwithColorData g, _) => g.x,
                          yValueMapper: (GraphwithColorData g, _) => g.y,
                          pointColorMapper: (GraphwithColorData g, _) => g.color,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        )
                      ],
                      tooltipBehavior: _tooltipBehavior,
                      primaryXAxis: NumericAxis(
                        //isVisible: false,
                        anchorRangeToVisiblePoints: false,
                        majorGridLines: const MajorGridLines(width: 0),
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        minimum: 1,
                        maximum: 31,
                        interval: 3,
                      ),
                      primaryYAxis: NumericAxis(
                        isVisible: false,
                        plotBands: <PlotBand>[
                          PlotBand(
                              start: 5,
                              end: 5,
                              dashArray: <double>[5,5],
                              borderColor: Colors.greenAccent,
                              borderWidth: 2,
                              text: '5',
                              textStyle: TextStyle(color: Colors.greenAccent)
                          ),
                          PlotBand(
                              start: 15,
                              end: 15,
                              dashArray: <double>[5,5],
                              borderColor: Colors.yellow,
                              borderWidth: 2,
                              text: '15',
                              textStyle: TextStyle(color: Colors.yellow)
                          ),
                          PlotBand(
                              start: 30,
                              end: 30,
                              dashArray: <double>[5,5],
                              borderColor: Colors.red,
                              borderWidth: 2,
                              text: '30',
                              textStyle: TextStyle(color: Colors.red)
                          )
                        ],
                        axisLine: const AxisLine(width: 0),
                      )
                  )
              )
          ),
        ),
      ),
    );
  }

  Widget PieGraph(int time, int acount){
    return Row(
      children: <Widget>[
        Column(
          children: [
            Container(
              height: 200,
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChartWidget(time: time),
              ),
            ),
            RichText(
              text: TextSpan(
                text: '$time',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '??????',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '??? ????????????',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
        Column(
          children: [
            RichText(
              text: TextSpan(
                text: '????????? ??????: ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '$acount',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Align(
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(
                  text: '(?????????)??????\n',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '????????????????????? ???????????????\n',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget recordedGraph(String start, String end, List<GraphData> list){

    TooltipBehavior _tooltipBehavior = TooltipBehavior(
        enable: true,
        tooltipPosition: TooltipPosition.auto
    );

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 0.9,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
        ),
        //color: const Color(0xffffffff),
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                SfCartesianChart(
                    plotAreaBorderWidth: 0,
                    series: <LineSeries<GraphData, int>>[
                      LineSeries<GraphData, int>(
                          dataSource: list,
                          xValueMapper: (GraphData g, _) => g.x,
                          yValueMapper: (GraphData g, _) => g.y,
                          color: Color(0xff012061)
                      )
                    ],
                    tooltipBehavior: _tooltipBehavior,
                    primaryXAxis: NumericAxis(
                      //isVisible: false,
                      majorGridLines: const MajorGridLines(width: 0),
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      interval: 3,
                      minimum: 0,
                      maximum: list.length - 1,
                    ),
                    primaryYAxis: NumericAxis(
                      //isVisible: false,
                      axisLine: const AxisLine(width: 0),
                      majorTickLines: const MajorTickLines(size: 0),
                    )
                ),
                Row(
                  mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        '$start',
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
                        '$end',
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
          ),
        ),
      ),
    );
    return Scaffold(


    );
  }

}

// ????????????????????????. ?????????????????? ??????????????? ?????????
// ??? ??? ?????? ???????????? ?????? ?????? ??????????????? ????????? ?????????????????? ?????? => date??? ???????????? ?????? checkStart??? checkEnd??? ????????? ????????????????????
// ?????? ????????? ???, ?????? ?????????????????? ?????? ??????????????? ?????? ?????? ?????? ????????????
List<Graph> graphs = [
  Graph( mac: '23:23:23:23:23', date:'20211123', checkStart:'01:03:25', checkEnd:"07:28:10", minB: 13, maxB: 23, avgB: 18, myminB: 14, mymaxB: 24, myavgB: 19, Acount: 5, avgAcount: 3, minS: 93, maxS:99, myminS:93, mymaxS: 99, rdi:13),
  Graph( mac: '24:24:24:24:24', date:'20211124', checkStart:'02:40:01', checkEnd:"07:24:53", minB: 14, maxB: 24, avgB: 19, myminB: 15, mymaxB: 25, myavgB: 20, Acount: 6, avgAcount: 3, minS: 94, maxS: 100, myminS: 94, mymaxS: 100,  rdi: 14),
  Graph( mac: '25:25:25:25:25', date:'20211125', checkStart:'01:23:54', checkEnd:"08:30:55", minB: 15, maxB: 25, avgB: 20, myminB: 16, mymaxB: 26, myavgB: 21, Acount: 7, avgAcount: 4, minS: 95, maxS: 100,  myminS: 95, mymaxS: 100, rdi: 15),
  Graph( mac: '26:26:26:26:26', date:'20211126', checkStart:'00:25:37', checkEnd:"08:13:24", minB: 16, maxB: 26, avgB: 21, myminB: 17, mymaxB: 27, myavgB: 22, Acount: 8, avgAcount: 4, minS: 96, maxS: 100,  myminS: 96, mymaxS: 100, rdi: 16),
  Graph( mac: '27:27:27:27:27', date:'20211127', checkStart:'01:13:37', checkEnd:"08:30:33", minB: 17, maxB: 27, avgB: 22, myminB: 18, mymaxB: 28, myavgB: 23, Acount: 5, avgAcount: 3, minS: 97, maxS: 99, myminS: 97, mymaxS: 99,  rdi: 17),
  Graph( mac: '28:28:28:28:28', date:'20211128', checkStart:'00:13:28', checkEnd:"06:28:35", minB: 18, maxB: 28, avgB: 23, myminB: 19, mymaxB: 29, myavgB: 24, Acount: 6, avgAcount: 3, minS: 98, maxS: 100, myminS: 98, mymaxS: 100,  rdi: 18),
  Graph( mac: '17:17:17:17:17', date:'20211117', checkStart:'01:25:43', checkEnd:"07:48:22", minB: 19, maxB: 29, avgB: 24, myminB: 20, mymaxB: 30, myavgB: 25, Acount: 7, avgAcount: 4, minS: 94, maxS: 99, myminS: 94, mymaxS: 99,  rdi: 19),
  Graph( mac: '18:18:18:18:18', date:'20211118', checkStart:'00:03:24', checkEnd:"08:00:07", minB: 20, maxB: 30, avgB: 25, myminB: 21, mymaxB: 31, myavgB: 26, Acount: 8, avgAcount: 4, minS: 95 , maxS: 100, myminS: 95, mymaxS: 100,  rdi: 20),
  Graph( mac: '19:19:19:19:19', date:'20211119', checkStart:'02:33:14', checkEnd:"07:24:32", minB: 21, maxB: 31, avgB: 26, myminB: 22, mymaxB: 32, myavgB: 27, Acount: 4, avgAcount: 3, minS: 95, maxS: 99,  myminS: 95, mymaxS: 99, rdi: 21),
  Graph( mac: '20:20:20:20:20', date:'20211120', checkStart:'01:03:21', checkEnd:"08:13:22", minB: 22, maxB: 32, avgB: 27, myminB: 23, mymaxB: 33, myavgB: 28, Acount: 5, avgAcount: 3, minS: 97, maxS: 100, myminS: 97, mymaxS: 100, rdi: 22),
  Graph( mac: '21:21:21:21:21', date:'20211121', checkStart:'00:27:33', checkEnd:"06:28:39", minB: 23, maxB: 33, avgB: 28, myminB: 24, mymaxB: 34, myavgB: 29, Acount: 6, avgAcount: 4, minS: 98, maxS: 100, myminS: 98, mymaxS: 100, rdi: 23),
  Graph( mac: '22:22:22:22:22', date:'20211122', checkStart:'01:03:13', checkEnd:"07:29:33", minB: 24, maxB: 34, avgB: 29, myminB: 25, mymaxB: 35, myavgB: 30, Acount: 7, avgAcount: 4, minS: 92, maxS: 100, myminS: 92, mymaxS: 100, rdi: 19),
  Graph( mac: '29:29:29:29:29', date:'20211129', checkStart:'00:08:24', checkEnd:"09:14:33", minB: 13, maxB: 23, avgB: 18, myminB: 14, mymaxB: 24, myavgB: 19, Acount: 5, avgAcount: 3, minS: 93, maxS: 99, myminS: 93, mymaxS: 99, rdi: 13),
  Graph( mac: '30:30:30:30:30', date:'20211130', checkStart:'02:52:33', checkEnd:"09:07:32", minB: 14, maxB: 24, avgB: 19, myminB: 15, mymaxB: 25, myavgB: 20, Acount: 6, avgAcount: 4, minS: 96, maxS: 100, myminS: 96, mymaxS: 100, rdi: 14),
];

class apneaSensing {
  final String startDate;
  final String endDate;

  apneaSensing(this.startDate, this.endDate);
}

