import 'dart:async';
import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:whisper/models/log.dart';
import 'package:whisper/resources/local_db/interface/log_interface.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class SqliteMethods implements LogInterface {
  Database _db;
  String databaseName = 'LogDB';
  String tableName = 'Call_Logs';

  // columns

  String id = 'log_id';
  String callerName = 'caller_name';
  String callerPic = 'caller_pic';
  String receiverName = 'receiver_name';
  String receiverPic = 'receiver_pic';
  String callStatus = 'call_status';
  String timestamp = 'timestamp';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    print('DB was null, now creating it');
    _db = await init();
    return _db;
  }

  @override
  init() async {
    Directory dir = await getApplicationDocumentsDirectory();

    String path = join(dir.path, databaseName);

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    String createTableQuery =
        'CREATE TABLE $tableName ($id INTEGER PRIMARY KEY, $callerName TEXT, $callerPic TEXT, $receiverName TEXT, $receiverPic TEXT, $callStatus TEXT, $timestamp TEXT )';
    db.execute(createTableQuery);
    print('Table Created');
  }

  @override
  addlogs(Log log) async {
    var dbClient = await db;
    await dbClient.insert(tableName, log.toMap(log));
  }

  @override
  Future<List<Log>> getLogs() async {
    try {
      var dbClient = await db;
      // List<Map> maps = await dbClient.rawQuery('SELECT * FROM $tableName');
      List<Map> maps = await dbClient.query(
        tableName,
        columns: [
          id,
          callerName,
          callerPic,
          receiverName,
          receiverPic,
          callStatus,
          timestamp,
        ],
      );
      List<Log> logList = [];
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          logList.add(Log.fromMap(map));
        }
      }
      return logList;
    } catch (e) {
      print('Error getting data from local database: $e');
    }
  }

  updateLogs(Log log) async {
    var dbClient = await db;
    await dbClient.update(
      tableName,
      log.toMap(log),
      where: '$id = ?',
      whereArgs: [log.logId],
    );
  }

  @override
  deleteLog(int logId) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableName, where: '$id = ?', whereArgs: [logId]);
  }

  @override
  close() async {
    var dbClient = await db;
    await dbClient.close();
  }
}
