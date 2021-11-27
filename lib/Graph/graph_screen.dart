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
  final List<apneaSensing> apneaTimeRecode = [
    apneaSensing("03:20:13", "03:20:32"),
    apneaSensing("03:22:13", "03:23:30"),
    apneaSensing("04:40:34", "04:40:55"),
    apneaSensing("04:45:55", "04:46:12"),
  ];

  RecordDateData test = RecordDateData(
    date: "20211124",
    record: [
      RecordData(
        startTime: "03:20:13",
        endTime: "03:20:32",
        oxygenSatur: [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32],
        heartRate: [32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13],
        sound: [25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25]
      ),
      RecordData(
          startTime: "03:22:13",
          endTime: "03:23:30",
          oxygenSatur: [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30],
          heartRate: [32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15],
          sound: [25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25]
      ),
      RecordData(
          startTime: "04:40:34",
          endTime: "04:40:55",
          oxygenSatur: [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32],
          heartRate: [32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13],
          sound: [25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25]
      ),
      RecordData(
          startTime: "04:45:55",
          endTime: "04:46:12",
          oxygenSatur: [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32],
          heartRate: [32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13],
          sound: [25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25]
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
    //print(testString);
    writeCounter(testString).then((result)=>{
      print(result.toString())
    });
    readJson().then((result)=>{
      print(result.toString())
    });
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

                          int sleepTime = startTime.compareTo(endTime);
                          return PieGraph(time, acount);
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
                          '2.5회',
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
                          '4.3회',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
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
                                      Text(item.minB!.toString()+'/'),
                                      Text(item.maxB!.toString()+'/'),
                                      Text(item.avgB!.toString()+'/'),
                                      Text(item.myminB!.toString()+'/'),
                                      Text(item.mymaxB!.toString()+'/'),
                                      Text(item.myavgB!.toString()+'/'),
                                      Text(item.Acount!.toString()+'/'),
                                      Text(item.avgAcount!.toString()+'/'),
                                      Text(item.minS!.toString()+'/'),
                                      Text(item.maxS!.toString()+'/'),
                                      Text(item.myminS!.toString()+'/'),
                                      Text(item.mymaxS!.toString()+'/'),
                                      Text(item.rdi!.toString()+'/'),
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
        ],
      ),
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
                    text: '중도증무호흡이 의심됩니다\n',
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
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 0.85,
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
                      minimum: 0,
                      maximum: 50,
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
List<Graph> graphs = [
  Graph( mac: 'aaa', date:'20211105', checkStart:'00:00:00', checkEnd:"08:30:00", minB: 10, maxB: 11, avgB: 10, myminB: 6, mymaxB: 14, myavgB:10, Acount:2, avgAcount:3, minS:92, maxS:99, myminS:91, mymaxS:100, rdi:15),
  Graph( mac: 'aaa', date:'20211106', checkStart:'00:00:00', checkEnd:"08:30:00", minB:8, maxB:13, avgB:10, myminB: 6, mymaxB: 14, myavgB:10, Acount:3, avgAcount:3, minS:93, maxS:99, myminS:91, mymaxS:100,  rdi:20),
  Graph( mac: 'aaa', date:'20211107', checkStart:'00:00:00', checkEnd:"08:30:00", minB:7, maxB:12, avgB:9, myminB: 6, mymaxB: 14, myavgB:10, Acount:2, avgAcount:3, minS:94, maxS:100,  myminS:91, mymaxS:100, rdi:10),
  Graph( mac: 'aaa', date:'20211108', checkStart:'00:00:00', checkEnd:"08:30:00", minB:8, maxB:10, avgB:9, myminB: 6, mymaxB: 14, myavgB:10, Acount:2, avgAcount:3, minS:93, maxS:100,  myminS:91, mymaxS:100, rdi:10),
  Graph( mac: 'aaa', date:'20211109', checkStart:'00:00:00', checkEnd:"08:30:00", minB:9, maxB:12, avgB:11, myminB: 6, mymaxB: 14, myavgB:10, Acount:4, avgAcount:3, minS:95, maxS:100, myminS:91, mymaxS:100,  rdi:20),
  Graph( mac: 'aaa', date:'20211110', checkStart:'00:00:00', checkEnd:"08:30:00", minB:6, maxB:13, avgB:10, myminB: 6, mymaxB: 14, myavgB:10, Acount:5, avgAcount:3, minS:94, maxS:98, myminS:91, mymaxS:100,  rdi:40),
  Graph( mac: 'aaa', date:'20211111', checkStart:'00:00:00', checkEnd:"08:30:00", minB:9, maxB:11, avgB:10, myminB: 6, mymaxB: 14, myavgB:10, Acount:5, avgAcount:4, minS:95, maxS:98, myminS:91, mymaxS:100,  rdi:40),
  Graph( mac: 'aaa', date:'20211112', checkStart:'00:00:00', checkEnd:"08:30:00", minB:8, maxB:12, avgB:10, myminB: 6, mymaxB: 14, myavgB:10, Acount:3, avgAcount:4, minS:93, maxS:99, myminS:91, mymaxS:100,  rdi:15),
  Graph( mac: 'aaa', date:'20211113', checkStart:'00:00:00', checkEnd:"08:30:00", minB:7, maxB:11, avgB:9, myminB: 6, mymaxB: 14, myavgB:10, Acount:4, avgAcount:4, minS:95, maxS:98,  myminS:91, mymaxS:100, rdi:30),
  Graph( mac: 'aaa', date:'20211114', checkStart:'00:00:00', checkEnd:"08:30:00", minB:8, maxB:12, avgB:10, myminB: 6, mymaxB: 14, myavgB:10, Acount:2, avgAcount:4, minS:95, maxS:98, myminS:91, mymaxS:100, rdi:30),
  Graph( mac: 'aaa', date:'20211115', checkStart:'00:00:00', checkEnd:"08:30:00", minB:9, maxB:13, avgB:11, myminB: 6, mymaxB: 14, myavgB:10, Acount:5, avgAcount:4, minS:94, maxS:97, myminS:91, mymaxS:100, rdi:40),
  Graph( mac: 'aaa', date:'20211116', checkStart:'00:00:00', checkEnd:"08:30:00", minB:6, maxB:14, avgB:10, myminB: 6, mymaxB: 14, myavgB:10, Acount:0, avgAcount:3, minS:93, maxS:100, myminS:91, mymaxS:100, rdi:0),
];

class apneaSensing {
  final String startDate;
  final String endDate;

  apneaSensing(this.startDate, this.endDate);
}

