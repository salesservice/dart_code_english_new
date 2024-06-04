import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? messageID;
  String? senderID;
  String? senderName;
  String? senderImage;
  String? receiverID;
  String? receiverName;
  String? receiverImage;
  String? message;
  String? dateTime;
  bool? isIncoming;
  bool? isSeen;

  MessageModel({
    this.messageID,
    this.senderID,
    this.senderName,
    this.senderImage,
    this.receiverID,
    this.receiverName,
    this.receiverImage,
    this.message,
    this.dateTime,
    this.isIncoming,
    this.isSeen,
  });

  factory MessageModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();

    return MessageModel(
        messageID: data?['messageID'],
        senderID: data?['senderID'],
        senderName: data?['senderName'],
        senderImage: data?['senderImage'],
        receiverID: data?['receiverID'],
        receiverName: data?['receiverName'],
        receiverImage: data?['receiverImage'],
        message: data?['message'],
        dateTime: data?['dateTime'],
        isIncoming: data?['isIncoming'],
        isSeen: data?['isSeen']);
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['messageID'] = messageID;
    data['senderID'] = senderID;
    data['senderName'] = senderName;
    data['senderImage'] = senderImage;
    data['receiverID'] = receiverID;
    data['receiverName'] = receiverName;
    data['receiverImage'] = receiverImage;
    data['message'] = message;
    data['dateTime'] = dateTime;
    data['isIncoming'] = isIncoming;
    data['isSeen'] = isSeen;
    return data;
  }
}
