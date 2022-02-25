import 'dart:convert';

import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/enums/message_type.dart';
import 'package:crediApp/global/models/chat/chat_button_type_message_model.dart';
import 'package:crediApp/global/models/chat/chat_get_all_response_model.dart';
import 'package:flutter/material.dart';

class CellChatList extends StatelessWidget {
  const CellChatList({
    Key? key,
    this.userName,
    required this.chatRoom,
    this.onTap,
    this.icon,
    this.titleColor = const Color(0xff1f1f1f),
  }) : super(key: key);

  final Widget? icon;
  final String? userName;
  final Color titleColor;
  final ChatGetAllResponseData chatRoom;
  final Function? onTap;

  startConversation() {}

  @override
  Widget build(BuildContext context) {
    String message = chatRoom.chatMessage!.message ?? "no messages yet";
    if (chatRoom.chatMessage!.type == MessageType.image ||
        chatRoom.chatMessage!.type == MessageType.file) {
      message = '첨부 이미지';
    }
    if (chatRoom.chatMessage!.type == MessageType.button) {
      var map = parseMessage(message);
      ChatButtonTypeMessageModel welcomeMsg =
          ChatButtonTypeMessageModel.fromMap(map);
      message = welcomeMsg.content!;
    }
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        margin: const EdgeInsets.only(top: 4.0, bottom: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          // color: chat.unread ? CDColors.primary.withOpacity(0.2) : Colors.white,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8.0),
            bottomRight: Radius.circular(8.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      icon == null ? Container() : icon!,
                      Text(
                        userName ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: CDTextStyle.bold16black01
                            .copyWith(color: titleColor),
                        // style: TextStyle(
                        //   color: CDColors.gray7,
                        //   fontSize: 16.0,
                        //   fontWeight: FontWeight.bold,
                        // ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: CDTextStyle.body2,
                    // style: TextStyle(
                    //   color: CDColors.gray6,
                    //   fontSize: 14.0,
                    //   fontWeight: FontWeight.w600,
                    // ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    chatRoom.createdAt ?? '',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,

                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  _buildUnreadMark(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> parseMessage(String message) {
    var map = json.decode(message);
    return map;
  }

  Widget _buildUnreadMark(BuildContext context) {
    return chatRoom.newMessageCount! > 0
        ? Container(
            width: 35.0,
            height: 20.0,
            decoration: BoxDecoration(
              color: CDColors.red01,
              borderRadius: BorderRadius.circular(14.0),
            ),
            alignment: Alignment.center,
            child: Text('${chatRoom.newMessageCount}',
                style: CDTextStyle.bold13white01),
            // Text(
            //         'NEW',
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 12.0,
            //           fontWeight: FontWeight.bold,
            //         ),
          )
        : SizedBox.shrink();
  }
}
