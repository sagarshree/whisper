import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:whisper/models/call.dart';
import 'package:whisper/provider/user_provider.dart';
import 'package:whisper/resources/call_methods.dart';

class CallScreen extends StatefulWidget {
  final Call call;

  CallScreen({@required this.call});
  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final CallMethods callMethods = CallMethods();
  UserProvider userProvider;
  StreamSubscription callStreamSubscription;

  @override
  void initState() {
    super.initState();
    addPostFrameCallback();
  }

  addPostFrameCallback() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      userProvider = Provider.of<UserProvider>(context, listen: false);

      callStreamSubscription = callMethods
          .callStream(uid: userProvider.getUser.uid)
          .listen((DocumentSnapshot ds) {
        //defining the logic
        switch (ds.data) {
          case null:
            // snapshot is null means the call is hung and the docs are deleted;
            Navigator.pop(context);
            break;

          default:
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    callStreamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Call has been made',
            ),
            MaterialButton(
              color: Colors.red,
              onPressed: () {
                callMethods.endCall(call: widget.call);
              },
              child: Icon(
                Icons.call_end,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
