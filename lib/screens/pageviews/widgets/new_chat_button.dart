import 'package:flutter/material.dart';
import 'package:whisper/utils/universal_constants.dart';

class NewChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        gradient: UniversalVariables.fabGradient,
        // color: Colors.blue,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.edit,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}
