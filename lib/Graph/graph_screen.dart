import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_alarm/Graph/database.dart';

import 'Model/graph_data.dart';
//import 'package:fl_chart/fl_chart.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({Key? key}) : super(key: key);

  @override
  _GraphScreenState createState() => _GraphScreenState();

}

class _GraphScreenState extends State<GraphScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('그래프 열람')
        ),
        body: Column(
          children: <Widget>[
            OutlinedButton(onPressed: saveDB, child: Text('데이터 삽입하기'),),
            //OutlinedButton(onPressed: loadData, child: Text('데이터 가져오기'),),
            listBuilder(),
          ],
        )
    );
  }

  Future<Graph>loadData() async {
    DBHelper helper = DBHelper();
    var fido = await helper.readData(10);
    return fido;
  }


  Widget listBuilder() {
    return FutureBuilder(
        future: loadData(),
        builder: (context, projectSnap) {
          if (projectSnap.hasData == false) {
            print('project snapshot data is: ${projectSnap.data}');
            return Container();
          }
          Graph graph = projectSnap.data;
          return Column(
              children: <Widget>[
                Text(graph.id.toString()??''),
                Text(graph.mac??''),
                Text(graph.date??''),
                Text(graph.checkStart??''),
                Text(graph.checkEnd??''),
                Text(graph.rdi.toString()??'')
              ]);
        });
  }


Future<void> saveDB() async {
  DBHelper sd = DBHelper();

  var fibo = Graph(
      10,
      'mac',
      DateTime.now().toString(),
      'start',
      'end',
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13
  );

  await sd.insertData(fibo);
}
}

