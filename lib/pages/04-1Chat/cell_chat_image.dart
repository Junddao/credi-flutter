import 'package:cached_network_image/cached_network_image.dart';
import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/models/chat/chat_get_message_response_model.dart';
import 'package:flutter/material.dart';

class CellChatImage extends StatelessWidget {
  const CellChatImage(
      {Key? key,
      required this.context,
      this.messageData,
      this.isMe,
      required this.onClickImage})
      : super(key: key);

  final BuildContext context;
  final bool? isMe;
  final ChatGetMessageResponseData? messageData;
  final Function onClickImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          isMe! ? Spacer() : Container(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              messageData!.createdAt!,
              style: TextStyle(
                color: Colors.blueGrey[300],
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ]),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
          // width: MediaQuery.of(context).size.width * 0.30,
          // height: MediaQuery.of(context).size.width * 0.45,
          child: Row(
            mainAxisAlignment:
                isMe! ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => onClickImage(),
                child: CachedNetworkImage(
                  height: SizeConfig.screenWidth * 0.3,
                  width: SizeConfig.screenWidth * 0.3,
                  fit: BoxFit.cover,
                  imageUrl: messageData!.chatMessage!.message!,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
