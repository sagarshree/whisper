import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whisper/models/contacts.dart';
import 'package:whisper/models/user.dart';
import 'package:whisper/provider/user_provider.dart';
import 'package:whisper/resources/firebase_repository.dart';
import 'package:whisper/screens/chatscreens/chat_screen.dart';
import 'package:whisper/screens/pageviews/widgets/last_message_container.dart';
import 'package:whisper/screens/pageviews/widgets/online_dot_indicator.dart';
import 'package:whisper/utils/universal_constants.dart';
import 'package:whisper/widgets/custom_tile.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final FirebaseRepository _firebaseRepository = FirebaseRepository();

  ContactView({this.contact});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: _firebaseRepository.getUserDetilsById(id: contact.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User user = snapshot.data;
            return ViewLayout(contact: user);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

class ViewLayout extends StatelessWidget {
  final User contact;
  final FirebaseRepository _firebaseRepository = FirebaseRepository();

  ViewLayout({@required this.contact});

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return CustomTile(
      mini: false,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            receiver: contact,
          ),
        ),
      ),
      title: Text(
        contact?.name ?? '...',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Ariel',
          fontSize: 19.0,
        ),
      ),
      subTitle: LastMessageContainer(
        stream: _firebaseRepository.fetchLastMessageStream(
            senderId: userProvider.getUser.uid, receiverId: contact.uid),
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
              backgroundImage: CachedNetworkImageProvider(contact.userPhoto),
            ),
            OnlineDotIndicator(uid: contact.uid),
          ],
        ),
      ),
    );
  }
}
