import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/sellx_colors.dart';
import '../../data/model/chat_model.dart';

class ChatWidget extends StatefulWidget {
  final ChatModel model;

  const ChatWidget(this.model, {super.key});

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
              height: Get.width * .16,
              width: Get.width * .16,
              margin: const EdgeInsets.only(right: 10),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Myisellcolors.blue,
              ),
              child: widget.model.imagePath != null &&
                      widget.model.imagePath!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: widget.model.imagePath!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(
                        color: Myisellcolors.hvit,
                      ),
                      errorWidget: (context, url, error) {
                        // return Image.asset(
                        //   AppImages.ownerIcon,scale: 25,
                        // );
                        return const Icon(
                          Icons.person,
                          size: 40,
                        );
                      },
                    )
                  : const Icon(
                      Icons.person,
                      size: 40,
                    )),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.model.name!,
                      style: TextStyle(
                          color: Myisellcolors.hoved,
                          fontSize: Get.width * 0.045,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      widget.model.dateTime!,
                      style: TextStyle(
                          color: Myisellcolors.hvit,
                          fontSize: Get.width * 0.032,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.model.recentMessage!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                            color: Myisellcolors.hvit,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    if (widget.model.isNew == true)
                      Container(
                        // height: Get.height * 0.03,
                        // width: Get.width * 0.05,
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 7),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Myisellcolors.blue,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Center(
                            child: Text(
                          // widget.model.unseenMessages.toString(),
                          'Ny',
                          style: TextStyle(
                              color: Myisellcolors.hvit,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        )),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
