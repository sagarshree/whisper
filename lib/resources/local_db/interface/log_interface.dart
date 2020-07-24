import 'package:whisper/models/log.dart';

abstract class LogInterface {
  init();
  addlogs(Log log);

  // returns list of logs
  Future<List<Log>> getLogs();

  deleteLog(int logId);

  close();
}
