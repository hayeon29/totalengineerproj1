import 'dart:io';
import 'dart:math';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
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
    date: "20211129",
    record: [
      RecordData(
        startTime: "02:33:54",
        endTime: "02:34:05",
        oxygenSatur: [77, 77, 77, 77, 75, 76, 78, 80, 79, 79, 79, 78],
        heartRate: [60, 60, 61, 61, 61, 61, 60, 59, 58, 58, 59, 59],
        sound: [55, 55, 56, 57, 43, 32, 21, 10, 2, 11, 38, 49, 55]
      ),
      RecordData(
          startTime: "03:22:13",
          endTime: "03:23:30",
          oxygenSatur: [87, 87, 86, 86, 86, 89, 89, 88, 87, 89, 89, 89, 88, 88, 87, 87, 87, 88],
          heartRate: [63, 64, 63, 63, 63, 63, 64, 65, 64, 66, 65, 67, 66, 65, 66, 64, 59, 60],
          sound: [54, 58, 49, 44, 29, 13, 00, 06, 19, 35, 49, 39, 25, 11, 03, 16, 25, 49]
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
    String current = DateFormat('yyyyMMdd').format(currentDate);
    final File file = File('$path/recordData$current.json');
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
    helper.deleteAllDogs();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('그래프페이지'),
      ),
      body:

      //리스트
      //파일 입출력 후 리스트 보여줄 것 => FutureBuilder 사용
      //FutureBuilder(
      //future: DBHelper().getAllDogs(), // 함수는 Future 로 반환된다.

      //BLoc 패턴 : StreamController 에 맞는 StreamBuilder 로 변경
        ListView(
          children: [
            Container(
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
                        '날짜 변경'
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft ,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                            DateFormat('MM월 dd일(EEE)').format(currentDate),
                            style: TextStyle(
                              fontSize: 20,
                            ),
                        ),
                      ),
                    ),
                    FutureBuilder<Graph>(
                      future: helper.getGraph(DateFormat('yyyyMMdd').format(currentDate)),
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          DateTime startTime = DateTime.parse('${snapshot.data!.date}T${snapshot.data!.checkStart}');
                          DateTime endTime = DateTime.parse('${snapshot.data!.date}T${snapshot.data!.checkEnd}');

                          int? acountValue = snapshot.data!.Acount;

                          int sleepTime = endTime.difference(startTime).inHours;
                          return Column(
                            children: [
                              PieGraph(sleepTime, acountValue!),
                              SizedBox(
                                height: 50,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    '나의 평균 무호흡 감지 수',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    '${snapshot.data!.avgAcount}회',
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
                                    '오늘 나의 평균 무호흡 감지 수',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    '${snapshot.data!.Acount}회',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
                                    //그래프 보여주기
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
                                          height: 30,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                '$index',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 30,
                                              ),

                                              Text(
                                                '${testData[index].startTime} ~ ${testData[index].endTime}',
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
                                );
                              });
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
                    Text(
                      'RDI',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
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
                    StreamBuilder(
                      stream: bloc.graphs,
                      //데이터는 builder 함수로 받아짐 //Snapshot : 한순간 받아진 데이터
                      builder: (BuildContext context, AsyncSnapshot<List<Graph>> snapshot) {
                        if (snapshot.hasData) {
                          //snapshot 에 데이터가 있으면 List 반환

                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              Graph item = snapshot.data![index];
                              print('snapshot data index = ${snapshot.data!.length}');
                              //리스트의 element 들은 각각 Dismissible 로 구현됨
                              return Dismissible(
                                  key: UniqueKey(),
                                  onDismissed: (direction) {
                                    //DBHelper().deleteDog(item.id); //사라지면서 동시에 DB 에서도 사라지게
                                    //setState(() {});

                                    //bloc 형태로 변형 : 스와이프 시 deleteDog 함수 호출
                                    bloc.deleteAll();
                                  },
                                  child: Row(
                                    children: [
                                      Text(item.id!.toString()+'/'),
                                      Text(item.mac!+'/'),
                                      Text(item.date!+'/'),
                                      Text(item.checkStart!+'/'),
                                      Text(item.checkEnd!.toString()+'/'),
                                      // Text(item.minB!.toString()+'/'),
                                      // Text(item.maxB!.toString()+'/'),
                                      // Text(item.avgB!.toString()+'/'),
                                      // Text(item.myminB!.toString()+'/'),
                                      // Text(item.mymaxB!.toString()+'/'),
                                      // Text(item.myavgB!.toString()+'/'),
                                      // Text(item.Acount!.toString()+'/'),
                                      // Text(item.avgAcount!.toString()+'/'),
                                      // Text(item.minS!.toString()+'/'),
                                      // Text(item.maxS!.toString()+'/'),
                                      // Text(item.myminS!.toString()+'/'),
                                      // Text(item.mymaxS!.toString()+'/'),
                                      // Text(item.rdi!.toString()+'/'),
                                    ],
                                  )
                              );
                            },
                          );
                        }
                        else //snapshot 에 데이터가 없으면 로딩창 반환
                        {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                        }
                      },
                    ),
                  ],
                ),
            ),
          ],
        ),

      //플로팅버튼(모두삭제, 하나추가)
      /*
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton(
            child: Icon(Icons.delete),
            onPressed: () {

              bloc.deleteAll();
            },
          ),
          SizedBox(height: 8),
          FloatingActionButton(
              child: Icon(Icons.search),
              onPressed: (){
                // 디폴트로 20211106 데이터가 검색되도록 해놨습니다.
                // findGraph()안에 원하는 날짜를 넣어 사용하시면 됩니다.
                bloc.findGraph('20211106');
              }
          ),
          FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              // 샘플 데이터셋에서 랜덤하게 데이터를 선택해서 추가합니다
              bloc.addGraph(graphs[Random().nextInt(graphs.length)]);
            },
          ),
        ],*/
    );
  }

  Widget rdiGraph(List<RdiData> rdiList){

    print('graph length = ${rdiList.length}');

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
                      primaryXAxis: NumericAxis(
                        isVisible: false,
                        //majorGridLines: const MajorGridLines(width: 0),
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        minimum: 0,
                        maximum: 31,
                      ),
                      primaryYAxis: NumericAxis(
                        isVisible: false,
                        plotBands: <PlotBand>[
                          PlotBand(
                              start: 5,
                              end: 5,
                              borderColor: Colors.greenAccent,
                              borderWidth: 2
                          ),
                          PlotBand(
                              start: 15,
                              end: 15,
                              borderColor: Colors.yellow,
                              borderWidth: 2
                          ),
                          PlotBand(
                              start: 30,
                              end: 30,
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
                    text: '시간',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '총 수면시간',
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
                text: '무호흡 횟수: ',
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
            RichText(
              text: TextSpan(
                text: '(사용자)님은\n',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '무호흡 증후군 정도\n',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget recordedGraph(String start, String end, List<GraphData> list){
    for(int i = 0; i < list.length; i++){
      print('${list[i].x} ');
    }
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.width * 0.8,
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

// 샘플데이터입니다. 원하시는데로 수정하시면 됩니다
// 전 날 기록 시작해서 다음 날로 넘어가는건 어떻게 기록해야할지 고민 => date를 저장하지 말고 checkStart와 checkEnd에 날짜를 집어넣는걸로??
// 평균 무호흡 수, 나의 산소포화도랑 그냥 산소포화도 다른 점이 뭔지 모르겠음
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
];

class apneaSensing {
  final String startDate;
  final String endDate;

  apneaSensing(this.startDate, this.endDate);
}

