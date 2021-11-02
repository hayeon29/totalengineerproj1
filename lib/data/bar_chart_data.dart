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

List<int> barData = [

];
