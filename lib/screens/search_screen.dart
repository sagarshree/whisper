import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:whisper/models/user.dart';
import 'package:whisper/resources/firebase_repository.dart';
import 'package:whisper/screens/callscreens/pickup/pickup_layout.dart';
import 'package:whisper/screens/chatscreens/chat_screen.dart';
import 'package:whisper/utils/universal_constants.dart';
import 'package:whisper/widgets/custom_tile.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  FirebaseRepository _repository = FirebaseRepository();

  List<User> userList;
  String query = '';
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((FirebaseUser currentUser) => {
          _repository.fetchAllUsers(currentUser).then((List<User> list) {
            setState(() {
              userList = list;
            });
          })
        });
    print(userList);
  }

  searchAppbar(BuildContext context) {
    return GradientAppBar(
      gradient: LinearGradient(
        colors: [
          UniversalVariables.gradientColorStart,
          UniversalVariables.gradientColorEnd
        ],
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0.0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: _textEditingController,
            onChanged: (val) {
              setState(() {
                query = val;
              });
            },
            cursorColor: UniversalVariables.blackColor,
            autofocus: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 35,
            ),
            decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _textEditingController.clear();
                    }),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: 'Search',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  color: Color(0x88ffffff),
                )),
          ),
        ),
      ),
    );
  }

  buildSuggestions(String query) {
    final List<User> suggestionList = query.isEmpty
        ? []
        : userList.where((User user) {
            String _getUsername = user.username.toLowerCase();
            String _query = query.toLowerCase();
            String _getName = user.name.toLowerCase();
            bool _matchesUsername = _getUsername.contains(_query);
            bool _matchesName = _getName.contains(_query);

            return (_matchesUsername || _matchesName);
          }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        User searchedUser = User(
          uid: suggestionList[index].uid,
          userPhoto: suggestionList[index].userPhoto,
          name: suggestionList[index].name,
          username: suggestionList[index].username,
        );
        return CustomTile(
          mini: false,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ChatScreen(receiver: searchedUser);
                },
              ),
            );
          },
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(searchedUser.userPhoto),
            backgroundColor: Colors.grey,
          ),
          title: Text(
            searchedUser.username,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subTitle: Text(
            searchedUser.name,
            style: TextStyle(
              color: UniversalVariables.greyColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: searchAppbar(context),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: buildSuggestions(query),
        ),
      ),
    );
  }
}
