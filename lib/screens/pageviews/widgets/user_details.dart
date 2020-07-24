import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whisper/enum/user_state.dart';
import 'package:whisper/models/user.dart';
import 'package:whisper/provider/user_provider.dart';
import 'package:whisper/resources/firebase_repository.dart';
import 'package:whisper/screens/login_screen.dart';
import 'package:whisper/screens/pageviews/widgets/online_dot_indicator.dart';
import 'package:whisper/screens/pageviews/widgets/shimmering_logo.dart';
import 'package:whisper/utils/universal_constants.dart';
import 'package:whisper/widgets/appbar.dart';

class UserDetailsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseRepository firebaseRepository = FirebaseRepository();
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    signOut() async {
      firebaseRepository.setUserState(
          userId: userProvider.getUser.uid, userState: UserState.Offline);
      final bool isLoggedOut = await FirebaseRepository().signOut();

      if (isLoggedOut) {
        // This navigates to the new screen and removes all the previously pushed ones
        // Useful while logging out
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false);
      }
    }

    logoutAlert(Function func) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(20.0),
            ),
            backgroundColor: UniversalVariables.blackColor,
            elevation: 5,
            title: Text(
              'Logout',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            content: Text(
              'Are you sure?',
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: func,
                child: Text(
                  'Yes',
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
              ),
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'No',
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
              )
            ],
          );
        },
      );
    }

    return Container(
      margin: EdgeInsets.only(top: 25),
      child: Column(
        children: <Widget>[
          CustomAppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.maybePop(context),
            ),
            centerTitle: true,
            title: ShimmeringLogo(),
            actions: <Widget>[
              GestureDetector(
                onTap: () => logoutAlert(signOut),
                child: Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      color: UniversalVariables.senderColor),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Sign Out',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          UserDetailsBody(),
        ],
      ),
    );
  }
}

class UserDetailsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final User user = userProvider.getUser;
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: UniversalVariables.separatorColor,
            ),
            child: Stack(
              children: <Widget>[
                Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: UniversalVariables.separatorColor,
                      backgroundImage:
                          CachedNetworkImageProvider(user.userPhoto),
                    )),
                Align(
                  alignment: Alignment.bottomRight,
                  heightFactor: 5,
                  child: Container(
                    height: 15,
                    width: 15,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: UniversalVariables.blackColor,
                          width: 2.0,
                        ),
                        color: UniversalVariables.onlineDotColor),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user.name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                user.email,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
