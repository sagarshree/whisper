import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:whisper/provider/user_provider.dart';
import 'package:whisper/screens/callscreens/pickup/pickup_layout.dart';
import 'package:whisper/screens/pageviews/chat_list_screen.dart';
import 'package:whisper/utils/universal_constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;
  int _pageIndex = 0;
  UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    //since the initstate is called before any frames are rendered,
    //the framework will throw an error if we use provider directly
    //because there is no context during initstate call,
    //so we have to use addPostFrameCallback with SchedulerBinding...
    SchedulerBinding.instance.addPostFrameCallback((_) {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.refreshgUser();
    });
    _pageController = PageController();
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
            Center(
              child: Text(
                'Call Logs',
                style: TextStyle(color: Colors.white),
              ),
            ),
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
