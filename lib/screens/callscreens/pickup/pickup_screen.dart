import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whisper/models/call.dart';
import 'package:whisper/resources/call_methods.dart';
import 'package:whisper/screens/callscreens/call_screen.dart';
import 'package:whisper/utils/permissions.dart';
import 'package:whisper/utils/universal_constants.dart';

class PickupScreen extends StatelessWidget {
  final Call call;
  final CallMethods callMethods = CallMethods();

  PickupScreen({@required this.call});
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
                        image: CachedNetworkImageProvider(call.callerPic))),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              call.callerName,
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
                  onPressed: () => callMethods.endCall(call: call),
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
                  onPressed: () async =>
                      await Permissions.cameraAndMicrophonePermissionsGranted()
                          ? Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                              return CallScreen(call: call);
                            }))
                          : {},
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
