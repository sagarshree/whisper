import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/enum/view_state.dart';
import 'package:whisper/models/message.dart';
import 'package:whisper/models/user.dart';
import 'package:whisper/provider/image_upload_provider.dart';
import 'package:whisper/resources/call_methods.dart';
import 'package:whisper/resources/firebase_repository.dart';
import 'package:whisper/screens/callscreens/pickup/pickup_layout.dart';
import 'package:whisper/screens/callscreens/pickup/pickup_screen.dart';
import 'package:whisper/screens/chatscreens/widgets/cached_image.dart';
import 'package:whisper/utils/call_utilities.dart';
import 'package:whisper/utils/permissions.dart';
import 'package:whisper/utils/universal_constants.dart';
import 'package:whisper/utils/utils.dart';
import 'package:whisper/widgets/appbar.dart';
import 'package:whisper/widgets/custom_tile.dart';

class ChatScreen extends StatefulWidget {
  final User receiver;

  ChatScreen({this.receiver});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _controller = TextEditingController();
  FirebaseRepository _repository = FirebaseRepository();
  ScrollController _listScrollController = ScrollController();
  FocusNode _textFieldFocus = FocusNode();
  User sender;
  String _currentUserId;
  bool isWriting = false;
  bool showEmojiPicker = false;
  Color modalButtonColor = UniversalVariables.blueColor;
  ImageUploadProvider _imageUploadProvider;
  CallMethods callMethods = CallMethods();

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((user) {
      _currentUserId = user.uid;
      setState(() {
        sender = User(
          uid: user.uid,
          name: user.displayName,
          userPhoto: user.photoUrl,
        );
      });
    });
  }

  sendMessage() {
    var text = _controller.text;
    Message _message = Message(
        message: text,
        receiverId: widget.receiver.uid,
        senderId: sender.uid,
        timestamp: Timestamp.now(),
        type: 'text');
    setState(() {
      _controller.clear();
      isWriting = false;
    });
    _repository.addMessageToDb(_message, sender, widget.receiver);
  }

  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: false,
      title: Text(
        widget.receiver.name,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.videocam,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () async =>
              await Permissions.cameraAndMicrophonePermissionsGranted()
                  ? CallUtils.dial(
                      from: sender,
                      to: widget.receiver,
                      context: context,
                    )
                  : {},
        ),
        IconButton(
          icon: Icon(
            Icons.phone,
            color: Colors.white,
          ),
          onPressed: () {},
        )
      ],
    );
  }

  addMediaModel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: UniversalVariables.blackColor,
      builder: (context) {
        return Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                children: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Content and Tools',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Flexible(
              child: ListView(
                children: <Widget>[
                  ModalTile(
                    title: 'Photo',
                    subTitle: 'Share',
                    icon: Icons.image,
                    onTap: () {
                      pickImage(source: ImageSource.gallery);
                      Navigator.pop(context);
                    },
                  ),
                  ModalTile(
                    title: 'File',
                    subTitle: 'Share Files',
                    icon: FontAwesomeIcons.file,
                  ),
                  ModalTile(
                    title: 'Contacts',
                    subTitle: 'Share Contacts',
                    icon: FontAwesomeIcons.addressBook,
                  ),
                  ModalTile(
                    title: 'Location',
                    subTitle: 'Share Location',
                    icon: Icons.location_on,
                  ),
                  ModalTile(
                    title: 'Schedule Call',
                    subTitle: 'Arrange a whisper call and get remainders',
                    icon: Icons.schedule,
                  ),
                  ModalTile(
                    title: 'Create Poll',
                    subTitle: 'Share polls',
                    icon: Icons.poll,
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget chatControls() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => addMediaModel(context),
            child: Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(right: 7),
              decoration: BoxDecoration(
                color: modalButtonColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                size: 28,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Stack(children: [
              TextField(
                focusNode: _textFieldFocus,
                controller: _controller,
                style: TextStyle(
                  color: Colors.white,
                ),
                onChanged: (val) {
                  if (val.length > 0 && val.trim() != '') {
                    setState(() {
                      isWriting = true;
                    });
                  } else {
                    setState(() {
                      isWriting = false;
                    });
                  }
                },
                onTap: () => setState(() {
                  showEmojiPicker = false;
                }),
                decoration: InputDecoration(
                  hintText: 'Write Message',
                  hintStyle: TextStyle(
                    color: UniversalVariables.greyColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  filled: true,
                  fillColor: UniversalVariables.separatorColor,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    if (showEmojiPicker) {
                      hideEmojiContainer();
                      showKeyBoard();
                    } else {
                      showEmojiContainer();
                      hideKeyboard();
                    }
                  },
                  icon: Icon(
                    FontAwesomeIcons.smile,
                    color: UniversalVariables.greyColor,
                  ),
                ),
              ),
            ]),
          ),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    FontAwesomeIcons.microphone,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
          isWriting
              ? Container()
              : GestureDetector(
                  onTap: () => pickImage(source: ImageSource.camera),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
          isWriting
              ? GestureDetector(
                  onTap: sendMessage,
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: UniversalVariables.fabGradient,
                      // color: UniversalVariables.gradientColorEnd,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.send,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  pickImage({@required ImageSource source}) async {
    File selectedImage = await Utils.pickImage(source: source);
    _repository.uploadImage(
      image: selectedImage,
      receiverId: widget.receiver.uid,
      senderId: _currentUserId,
      imageUploadProvider: _imageUploadProvider,
    );
  }

  Widget senderLayout(Message message) {
    Radius messageRadius = Radius.circular(10);
    return Container(
      margin: EdgeInsets.only(top: 0),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      decoration: message.type != kPhotoMessageType
          ? BoxDecoration(
              color: UniversalVariables.senderColor,
              borderRadius: BorderRadius.only(
                topLeft: messageRadius,
                topRight: messageRadius,
                bottomLeft: messageRadius,
              ),
            )
          : null,
      child: Padding(
        padding: message.type != kPhotoMessageType
            ? EdgeInsets.all(10)
            : EdgeInsets.all(0),
        child: getMessage(message),
      ),
    );
  }

  getMessage(Message message) {
    return message.type != kPhotoMessageType
        ? Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Text(
              message.message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          )
        : CachedImage(url: message.photoUrl);
  }

  Widget receiverLayout(Message message) {
    Radius messageRadius = Radius.circular(10);
    return Container(
      margin: EdgeInsets.only(top: 0),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      decoration: message.type != kPhotoMessageType
          ? BoxDecoration(
              color: UniversalVariables.gradientColorStart,
              borderRadius: BorderRadius.only(
                bottomRight: messageRadius,
                topRight: messageRadius,
                bottomLeft: messageRadius,
              ),
            )
          : null,
      child: Padding(
        padding: message.type != kPhotoMessageType
            ? EdgeInsets.all(10)
            : EdgeInsets.all(0),
        child: getMessage(message),
      ),
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    Message _message = Message.fromMap(snapshot.data);
    return Container(
      alignment: _message.senderId == _currentUserId
          ? Alignment.centerRight
          : Alignment.centerLeft,
      margin: EdgeInsets.symmetric(vertical: 2),
      child: Container(
        child: _message.senderId == _currentUserId
            ? senderLayout(_message)
            : receiverLayout(_message),
      ),
    );
  }

  Widget messageList() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection(kMessagesCollection)
          .document(_currentUserId)
          .collection(widget.receiver.uid)
          .orderBy(kTimestampField, descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        //scroll to bottom when new message comes
        // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        //   _listScrollController.animateTo(
        //     _listScrollController.position.minScrollExtent,
        //     duration: Duration(milliseconds: 250),
        //     curve: Curves.easeInOut,
        //   );
        // });
        return ListView.builder(
          controller: _listScrollController,
          padding: EdgeInsets.all(10),
          shrinkWrap: true,
          reverse: true,
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            return chatMessageItem(snapshot.data.documents[index]);
          },
        );
      },
    );
  }

  emojiContainer() {
    return EmojiPicker(
      bgColor: UniversalVariables.separatorColor,
      indicatorColor: UniversalVariables.blueColor,
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji, category) {
        setState(() {
          isWriting = true;
        });
        _controller.text = _controller.text + emoji.emoji;
      },
      recommendKeywords: ['love', 'angry', 'laugh', 'happy', 'party'],
      numRecommended: 50,
    );
  }

  showKeyBoard() {
    _textFieldFocus.requestFocus();
  }

  hideKeyboard() {
    _textFieldFocus.unfocus();
  }

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: customAppBar(context),
        body: Column(
          children: <Widget>[
            Expanded(
              child: messageList(),
            ),
            _imageUploadProvider.getViewState == ViewState.LOADING
                ? Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(right: 15),
                    child: CircularProgressIndicator(),
                  )
                : Container(),
            chatControls(),
            showEmojiPicker
                ? Container(
                    child: emojiContainer(),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final Function onTap;

  const ModalTile({
    @required this.title,
    @required this.subTitle,
    @required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        mini: false,
        onTap: onTap,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: UniversalVariables.receiverColor,
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: UniversalVariables.greyColor,
            size: 38,
          ),
        ),
        subTitle: Text(
          subTitle,
          style: TextStyle(
            color: UniversalVariables.greyColor,
            fontSize: 14,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
