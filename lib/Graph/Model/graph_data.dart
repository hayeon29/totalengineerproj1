import 'dart:core';

class GraphData {
  final int id;
  final String mac;
  final String date;
  final String checkStart;
  final String checkEnd;
  final int minB;
  final int maxB;
  final int avgB;
  final int myminB;
  final int mymaxB;
  final int myavgB;
  final int Acount;
  final int avgAcount;
  final int minS;
  final int maxS;
  final int myminS;
  final int mymaxS;
  final int rdi;

  GraphData(this.id, this.mac, this.date, this.checkStart, this.checkEnd, this.minB,
      this.maxB, this.avgB, this.myminB, this.mymaxB, this.myavgB, this.Acount,
      this.avgAcount, this.minS, this.maxS, this.myminS, this.mymaxS, this.rdi);
/*
  Map<String, dynamic>toMap(){
    return {
      'id': id,
      'mac': mac,
      'date': date,
      'checkStart': checkStart,
      'checkEnd': checkEnd,
      'minB' : minB,
      'maxB': maxB,
      'avgB' : avgB,
      'myminB': myminB,
      'mymaxB' : mymaxB,
      'myavgB': myavgB,
      'Acount': Acount,
      'avgAcount': avgAcount,
      'minS': minS,
      'maxS': maxS,
      'myminS': myminS,
      'mymaxS': mymaxS,
      'rdi': 8
    };

  }
*/
  @override
  String toString() {
    return 'graph_data{id: $id, mac: $mac, date: $date, checkStart: $checkStart, checkEnd: $checkEnd, minB: $minB, maxB: $maxB, avgB: $avgB, myminB: $myminB, mymaxB: $mymaxB, myavgB: $myavgB, Acount: $Acount, avgAcount: $avgAcount, minS: $minS, maxS: $maxS, myminS: $myminS, mymaxS: $mymaxS, rdi: $rdi}';
  }
}

