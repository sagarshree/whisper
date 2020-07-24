import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/models/call.dart';
import 'package:whisper/models/log.dart';
import 'package:whisper/resources/call_methods.dart';
import 'package:whisper/resources/local_db/repository/log_repository.dart';
import 'package:whisper/screens/callscreens/call_screen.dart';
import 'package:whisper/utils/permissions.dart';
import 'package:whisper/utils/universal_constants.dart';

class PickupScreen extends StatefulWidget {
  final Call call;

  PickupScreen({@required this.call});

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final CallMethods callMethods = CallMethods();
  bool isCallMissed = true;

  addToLocalStorage({@required String callStatus}) {
    Log log = Log(
      callerName: widget.call.callerName,
      callerPic: widget.call.callerPic,
      receiverName: widget.call.receiverName,
      receiverPic: widget.call.receiverPic,
      timestamp: DateTime.now().toString(),
      callStatus: callStatus,
    );
    LogRepository.addLogs(log);
  }

  @override
  void dispose() {
    super.dispose();
    if (isCallMissed) {
      addToLocalStorage(callStatus: kCallStatusmissed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Incomming Call...',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            SizedBox(
              height: 50,
            ),
            CircleAvatar(
              radius: 40,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image:
                            CachedNetworkImageProvider(widget.call.callerPic))),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              widget.call.callerName,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
            ),
            SizedBox(
              height: 75,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RawMaterialButton(
                  onPressed: () async {
                    isCallMissed = false;
                    addToLocalStorage(callStatus: kCallStatusReceived);
                    await callMethods.endCall(call: widget.call);
                  },
                  child: Icon(
                    Icons.call_end,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.redAccent,
                  padding: const EdgeInsets.all(15.0),
                ),
                SizedBox(
                  width: 25,
                ),
                RawMaterialButton(
                  onPressed: () async {
                    isCallMissed = false;
                    addToLocalStorage(callStatus: kCallStatusReceived);
                    await Permissions.cameraAndMicrophonePermissionsGranted()
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return CallScreen(call: widget.call);
                              },
                            ),
                          )
                        : () {};
                  },
                  child: Icon(
                    Icons.call_end,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.green,
                  padding: const EdgeInsets.all(15.0),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
