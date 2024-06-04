import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_isell_new/controller/home_page_controller.dart';

import '../../data/model/chat_model.dart';
import '../../data/model/message_model.dart';
import '../constants/firebase_constants.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Save new user to firebase
  Future<bool> saveUser(
      {required String uid,
      required String name,
      required String email,
      required String image,
      int? phoneNumber,
      required String? deviceToken}) async {
    try {
      await firestore.collection(FirestoreCollections.users).doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'image': image,
        'deviceToken': deviceToken
      });

      return true;
    } on FirebaseException catch (e) {
      print('FirebaseException on saveUser>>>>>>>>> $e');
      return false;
    } catch (e) {
      print('Exception on saveUser>>>>>>>>> $e');
      return false;
    }
  }

  /// Update device token of user to firebase
  Future<bool> updateUserDeviceToken(
      {required String uid, required String? deviceToken}) async {
    try {
      await firestore
          .collection(FirestoreCollections.users)
          .doc(uid)
          .update({'deviceToken': deviceToken});

      return true;
    } on FirebaseException catch (e) {
      print('FirebaseException on updateUserDeviceToken>>>>>>>>> $e');
      return false;
    } catch (e) {
      print('Exception on updateUserDeviceToken>>>>>>>>> $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserByID({required String userID}) async {
    var userData = await firestore
        .collection(FirestoreCollections.users)
        .doc(userID)
        .get();

    print("userData.data()>>>>>>>>>> ${userData.data()}");
    // UserModel? userModel = await UserModel.fromMap(userData.data()!);
    //
    return userData.data();
  }

  Future<bool> saveMessage(
      {required String userID,
      required String msgUserID,
      required String msgUserName,
      required String msgUserImage,
      required bool isNewMsg,
      required MessageModel messageModel}) async {
    try {
      CollectionReference<Map<String, dynamic>> collection = firestore
          .collection(FirestoreCollections.messages)
          .doc(userID)
          .collection(msgUserID);

      var newMsgID = collection.doc();
      print('newMsgID>>>>>>>> ${newMsgID.id}');

      messageModel.messageID = newMsgID.id;
      await newMsgID.set(messageModel.toMap());
      print('Message saved successfully!');

      // Save message in users chats collection
      ChatModel chatModel = ChatModel(
        messageID: newMsgID.id,
        userID: msgUserID,
        name: msgUserName,
        imagePath: msgUserImage,
        recentMessage: messageModel.message,
        dateTime: messageModel.dateTime,
        isNew: isNewMsg,
      );

      await saveChat(
          userID: userID, msgUserID: msgUserID, chatModel: chatModel);

      return true;
    } catch (e) {
      print('Exception on Save Message>>>>>>> $e');
      return false;
    }
  }

  Stream<List<MessageModel>> getMessageStream(
      {required String currentUserID, String? msgUserID}) {
    CollectionReference<Map<String, dynamic>> collection = firestore
        .collection(FirestoreCollections.messages)
        .doc(currentUserID)
        .collection(msgUserID!);

    return collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return MessageModel.fromDocumentSnapshot(doc);
      }).toList();
    });
  }

  Future<bool> saveChat(
      {required String userID,
      required String msgUserID,
      required ChatModel chatModel}) async {
    try {
      CollectionReference<Map<String, dynamic>> collection = firestore
          .collection(FirestoreCollections.users)
          .doc(userID)
          .collection(FirestoreCollections.chats);

      await collection.doc(msgUserID).set(chatModel.toMap());
      print('Chat saved successfully!');

      return true;
    } catch (e) {
      print('Exception on Save Chat>>>>>>> $e');
      return false;
    }
  }

  Future<bool> updateChat(
      {required String userID, required String msgUserID}) async {
    try {
      CollectionReference<Map<String, dynamic>> collection = firestore
          .collection(FirestoreCollections.users)
          .doc(userID)
          .collection(FirestoreCollections.chats);

      await collection.doc(msgUserID).update({"isNew": false});
      print('Chat updated successfully!');

      return true;
    } catch (e) {
      print('Exception on update Chat>>>>>>> $e');
      return false;
    }
  }

  Stream<List<ChatModel>> getChatsStream() {
    CollectionReference<Map<String, dynamic>> collection = firestore
        .collection(FirestoreCollections.users)
        .doc(myServices.sharedPreferences.getInt('id').toString())
        .collection(FirestoreCollections.chats);

    return collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ChatModel.fromDocumentSnapshot(doc);
      }).toList();
    });
  }
}
