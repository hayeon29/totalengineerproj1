
// Bloc 패턴으로 데이터와 뷰의 갱신담당
import 'dart:async';

import 'package:smart_alarm/Graph/db_helper.dart';

import 'graph_model.dart';

class GraphBloc {
  GraphBloc() {
    // 기존 데이터에서 그대로 불러올것 (생성자에서 데이터 호출)
    // 생성자에는 async 사용 불가능 -> getDatas 함수로 대체
    getGraphs();
  }

  final _graphController = StreamController<List<Graph>>.broadcast();
  get graphs => _graphController.stream;

  dispose() {
    _graphController.close();
  }

  getGraphs() async {
    _graphController.sink.add(await DBHelper().getAllGraphs());
  }

  addGraph(Graph graph) async {
    await DBHelper().insertData(graph);
    _graphController.sink.add(await DBHelper().getAllGraphs());
  }

  findGraph(String date) async {
    await DBHelper().findData(date);
    _graphController.sink.add(await DBHelper().getGraphs(date));
  }

  deleteAll() async {
    await DBHelper().deleteAllDogs();
    _graphController.sink.add(await DBHelper().getAllGraphs());
  }
}