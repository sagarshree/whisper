import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/models/call.dart';
import 'package:whisper/models/log.dart';
import 'package:whisper/models/user.dart';
import 'package:whisper/resources/call_methods.dart';
import 'package:whisper/resources/local_db/repository/log_repository.dart';
import 'package:whisper/screens/callscreens/call_screen.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({
    User from,
    User to,
    context,
  }) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.userPhoto,
      receiverId: to.uid,
      receiverName: to.userPhoto,
      receiverPic: to.userPhoto,
      channelId: Random().nextInt(1000).toString(),
    );
    Log log = Log(
      callerName: from.name,
      callerPic: from.userPhoto,
      callStatus: kCallStatusDialled,
      receiverName: to.name,
      receiverPic: to.userPhoto,
      timestamp: DateTime.now().toString(),
    );
    print('from is: ${from.uid}');
    print(' to is : ${to.uid}');
    bool callMade = await callMethods.makeCall(call: call);
    call.hasDialled = true;

    if (callMade) {
      // adds call log to the local database
      LogRepository.addLogs(log);
      print('Call has ben made');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(call: call),
        ),
      );
    }
  }
}
