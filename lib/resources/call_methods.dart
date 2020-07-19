import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/models/call.dart';

class CallMethods {
  final CollectionReference callCollection =
      Firestore.instance.collection(kCallCollection);

  Stream<DocumentSnapshot> callStream({String uid}) =>
      callCollection.document(uid).snapshots();

  Future<bool> makeCall({Call call}) async {
    try {
      print('makecall initiated');
      call.hasDialled = true;
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      call.hasDialled = false;
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);
      // print('hyaa samma thik xa');
      // print('caller id: ${call.callerId}');
      // print('receiver id: ${call.receiverId}');
      // print('dial details: $hasDialledMap');
      // print('call details: ${call.callerPic}');

      await callCollection.document(call.callerId).setData(hasDialledMap);
      await callCollection.document(call.receiverId).setData(hasNotDialledMap);

      return true;
    } catch (e) {
      print('make call error is: $e');
      return false;
    }
  }

  Future<bool> endCall({Call call}) async {
    try {
      await callCollection.document(call.callerId).delete();
      await callCollection.document(call.receiverId).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
