import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'Model/graph_data.dart';

final String TableName = 'Graphdata';

class DBHelper {

  var _db;

  Future<Database> get database async {
    if (_db != null ) return _db;
    _db = openDatabase(
      // DB경로 지정 path, join을 사용하는 것이 각 플랫폼별로 경로생성을 보장하는 가장 좋은 방법.
      join(await getDatabasesPath(), 'GraphData.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE GraphData(id INTEGER PRIMARY KEY, mac TEXT, date TEXT, "
              "checkStart TEXT, checkEnd TEXT, minB INTEGER, maxB INTEGER ,avgB INTEGER,"
              "myminB INTEGER, mymaxB INTEGER, myavgB INTEGER, Acount INTEGER, avgAcount INTEGER,"
              "minS INTEGER, maxS INTEGER, myminS INTEGER, mymaxS INTEGER, rdi INTEGER)"
        );
      },
      version: 1,
      onUpgrade: (db, oldVersion, newVersion){}
    );
    return _db;
  }

  //Create
  Future<void> insertData(Graph graph) async {
    final db = await database;
    await db.insert(
      TableName,
      graph.toMap(),
    );
  }

//Read
  Future<Graph>readData(int id) async {
    final db = await database;
    List<Map<String,dynamic>> res = await db.rawQuery('SELECT * FROM $TableName WHERE id = ?', [id]);
    return Graph(res.first['id'], res.first['name'], res.first['date'],
      res.first['checkStart'], res.first['checkEnd'], res.first['minB'], res.first['maxB'],
      res.first['avgB'], res.first['myminB'], res.first['mymaxB'], res.first['maavgB'],
      res.first['Acount'], res.first['avgAcount'], res.first['minS'], res.first['maxS'],
      res.first['myminsS'], res.first['mymaxS'], res.first['rdi']);
  }



  //Delete
  Future<void>deleteData(int id) async {
    final db = await database;
    await db.delete(TableName, where: "id = ?", whereArgs:[id],);
  }
}