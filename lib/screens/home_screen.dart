import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:whisper/enum/user_state.dart';
import 'package:whisper/provider/user_provider.dart';
import 'package:whisper/resources/firebase_repository.dart';
import 'package:whisper/resources/local_db/repository/log_repository.dart';
import 'package:whisper/screens/callscreens/pickup/pickup_layout.dart';
import 'package:whisper/screens/pageviews/chat_list_screen.dart';
import 'package:whisper/utils/universal_constants.dart';

import 'pageviews/logs/log_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  PageController _pageController;
  int _pageIndex = 0;
  UserProvider userProvider;
  FirebaseRepository _firebaseRepository = FirebaseRepository();

  @override
  void initState() {
    super.initState();
    //since the initstate is called before any frames are rendered,
    //the framework will throw an error if we use provider directly
    //because there is no context during initstate call,
    //so we have to use addPostFrameCallback with SchedulerBinding...
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUser();
      _firebaseRepository.setUserState(
          userId: userProvider.getUser.uid, userState: UserState.Online);

      LogRepository.init(isHive: false, dbName: userProvider.getUser.uid);
    });
    _pageController = PageController();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String currentUserId =
        (userProvider != null && userProvider.getUser != null)
            ? userProvider.getUser.uid
            : '';

    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? _firebaseRepository.setUserState(
                userId: currentUserId, userState: UserState.Online)
            : print('resumed state');
        break;
      case AppLifecycleState.inactive:
        currentUserId != null
            ? _firebaseRepository.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print('detached state');
        break;
      case AppLifecycleState.paused:
        currentUserId != null
            ? _firebaseRepository.setUserState(
                userId: currentUserId, userState: UserState.Waiting)
            : print('paused state');
        break;
      case AppLifecycleState.detached:
        currentUserId != null
            ? _firebaseRepository.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print('detached state');
        break;
    }
  }

  onPageChanged(int page) {
    setState(() {
      _pageIndex = page;
    });
  }

  navigationtapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        body: PageView(
          // physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: <Widget>[
            ChatListScreen(),
            LogScreen(),
            Center(
              child: Text(
                'Contact Page',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: 60.0,
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: CupertinoTabBar(
              activeColor: Theme.of(context).primaryColor,
              inactiveColor: Colors.grey,
              backgroundColor: UniversalVariables.blackColor,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat,
                    size: 28,
                  ),
                  title: Text(
                    'Chats',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.call,
                    size: 28,
                  ),
                  title: Text(
                    'Calls',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    FontAwesomeIcons.addressBook,
                    size: 25,
                  ),
                  title: Text(
                    'Contacts',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              onTap: navigationtapped,
              currentIndex: _pageIndex,
            ),
          ),
        ),
      ),
    );
  }
}
