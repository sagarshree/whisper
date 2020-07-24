import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whisper/models/log.dart';
import 'package:whisper/resources/local_db/interface/log_interface.dart';

class HiveMethods implements LogInterface {
  String hiveBox = 'call_logs';

  @override
  init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  @override
  addlogs(Log log) async {
    var box = await Hive.openBox(hiveBox);

    var logMap = log.toMap(log);

    // this adds data to database with custom key
    // await box.put('custom Key', logMap);

    //this gives key 0 for the first element and increases by 1 for next item
    int idOfInput = await box.add(logMap);
    close();
    return idOfInput;
  }

  @override
  Future<List<Log>> getLogs() async {
    var box = await Hive.openBox(hiveBox);
    List<Log> logList = [];

    for (int i = 0; i < box.length; i++) {
      var logMap = box.get(i);
      logList.add(Log.fromMap(logMap));
    }
    close();
    return logList;
  }

  updateLogs(int id, Log newLog) async {
    var box = await Hive.openBox(hiveBox);

    Map newLogMap = newLog.toMap(newLog);

    box.put(id, newLogMap);
    close();
  }

  @override
  deleteLog(int logId) async {
    var box = await Hive.openBox(hiveBox);
    await box.deleteAt(logId);
    close();
  }

  @override
  close() => Hive.close();
}
