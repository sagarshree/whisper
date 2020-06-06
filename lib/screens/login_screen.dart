import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whisper/resources/firebase_repository.dart';
import 'package:whisper/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseRepository _firebaseRepository = FirebaseRepository();

  authenticateUser(FirebaseUser user) async {
    final isAlreadyLogged = await _firebaseRepository.authenticateUser(user);
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
    final FirebaseUser user = await _firebaseRepository.signIn();
    if (user != null) {
      authenticateUser(user);
    } else {
      print('There was error signing in');
    }
  }

  loginButton() {
    return FlatButton(
      onPressed: performLogin,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loginButton(),
    );
  }
}
