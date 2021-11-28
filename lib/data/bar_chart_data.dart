import 'dart:ui';

class Data{
  final String date;
  final String time;
  final int y;

  const Data({
    required this.date,
    required this.time,
    required this.y
  });
}

class GraphData{
  GraphData(this.x, this.y);
  final int x;
  final int y;
}

class GraphwithColorData{
  GraphwithColorData(this.x, this.y, this.color);
  final int x;
  final int y;
  final Color? color;
}

class PieGraphData{
  PieGraphData(this.x, this.y, this.color);
  final String x;
  final int y;
  final Color? color;
}

class SensorData{
  List<GraphData> oxygenData = [];
  List<GraphData> heartData = [];
  List<GraphData> soundData = [];

  void addData(int value1, int value2, int value3){
    int chartTime = DateTime.now().second % 30;
    oxygenData.add(GraphData(chartTime, value1));
    heartData.add(GraphData(chartTime, value2));
    soundData.add(GraphData(chartTime, value3));
  }

  void deleteAllData(){
    oxygenData.clear();
    heartData.clear();
    soundData.clear();
  }
}
List<GraphData> oxygenData = [

];

List<GraphData> heartData = [

];

List<GraphData> soundData = [

];

int time = DateTime.now().second % 30;

SensorData data1 = SensorData();