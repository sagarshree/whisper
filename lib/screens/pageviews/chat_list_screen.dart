import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:whisper/models/contacts.dart';
import 'package:whisper/provider/user_provider.dart';
import 'package:whisper/resources/firebase_repository.dart';
import 'package:whisper/screens/pageviews/widgets/contact_view.dart';
import 'package:whisper/screens/pageviews/widgets/main_app_bar.dart';
import 'package:whisper/screens/pageviews/widgets/quiet_box.dart';
import 'package:whisper/utils/universal_constants.dart';
import 'package:whisper/utils/utils.dart';
import 'package:whisper/widgets/appbar.dart';
import 'package:whisper/widgets/custom_tile.dart';

import 'widgets/new_chat_button.dart';
import 'widgets/user_circle.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: MainAppBar(
        title: UserCircle(),
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
      ),
      floatingActionButton: NewChatButton(),
      body: ChatListContainer(),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  final FirebaseRepository _firebaseRepository = FirebaseRepository();
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final uid = userProvider.getUser.uid;

    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: _firebaseRepository.fetchContactsStream(userId: uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docList = snapshot.data.documents;

              if (docList.isEmpty) {
                return QuietBox(
                  title: 'This is where all the contacts are listed',
                  subtitle:
                      'Search for your friends and family members to get connected with them',
                );
              }
              return ListView.builder(
                itemBuilder: (context, index) {
                  Contact contact = Contact.fromMap(docList[index].data);
                  print('doclist: ${docList[0].data}');
                  print('Contact details: ${contact.uid}');
                  return ContactView(
                    contact: contact,
                  );
                },
                padding: EdgeInsets.all(10),
                itemCount: docList.length,
              );
            }
            return Shimmer.fromColors(
              baseColor: UniversalVariables.separatorColor.withOpacity(0.7),
              highlightColor: UniversalVariables.separatorColor,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
                child: CustomTile(
                  mini: false,
                  leading: CircleAvatar(
                    maxRadius: 30,
                    backgroundColor: Colors.grey,
                  ),
                  title: Container(
                    margin: EdgeInsets.only(bottom: 5),
                    height: 15,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey,
                    ),
                  ),
                  subTitle: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    height: 12,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
