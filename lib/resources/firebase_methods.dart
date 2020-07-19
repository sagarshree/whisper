import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/models/message.dart';
import 'package:whisper/models/user.dart';
import 'package:whisper/provider/image_upload_provider.dart';
import 'package:whisper/utils/utils.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final Firestore firestore = Firestore.instance;
  static final CollectionReference _userCollection =
      firestore.collection(kUsersCollection);
  StorageReference _storageReference;
  User user = User();

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

  Future<User> getUserDetails() async {
    FirebaseUser currentUser = await getCurrentUser();
    DocumentSnapshot documentSnapshot =
        await _userCollection.document(currentUser.uid).get();

    return User.fromMap(documentSnapshot.data);
  }

  Future<FirebaseUser> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: _signInAuthentication.idToken,
      accessToken: _signInAuthentication.accessToken,
    );
    // this is accepted in previous versions of firebaseauth
    // final FirebaseUser user = await _auth.signInWithCredential(credential);

    //This should be used in latest version
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    return user;
  }

  Future<bool> authenticateUser(FirebaseUser user) async {
    QuerySnapshot result = await firestore
        .collection(kUsersCollection)
        .where(kEmailField, isEqualTo: user.email)
        .getDocuments();

    if (result.documents.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  addUserToDb(FirebaseUser currentUser) {
    String username = Utils.getUserName(currentUser.email);
    user = User(
      uid: currentUser.uid,
      email: currentUser.email,
      name: currentUser.displayName,
      userPhoto: currentUser.photoUrl,
      username: username,
    );
    firestore
        .collection(kUsersCollection)
        .document(currentUser.uid)
        .setData(user.toMap(user));
  }

  Future<void> signOut() async {
    // await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<List<User>> fetchAllUsers(FirebaseUser currentUser) async {
    List<User> userList = List<User>();
    QuerySnapshot querySnapshot =
        await firestore.collection(kUsersCollection).getDocuments();

    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != currentUser.uid) {
        userList.add(User.fromMap(querySnapshot.documents[i].data));
      }
    }
    return userList;
  }

  Future<void> addMessageToDb(
      Message message, User sender, User receiver) async {
    var map = message.toMap();

    await firestore
        .collection(kMessagesCollection)
        .document(message.receiverId)
        .collection(message.senderId)
        .add(map);

    return await firestore
        .collection(kMessagesCollection)
        .document(message.senderId)
        .collection(message.receiverId)
        .add(map);
  }

  Future<String> uploadImageToStorage(File image) async {
    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      StorageUploadTask _storageUploadTask = _storageReference.putFile(image);
      var url =
          await (await _storageUploadTask.onComplete).ref.getDownloadURL();
      return url;
    } catch (e) {
      print(e);
      return null;
    }
  }

  setImageMsg(
    String url,
    String senderId,
    String receiverId,
  ) async {
    Message _message;
    _message = Message.imageMessage(
      message: 'IMAGE',
      senderId: senderId,
      receiverId: receiverId,
      photoUrl: url,
      timestamp: Timestamp.now(),
      type: 'image',
    );
    var map = _message.toImageMap();
    // set the data to database
    await firestore
        .collection(kMessagesCollection)
        .document(_message.receiverId)
        .collection(_message.senderId)
        .add(map);

    return await firestore
        .collection(kMessagesCollection)
        .document(_message.senderId)
        .collection(_message.receiverId)
        .add(map);
  }

  void uploadImage(File image, String senderId, String receiverId,
      ImageUploadProvider imageUploadProvider) async {
    //set loading value to db and show it to user
    imageUploadProvider.setToLoading();

    //get url from the image bucket from storage
    String url = await uploadImageToStorage(image);

    //hide loading
    imageUploadProvider.setToIdle();

    setImageMsg(url, senderId, receiverId);
  }
}
