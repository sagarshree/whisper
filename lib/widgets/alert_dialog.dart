import 'package:flutter/material.dart';
import 'package:whisper/utils/universal_constants.dart';

showAlertDialog({
  @required String titleText,
  @required String contentText,
  @required String button2Text,
  @required String button1Text,
  @required Function button1Function,
  @required Function button2Function,
  @required BuildContext parentContext,
}) {
  return showDialog(
    context: parentContext,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: UniversalVariables.blackColor,
        elevation: 5,
        title: Text(
          titleText,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        content: Text(
          contentText,
          style: TextStyle(fontSize: 17, color: Colors.white),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: button1Function,
            child: Text(
              button1Text,
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),
          ),
          FlatButton(
            onPressed: button2Function,
            child: Text(
              button2Text,
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),
          )
        ],
      );
    },
  );
}
