import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String? messageID;
  String? userID;
  String? name;
  String? imagePath;
  String? recentMessage;
  String? dateTime;
  bool? isNew;
  int? unseenMessages;

  ChatModel(
      {this.messageID,
      this.userID,
      this.name,
      this.imagePath,
      this.recentMessage,
      this.dateTime,
      this.isNew,
      this.unseenMessages});

  factory ChatModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();

    return ChatModel(
        messageID: data?['messageID'],
        userID: data?['userID'],
        name: data?['name'],
        imagePath: data?['imagePath'],
        recentMessage: data?['recentMessage'],
        dateTime: data?['dateTime'],
        isNew: data?['isNew'],
        unseenMessages: data?['unseenMessages']);
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['messageID'] = messageID;
    data['userID'] = userID;
    data['name'] = name;
    data['imagePath'] = imagePath;
    data['recentMessage'] = recentMessage;
    data['dateTime'] = dateTime;
    data['isNew'] = isNew;
    data['unseenMessages'] = unseenMessages;
    return data;
  }
}
