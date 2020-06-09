import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/resources/firebase_repository.dart';
import 'package:whisper/utilities/universal_constants.dart';
import 'package:whisper/utilities/utils.dart';
import 'package:whisper/widgets/appbar.dart';
import 'package:whisper/widgets/custom_tile.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

//Global
FirebaseRepository _repository = FirebaseRepository();

class _ChatListScreenState extends State<ChatListScreen> {
  String currentUser;
  String initials;

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((user) {
      setState(() {
        currentUser = user.uid;
        initials = Utils.getInitials(user.displayName);
      });
    });
  }

  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.notifications,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
      title: UserCircle(text: initials),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/search_screen');
          },
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      floatingActionButton: NewChatButton(),
      body: ChatListContainer(
        currentUserId: currentUser,
      ),
    );
  }
}

class ChatListContainer extends StatefulWidget {
  final String currentUserId;
  ChatListContainer({this.currentUserId});
  @override
  _ChatListContainerState createState() => _ChatListContainerState();
}

class _ChatListContainerState extends State<ChatListContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return CustomTile(
            mini: false,
            onTap: () {},
            title: Text(
              'Sharad Neupane',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Ariel',
                fontSize: 19.0,
              ),
            ),
            subTitle: Text(
              'K xa Khabar',
              style: TextStyle(
                color: UniversalVariables.greyColor,
                fontSize: 14.0,
              ),
            ),
            leading: Container(
              constraints: BoxConstraints(
                maxHeight: 60.0,
                maxWidth: 60.0,
              ),
              child: Stack(
                children: <Widget>[
                  CircleAvatar(
                    maxRadius: 30.0,
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(
                        'https://scontent.fpkr1-1.fna.fbcdn.net/v/t1.0-9/66714650_879189135794550_4528968672043073536_o.jpg?_nc_cat=106&_nc_sid=09cbfe&_nc_ohc=sYXaf3HE-7gAX-YHiNI&_nc_ht=scontent.fpkr1-1.fna&oh=0a6d3202e2ea296c668b8dca7b419d7f&oe=5F01E3CC'),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: UniversalVariables.onlineDotColor,
                          border: Border.all(
                            color: UniversalVariables.blackColor,
                            width: 2,
                          )),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        padding: EdgeInsets.all(10),
        itemCount: 5,
      ),
    );
  }
}

class UserCircle extends StatelessWidget {
  final String text;
  UserCircle({this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: UniversalVariables.separatorColor,
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: UniversalVariables.lightBlueColor,
                fontSize: 20.0,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 13,
              width: 13,
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
    );
  }
}

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
