import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'graph_model.dart';

final String TableName = 'Graph';

class DBHelper {
  DBHelper._();
  static final DBHelper _db = DBHelper._();
  factory DBHelper() => _db;
  static Database? _database;

  Future<Database> get database async {
    // database가 없는 경우에 생성
    if(_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  initDB() async {
    //getApplicationDocumentsDirectory() : 적당한 위치에 경로 생성
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'GraphDB1.db');

    //openDatabase() : 경로 불러오는 함수
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE $TableName(id INTEGER PRIMARY KEY, mac TEXT, date TEXT, checkStart TEXT, checkEnd TEXT, '
              'minB INTEGER, maxB INTEGER, avgB INTEGER, myminB INTEGER, mymaxB INTEGER,'
              ' myavgB INTEGER, Acount INTEGER, avgAcount INTEGER, minS INTEGER, maxS INTEGER,'
              ' myminS INTEGER, mymaxS INTEGER, rdi INTEGER)'
        );
      },
      onUpgrade: (db, oldVersion, newVersion){}
    );
  }

  Future<List<RdiData>> getRDIData(String month) async{
    final db = await database;
    var res = await db.rawQuery('SELECT substr(date, 7, 2) AS day, rdi FROM $TableName WHERE substr(date, 5, 2) = ?', [month]);
    List<RdiData> rdiValueList = res.isNotEmpty ? res.map((c) => RdiData(date: c['day'] as String, rdiValue: c['rdi'] as int)).toList() : [];

    return rdiValueList;
  }

  //Create
  insertData(Graph graph) async {
    final db = await database;
    var res = await db.rawInsert(
        'INSERT INTO $TableName(id, mac, date, checkStart, checkEnd, '
            'minB, maxB, avgB, myminB, mymaxB, '
            'myavgB, Acount, avgAcount, minS, maxS, '
            'myminS, mymaxS, rdi) VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)',
            [graph.id, graph.mac, graph.date, graph.checkStart, graph.checkEnd,
            graph.minB, graph.maxB, graph.avgB, graph.myminB, graph.mymaxB,
            graph.myavgB, graph.Acount, graph.avgAcount, graph.minS, graph.maxS,
            graph.myminS, graph.mymaxS, graph.rdi]
    );
    return res;
  }

  //Read
  Future<Graph> getGraph(String date) async {
    final db = await database;
    var res = await db.rawQuery(
      'SELECT * FROM $TableName WHERE date = ?', [date]
    );
    return res.isNotEmpty ? Graph(id: res.first['id'] as int, mac: res.first['mac'] as String, date:res.first['date'] as String, checkStart:res.first['checkStart'] as String, checkEnd:res.first['checkEnd'] as String,
        minB: res.first['minB']as int, maxB: res.first['maxB']as int, avgB: res.first['avgB']as int, myminB: res.first['myminB']as int, mymaxB: res.first['mymaxB']as int,
        myavgB:res.first['myavgB']as int, Acount: res.first['Acount']as int, avgAcount: res.first['avgAcount']as int, minS: res.first['minS']as int, maxS: res.first['maxS']as int,
        myminS:res.first['myminS']as int, mymaxS:res.first['mymaxS']as int, rdi:res.first['rdi']as int):
        Graph(id: 0, mac: '0', date: '20211127', checkStart: '00:00:00', checkEnd: '00:00:00',
            minB: 0, maxB: 0, avgB: 0, myminB: 0, mymaxB: 0, myavgB: 0, Acount: 0, avgAcount: 0,
            minS: 0, maxS: 0, myminS: 0, mymaxS: 0, rdi: 0);
  }

  //ReadAll
  Future<List<Graph>> getAllGraphs() async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $TableName');
    List<Graph> list = res.isNotEmpty ? res.map((c) => Graph(id:c['id'] as int, mac:c['mac'] as String, date:c['date'] as String, checkStart:c['checkStart'] as String, checkEnd:c['checkEnd'] as String,
        minB: c['minB']as int, maxB: c['maxB']as int, avgB: c['avgB']as int, myminB: c['myminB']as int, mymaxB: c['mymaxB']as int,
        myavgB: c['myavgB']as int, Acount: c['Acount']as int, avgAcount: c['avgAcount']as int, minS: c['minS']as int, maxS: c['maxS']as int,
        myminS: c['myminS']as int, mymaxS:c['mymaxS']as int, rdi:c['rdi']as int)).toList() : [];

    return list;
  }

  //Find
  Future<List<Graph>> getGraphs(String date) async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $TableName WHERE date = ?', [date]);
    List<Graph> list = res.isNotEmpty ? res.map((c) => Graph(id:c['id'] as int, mac:c['mac'] as String, date:c['date'] as String, checkStart:c['checkStart'] as String, checkEnd:c['checkEnd'] as String,
        minB: c['minB']as int, maxB: c['maxB']as int, avgB: c['avgB']as int, myminB: c['myminB']as int, mymaxB: c['mymaxB']as int,
        myavgB: c['myavgB']as int, Acount: c['Acount']as int, avgAcount: c['avgAcount']as int, minS: c['minS']as int, maxS: c['maxS']as int,
        myminS: c['myminS']as int, mymaxS:c['mymaxS']as int, rdi:c['rdi']as int)).toList() : [];

    return list;
  }

  findData(String date) async {
    final db = await database;
    db.rawQuery('SELECT FROM $TableName WHERE date = ?', [date]);
  }

  //Delete All
  deleteAllDogs() async {
    final db = await database;
    db.rawDelete('DELETE FROM $TableName');
  }
}

class RdiData{
  final String? date;
  final int? rdiValue;

  RdiData({this.date, this.rdiValue});
}