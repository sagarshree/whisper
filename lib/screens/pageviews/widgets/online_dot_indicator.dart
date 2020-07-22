import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whisper/enum/user_state.dart';
import 'package:whisper/models/user.dart';
import 'package:whisper/resources/firebase_repository.dart';
import 'package:whisper/utils/utils.dart';

class OnlineDotIndicator extends StatelessWidget {
  final String uid;
  final FirebaseRepository _firebaseRepository = FirebaseRepository();

  OnlineDotIndicator({@required this.uid});
  @override
  Widget build(BuildContext context) {
    Color getColor(int userState) {
      switch (Utils.numToState(userState)) {
        case UserState.Online:
          return Colors.green;

        case UserState.Offline:
          return Colors.red;

        default:
          return Colors.orange;
      }
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: _firebaseRepository.getUserStateStream(uid: uid),
      builder: (context, snapshot) {
        User user;
        if (snapshot.hasData && snapshot.data.data != null) {
          user = User.fromMap(snapshot.data.data);
        }

        return Align(
          alignment: Alignment.bottomRight,
          child: Container(
            height: 10,
            width: 10,
            margin: EdgeInsets.only(right: 8, top: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: getColor(user?.state),
            ),
          ),
        );
      },
    );
  }
}
