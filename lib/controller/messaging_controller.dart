import 'package:flutter/material.dart';
import 'package:flutter_isell_new/controller/home_page_controller.dart';
import 'package:flutter_isell_new/core/services/firestore_service.dart';
import 'package:get/get.dart';

import '../data/model/message_model.dart';

class MessagingController extends GetxController {
  Rx<int> receiverID = 0.obs;
  Rx<String> receiverName = ''.obs;
  Rx<String> receiverImage = ''.obs;

  RxMap<String, dynamic> userData = <String, dynamic>{}.obs;

  TextEditingController sendMessageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    FirestoreService()
        .getUserByID(
            userID: myServices.sharedPreferences.getInt('id').toString())
        .then((value) {
      userData.value = value!;
      print("userData>>>>>>> $userData");
    });
  }

  saveMessage() async {
    String msg = sendMessageController.text;
    sendMessageController.clear();

    // Save message for sender
    MessageModel messageModelForSender = MessageModel(
        senderID: userData['uid'],
        senderName: userData['name'],
        senderImage: userData['image'],
        receiverID: receiverID.value.toString(),
        receiverName: receiverName.value,
        receiverImage: receiverImage.value,
        message: msg,
        dateTime: DateTime.now().toString(),
        isIncoming: false,
        isSeen: true);

    bool isMessageSavedForSender = await FirestoreService().saveMessage(
        userID: userData['uid'],
        msgUserID: receiverID.value.toString(),
        msgUserName: receiverName.value,
        msgUserImage: receiverImage.value,
        isNewMsg: false,
        messageModel: messageModelForSender);

    if (isMessageSavedForSender == true) {
      // Save message for receiver
      MessageModel messageModelForReceiver = MessageModel(
          senderID: userData['uid'],
          senderName: userData['name'],
          senderImage: userData['image'],
          receiverID: receiverID.value.toString(),
          receiverName: receiverName.value,
          receiverImage: receiverImage.value,
          message: msg,
          dateTime: DateTime.now().toString(),
          isIncoming: true,
          isSeen: false);

      bool isMessageSavedForReceiver = await FirestoreService().saveMessage(
          userID: receiverID.value.toString(),
          msgUserID: userData['uid'],
          msgUserName: userData['name'],
          msgUserImage: userData['image'],
          isNewMsg: true,
          messageModel: messageModelForReceiver);

      if (isMessageSavedForReceiver == true) {
        msg = "";
      } else {
        // showBottomSnackBar(
        //     title: 'Error',
        //     msg: 'Something went wrong',
        //     duration: 2,
        //     backgroundColor: AppColors.darkRed
        // );
      }
    } else {
      // showBottomSnackBar(
      //     title: 'Error',
      //     msg: 'Something went wrong',
      //     duration: 2,
      //     backgroundColor: AppColors.darkRed
      // );
    }
  }
}
