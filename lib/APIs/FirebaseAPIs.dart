import 'dart:io';
import 'package:chit_chat_app/APIs/PushNotification.dart';
import 'package:chit_chat_app/models/chat_user.dart';
import 'package:chit_chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  //for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //for firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  //for checking if user exists
  static Future<bool> userExist() async {
    return (await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get())
        .exists;
  }

  // for storing self information
  static late ChatUser currUser;

  // for getting current user info
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(auth.currentUser!.uid).get().then(
          (user) async {
        if (user.exists) {
          currUser = ChatUser.fromJson(user.data()!);
          await getFirebaseMessagingToken();
          APIs.UpdateActiveStatus(true);
        } else {
          await createUser().then(
                (value) => getSelfInfo(),
          );
        }
      },
    );
  }

//   for creating new user
  static Future<void> createUser() async {
    final time = DateTime
        .now()
        .microsecondsSinceEpoch
        .toString();
    final Chatuser = ChatUser(
        createdAt: time,
        about: "Hey, Lets ChitChat",
        id: auth.currentUser!.uid,
        image: auth.currentUser!.photoURL.toString(),
        name: auth.currentUser!.displayName.toString(),
        lastActive: "",
        isOnline: auth.currentUser!.isAnonymous,
        email: auth.currentUser!.email.toString(),
        pushToken: '');
    return await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .set(Chatuser.toJson());
  }

  // getting Allusers from firestore exept current user
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: auth.currentUser!.uid)
        .snapshots();
  }

  //update profile
  static Future<void> updateUserInfo() async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'name': currUser.name, 'about': currUser.about});
  }

  //update profile picture
  static var progress;

  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path
        .split('.')
        .last;
    final ref =
    storage.ref().child('Profile_Pictures/ ${auth.currentUser!.uid}.$ext');
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then(
          (p0) {
        progress = p0.bytesTransferred.toDouble() /
            p0.totalBytes.toDouble().roundToDouble().toInt();
      },
    );
    currUser.image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'image': currUser.image});
  }

  //show online status
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserUpdateInfo(
      ChatUser user) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: user.id)
        .snapshots();
  }

  //update online and lastseen
  static Future<void> UpdateActiveStatus(bool _isOnline) async {
    firestore.collection('users').doc(auth.currentUser!.uid).update({
      'is_online': _isOnline,
      'last_active': DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
      'push_token': currUser.pushToken,
    });
  }

  ////chat screen related APIs
  static String getConversationID(String id) =>
      auth.currentUser!.uid.hashCode <= id.hashCode
          ? '${auth.currentUser!.uid}_$id'
          : '${id}_${auth.currentUser!.uid}';

  //getting all message
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  //for sending message
  static Future<void> sendMessage(ChatUser user, String msg, Type type) async {
    final time = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();

    //message
    final Message message = Message(
        fromID: auth.currentUser!.uid,
        toID: user.id,
        msg: msg,
        read: '',
        sent: time,
        type: type);

    final ref =
    firestore.collection('chats/${getConversationID(user.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

//message read status
  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.fromID)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime
        .now()
        .millisecondsSinceEpoch
        .toString()});
  }

  //get last message of user
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

//send chat Image
  static Future<void> sendChatImage(ChatUser user, File file) async {
    final ext = file.path
        .split('.')
        .last;
    final ref = storage.ref().child(
        'images/ ${getConversationID(user.id)}/${DateTime
            .now()
            .millisecondsSinceEpoch}.$ext');
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then(
          (p0) {
        progress = p0.bytesTransferred.toDouble() /
            p0.totalBytes.toDouble().roundToDouble().toInt();
      },
    );
    final ImageUrl = await ref.getDownloadURL();
    await sendMessage(user, ImageUrl, Type.image);
  }


  //for push notifications
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();
    await fMessaging.getToken().then((value) {
      if (value != null) {
        value = currUser.pushToken;
        print(value);
      }
    },);
  }


//for deleting Message
  static Future<void> deleteMessage(Message message) async {
    await firestore
        .collection('chats/${getConversationID(message.toID)}/messages/')
        .doc(message.sent)
        .delete();
    if (message.type == Type.image) {
      await storage.refFromURL(message.msg).delete();
    }
  }

  static GetServiceKey getServiceKey = GetServiceKey();
  String accessToken = getServiceKey.getServerKeyToken() as String;


}
