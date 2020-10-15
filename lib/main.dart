import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whisper/enum/user_state.dart';
import 'package:whisper/provider/image_upload_provider.dart';
import 'package:whisper/provider/user_provider.dart';
import 'package:whisper/resources/firebase_repository.dart';
import 'package:whisper/screens/home_screen.dart';
import 'package:whisper/screens/login_screen.dart';
import 'package:whisper/screens/search_screen.dart';
import 'package:whisper/utils/universal_constants.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/search_screen': (context) => SearchScreen(),
        },
        theme: ThemeData(
            primaryColor: UniversalVariables.gradientColorStart,
            appBarTheme: AppBarTheme(
              brightness: Brightness.dark,
            )
            // accentColor: Colors.white,
            ),
        debugShowCheckedModeBanner: false,
        title: 'Whisper',
        home: Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseRepository _firebaseRepository = FirebaseRepository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: _firebaseRepository.getCurrentUser(),
            builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
              if (snapshot.hasData) {
                _firebaseRepository.setUserState(
                    userId: snapshot.data.uid, userState: UserState.Online);
                print('data = ${snapshot.data}');
                return HomeScreen();
              } else {
                return LoginScreen();
              }
            }));
  }
}
