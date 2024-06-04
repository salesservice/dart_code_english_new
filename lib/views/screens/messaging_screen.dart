import 'package:flutter/material.dart';
import 'package:flutter_isell_new/controller/messaging_controller.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../core/constants/sellx_colors.dart';
import '../../core/services/firestore_service.dart';
import '../../data/model/message_model.dart';

class MessagingScreen extends StatelessWidget {
  MessagingScreen({super.key});

  final controller = Get.put(MessagingController());
  final args = Get.arguments;

  @override
  Widget build(BuildContext context) {
    controller.receiverID.value = args['receiverID'];
    controller.receiverName.value = args['receiverName'];
    controller.receiverImage.value = args['receiverImage'];

    return Obx(
      () => Scaffold(
        backgroundColor: Myisellcolors.home,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Myisellcolors.hvit),
          backgroundColor: Myisellcolors.home,
          elevation: 0,
          centerTitle: true,
          title: Text(
            controller.receiverName.value,
            style: const TextStyle(color: Myisellcolors.hvit),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: controller.userData['uid'] != null
                    ? StreamBuilder<List<MessageModel>>(
                        stream: FirestoreService().getMessageStream(
                            currentUserID: controller.userData['uid'],
                            msgUserID: controller.receiverID.toString()),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<MessageModel> messageList = snapshot.data!;

                            if (messageList.isNotEmpty) {
                              messageList.sort(
                                  (a, b) => b.dateTime!.compareTo(a.dateTime!));

                              return ListView.builder(
                                  itemCount: messageList.length,
                                  reverse: true,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.symmetric(
                                      vertical: Get.height * 0.01),
                                  itemBuilder: (context, index) {
                                    MessageModel message = messageList[index];

                                    DateTime messageDateTime =
                                        DateTime.parse(message.dateTime!);
                                    String messageTimeAgo =
                                        timeago.format(messageDateTime);
                                    print(
                                        'messageTimeAgo>>>>>>>>> $messageTimeAgo');

                                    return Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: Get.height * 0.01,
                                              horizontal: Get.height * 0.02),
                                          child: Align(
                                              alignment:
                                                  message.isIncoming == true
                                                      ? Alignment.topLeft
                                                      : Alignment.topRight,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(
                                                        Get.height * 0.02),
                                                    constraints: BoxConstraints(
                                                        minWidth:
                                                            Get.width * 0.3,
                                                        maxWidth:
                                                            Get.height * 0.3),
                                                    decoration: BoxDecoration(
                                                      color: message
                                                                  .isIncoming ==
                                                              true
                                                          ? Myisellcolors.hvit
                                                          : Myisellcolors.blue,
                                                      borderRadius: message
                                                                  .isIncoming ==
                                                              true
                                                          ? const BorderRadius
                                                              .only(
                                                              topLeft: Radius
                                                                  .circular(12),
                                                              topRight: Radius
                                                                  .circular(12),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          12),
                                                              bottomLeft: Radius
                                                                  .circular(0),
                                                            )
                                                          : const BorderRadius
                                                              .only(
                                                              topLeft: Radius
                                                                  .circular(12),
                                                              topRight: Radius
                                                                  .circular(12),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          0),
                                                              bottomLeft: Radius
                                                                  .circular(12),
                                                            ),
                                                    ),
                                                    child: Column(
                                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          width: Get.width,
                                                          child: Text(
                                                            message.message ??
                                                                "",
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: const TextStyle(
                                                                color:
                                                                    Myisellcolors
                                                                        .blak,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 3,
                                                        ),
                                                        SizedBox(
                                                          width: Get.width,
                                                          child: Text(
                                                            messageTimeAgo,
                                                            textAlign:
                                                                TextAlign.right,
                                                            // style: AppTextStyle.poppins(
                                                            //     message.isIncoming == true ? AppColors.grey : AppColors.whiteColor, 10,
                                                            //     FontWeight.w500),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ],
                                    );
                                  });
                            }

                            return const Center(
                              child: Text(
                                'Type a message to send',
                                style: TextStyle(
                                  color: Myisellcolors.hoved,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return const Center(
                                child: CircularProgressIndicator(
                              color: Myisellcolors.hvit70,
                            ));
                          }
                        },
                      )
                    : const Center(
                        child: CircularProgressIndicator(
                        color: Myisellcolors.hvit70,
                      )),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    color: Myisellcolors.hvit,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03),
                    height: Get.height * 0.1,
                    width: double.infinity,
                    child: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: controller.sendMessageController,
                      builder: (context, value, child) {
                        return TextField(
                          controller: controller.sendMessageController,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 5,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed:
                                  controller.sendMessageController.text == ''
                                      ? null
                                      : () async {
                                          print(
                                              'checking>>>>>>>>>>>>> ${controller.sendMessageController.text}');
                                          controller.saveMessage();
                                        },
                              icon: const Icon(
                                Icons.send,
                              ),
                            ),
                            suffixStyle: const TextStyle(
                              color: Myisellcolors.hvit70,
                            ),
                            filled: true,
                            fillColor: Myisellcolors.hvit,
                            hintText: "Write message...",
                            helperStyle: TextStyle(
                              fontSize: Get.height * 0.02,
                              color: Myisellcolors.hvit70,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Myisellcolors.hvit70,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Myisellcolors.hvit70,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Myisellcolors.hvit70,
                              ),
                            ),
                            //  border: OutlineInputBorder()
                          ),
                        );
                      },
                    )))
          ],
        ),
      ),
    );
  }
}
