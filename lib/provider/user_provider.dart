import 'package:flutter/widgets.dart';
import 'package:whisper/models/user.dart';
import 'package:whisper/resources/firebase_repository.dart';

class UserProvider with ChangeNotifier {
  User _user;
  FirebaseRepository _firebaseRepository = FirebaseRepository();
  User get getUser => _user;

  Future<void> refreshUser() async {
    User user = await _firebaseRepository.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
