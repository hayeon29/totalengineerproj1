import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_alarm/widget/calendar_widget.dart' as calendar;
import 'package:smart_alarm/widget/pie_chart_widget.dart' as piechart;

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
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
            child:Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(20.0),
                  child: SizedBox(
                    height: 400.0,
                    child: calendar.CalendarWidget(),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft ,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      DateFormat('MM월 dd일 (E)').format(DateTime.now()),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20.0),
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: piechart.PieChartWidget(),
                          ),
                          RichText(
                            text: TextSpan(
                              text: '8',
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '시간',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text(
                            '총 수면시간',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ]
                      )
                    ],
                  ),
                )
              ]
            )
          )
        ]
      )
    );
  }
}
