import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:whisper/resources/firebase_repository.dart';
import 'package:whisper/screens/home_screen.dart';
import 'package:whisper/utilities/universal_constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseRepository _firebaseRepository = FirebaseRepository();
  bool isLOginPressed = false;

  authenticateUser(FirebaseUser user) async {
    final isAlreadyLogged = await _firebaseRepository.authenticateUser(user);
    setState(() {
      isLOginPressed = false;
    });
    if (!isAlreadyLogged) {
      await _firebaseRepository.addUserToDb(user);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomeScreen();
      }));
      print('new user!!');
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomeScreen();
      }));
      print('already loggged in!!');
    }
  }

  performLogin() async {
    setState(() {
      isLOginPressed = true;
    });
    final FirebaseUser user = await _firebaseRepository.signIn();
    if (user != null) {
      authenticateUser(user);
    } else {
      print('There was error signing in');
    }
  }

  Widget loginButton() {
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: UniversalVariables.senderColor,
      child: Stack(children: [
        FlatButton(
          onPressed: performLogin,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(35),
          child: Center(
            child: Text(
              'LOGIN',
              style: TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
        isLOginPressed
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: loginButton(),
    );
  }
}
