import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

void main(){
  runApp(StartApp());
}

class StartApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: splashScreenStart(),
    );
  }
}

class splashScreenStart extends StatefulWidget {
  const splashScreenStart({Key? key}) : super(key: key);

  @override
  _splashScreenStartState createState() => _splashScreenStartState();
}

class _splashScreenStartState extends State<splashScreenStart> {

  @override
  initState(){
    super.initState();
    _init();
  }

  void _init() async{
    //데이터 불러오기 작업 수행
    Navigator.push( context, MaterialPageRoute(builder: (context) => MyApp()));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double. infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/sleep_logo.png", height: 120, ),
            SizedBox(height: 5, ),
            Image.asset("assets/images/sleep_logo_text.png", height: 30),

            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          ]
        )
      )
    );
  }
}
