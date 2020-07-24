import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whisper/enum/user_state.dart';
import 'package:whisper/models/message.dart';
import 'package:whisper/models/user.dart';
import 'package:whisper/provider/image_upload_provider.dart';
import 'package:whisper/resources/firebase_methods.dart';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  Future<FirebaseUser> getCurrentUser() => _firebaseMethods.getCurrentUser();

  Future<FirebaseUser> signIn() => _firebaseMethods.signIn();

  Future<bool> authenticateUser(FirebaseUser user) =>
      _firebaseMethods.authenticateUser(user);

  Future<void> addUserToDb(FirebaseUser currentUser) =>
      _firebaseMethods.addUserToDb(currentUser);

  Future<bool> signOut() async {
    return _firebaseMethods.signOut();
  }

  Future<List<User>> fetchAllUsers(FirebaseUser currentUser) =>
      _firebaseMethods.fetchAllUsers(currentUser);

  Future<void> addMessageToDb(Message message, User sender, User receiver) =>
      _firebaseMethods.addMessageToDb(message, sender, receiver);

  Future<User> getUserDetails() => _firebaseMethods.getUserDetails();

  void uploadImage({
    @required File image,
    @required String senderId,
    @required String receiverId,
    @required ImageUploadProvider imageUploadProvider,
  }) =>
      _firebaseMethods.uploadImage(
        image,
        senderId,
        receiverId,
        imageUploadProvider,
      );

  Stream<QuerySnapshot> fetchContactsStream({String userId}) =>
      _firebaseMethods.fetchcontactsStream(userId: userId);

  Stream<QuerySnapshot> fetchLastMessageStream(
          {String senderId, String receiverId}) =>
      _firebaseMethods.fetchLastMessageStream(
          senderId: senderId, receiverId: receiverId);

  Future<User> getUserDetilsById({String id}) =>
      _firebaseMethods.getUserDetilsById(id: id);

  void setUserState({@required String userId, @required UserState userState}) =>
      _firebaseMethods.setUserState(userId: userId, userState: userState);

  Stream<DocumentSnapshot> getUserStateStream({@required String uid}) =>
      _firebaseMethods.getUserStateStream(uid: uid);
}
