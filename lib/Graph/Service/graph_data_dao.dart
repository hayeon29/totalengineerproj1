import 'package:smart_alarm/Graph/Model/graph_data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class GraphDataDao {
  final String tableName = "GraphData";
  final String id = "id";
  final String mac = "mac";
  final String date = "date";
  final String checkStart = "checkStart";
  final String checkEnd = "checkEnd";
  final String minB = "minB";
  final String maxB = "maxB";
  final String avgB = "avgB";
  final String myminB = "myminB";
  final String mymaxB = "mymaxB";
  final String myavgB = "myavgB";
  final String Acount = "Acount";
  final String avgAcount = "avgAcount";
  final String minS = "minS";
  final String maxS = "maxS";
  final String myminS = "myminsS";
  final String mymaxS = "mymaxS";
  final String rdi = "rid";

  var _db;

  Future<Database> get database async {
    if (_db != null ) return _db;
    _db = openDatabase(
      // DB경로 지정 path, join을 사용하는 것이 각 플랫폼별로 경로생성을 보장하는 가장 좋은 방법.
        join(await getDatabasesPath(), 'GraphData.db'),
        onCreate: (db, version) {
          return db.execute(
              "CREATE TABLE IF NOT EXISTS $GraphData"
                  "(id INTEGER PRIMARY KEY, mac TEXT, date TEXT, "
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

  Future<GraphData?> getDataByDate(String date) async {
    Database db = await database;

    List<Map<String, dynamic>> results = await db.query(
        tableName,
        where: "${this.date} LIKE '$date'",
        limit: 1
    );
    if (results == null || results.length == 0) {
      return null;
    } else {
      var result = results[0];
      return getDataFromRaw(result);
    }
  }

  GraphData getDataFromRaw(Map<String, dynamic> result) {
    return GraphData(
        result[id],
        result[mac],
        result[date],
        result[checkStart],
        result[checkEnd],
        result[minB],
        result[maxB],
        result[avgB],
        result[myminB],
        result[mymaxB],
        result[myavgB],
        result[Acount],
        result[avgAcount],
        result[minS],
        result[maxS],
        result[myminS],
        result[mymaxS],
        result[rdi],
    );
  }

}