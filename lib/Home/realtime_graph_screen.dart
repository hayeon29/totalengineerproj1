import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RealtimeGraph extends StatefulWidget {
  const RealtimeGraph({Key? key}) : super(key: key);

  @override
  _RealtimeGraphState createState() => _RealtimeGraphState();
}

class _RealtimeGraphState extends State<RealtimeGraph> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('실시간 그래프')
      ),
    );
  }
}
