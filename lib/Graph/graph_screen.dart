import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'graph_bloc.dart';
import 'graph_model.dart';

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

  final GraphBloc bloc = GraphBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('그래프페이지'),
      ),
      body: //리스트
      //파일 입출력 후 리스트 보여줄 것 => FutureBuilder 사용
      //FutureBuilder(
      //future: DBHelper().getAllDogs(), // 함수는 Future 로 반환된다.

      //BLoc 패턴 : StreamController 에 맞는 StreamBuilder 로 변경
      StreamBuilder(
        stream: bloc.graphs,
        //데이터는 builder 함수로 받아짐 //Snapshot : 한순간 받아진 데이터
        builder: (BuildContext context, AsyncSnapshot<List<Graph>> snapshot) {
          if (snapshot.hasData) {
            //snapshot 에 데이터가 있으면 List 반환

            return ListView.builder(
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
          } else //snapshot 에 데이터가 없으면 로딩창 반환
              {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
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
}

// 샘플데이터입니다. 원하시는데로 수정하시면 됩니다
List<Graph> graphs = [
  Graph( mac: 'aaa', date:'20211105', checkStart:'000000', checkEnd:"083000", minB: 10, maxB: 11, avgB: 10, myminB: 6, mymaxB: 14, myavgB:10, Acount:2, avgAcount:3, minS:92, maxS:99, myminS:91, mymaxS:100, rdi:15),
  Graph( mac: 'aaa', date:'20211106', checkStart:'000000', checkEnd:"083000", minB:8, maxB:13, avgB:10, myminB: 6, mymaxB: 14, myavgB:10, Acount:3, avgAcount:3, minS:93, maxS:99, myminS:91, mymaxS:100,  rdi:20),
  Graph( mac: 'aaa', date:'20211107', checkStart:'000000', checkEnd:"083000", minB:7, maxB:12, avgB:9, myminB: 6, mymaxB: 14, myavgB:10, Acount:2, avgAcount:3, minS:94, maxS:100,  myminS:91, mymaxS:100, rdi:10),
  Graph( mac: 'aaa', date:'20211108', checkStart:'000000', checkEnd:"083000", minB:8, maxB:10, avgB:9, myminB: 6, mymaxB: 14, myavgB:10, Acount:2, avgAcount:3, minS:93, maxS:100,  myminS:91, mymaxS:100, rdi:10),
  Graph( mac: 'aaa', date:'20211109', checkStart:'000000', checkEnd:"083000", minB:9, maxB:12, avgB:11, myminB: 6, mymaxB: 14, myavgB:10, Acount:4, avgAcount:3, minS:95, maxS:100, myminS:91, mymaxS:100,  rdi:20),
  Graph( mac: 'aaa', date:'20211110', checkStart:'000000', checkEnd:"083000", minB:6, maxB:13, avgB:10, myminB: 6, mymaxB: 14, myavgB:10, Acount:5, avgAcount:3, minS:94, maxS:98, myminS:91, mymaxS:100,  rdi:40),
  Graph( mac: 'aaa', date:'20211111', checkStart:'000000', checkEnd:"083000", minB:9, maxB:11, avgB:10, myminB: 6, mymaxB: 14, myavgB:10, Acount:5, avgAcount:4, minS:95, maxS:98, myminS:91, mymaxS:100,  rdi:40),
  Graph( mac: 'aaa', date:'20211112', checkStart:'000000', checkEnd:"083000", minB:8, maxB:12, avgB:10, myminB: 6, mymaxB: 14, myavgB:10, Acount:3, avgAcount:4, minS:93, maxS:99, myminS:91, mymaxS:100,  rdi:15),
  Graph( mac: 'aaa', date:'20211113', checkStart:'000000', checkEnd:"083000", minB:7, maxB:11, avgB:9, myminB: 6, mymaxB: 14, myavgB:10, Acount:4, avgAcount:4, minS:95, maxS:98,  myminS:91, mymaxS:100, rdi:30),
  Graph( mac: 'aaa', date:'20211114', checkStart:'000000', checkEnd:"083000", minB:8, maxB:12, avgB:10, myminB: 6, mymaxB: 14, myavgB:10, Acount:2, avgAcount:4, minS:95, maxS:98, myminS:91, mymaxS:100, rdi:30),
  Graph( mac: 'aaa', date:'20211115', checkStart:'000000', checkEnd:"083000", minB:9, maxB:13, avgB:11, myminB: 6, mymaxB: 14, myavgB:10, Acount:5, avgAcount:4, minS:94, maxS:97, myminS:91, mymaxS:100, rdi:40),
  Graph( mac: 'aaa', date:'20211116', checkStart:'000000', checkEnd:"083000", minB:6, maxB:14, avgB:10, myminB: 6, mymaxB: 14, myavgB:10, Acount:0, avgAcount:3, minS:93, maxS:100, myminS:91, mymaxS:100, rdi:0),
];


