import 'package:smart_alarm/Graph/Model/graph_data.dart';

abstract class GraphDataRepo {
  Future<GraphData> getDatabyDate(String date);
}