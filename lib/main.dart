import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {
  var switchValue = false;
  String btnText = '스캔 시작';

  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme:ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: Center(
          child: RaisedButton(
            child: Text('$btnText'),
              onPressed: () {
                if(btnText == '스캔 시작') {
                  setState(() {
                    btnText = '스캔 종료';
                  });
                } else {
                  setState(() {
                    btnText = '스캔 시작';
                  });
                }
              },
          ),
        ),
      )
    );
  }
}


