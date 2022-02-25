import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/models/chat/chat_get_message_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class CellChatMessage extends StatelessWidget {
  const CellChatMessage(
      {Key? key, required this.context, this.messageData, this.isMe})
      : super(key: key);

  final BuildContext context;
  final bool? isMe;
  final ChatGetMessageResponseData? messageData;

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
          margin: isMe!
              ? EdgeInsets.only(top: 0.0, bottom: 8.0, left: 80.0, right: 0)
              : EdgeInsets.only(top: 0.0, bottom: 8.0, left: 0, right: 80),
          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
          width: MediaQuery.of(context).size.width * 0.75,
          decoration: BoxDecoration(
            color: isMe! ? CDColors.blue_chat : Color(0xFFFFFFFF),
            borderRadius: isMe!
                ? BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0),
                    bottomLeft: Radius.circular(15.0),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0),
                    bottomLeft: Radius.circular(15.0),
                  ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Linkify(
                onOpen: (link) async {
                  if (await canLaunch(link.url)) {
                    await launch(link.url);
                  } else {
                    throw 'Could not launch $link';
                  }
                },
                text: messageData!.chatMessage!.message!,
                style: isMe!
                    ? CDTextStyle.body2.copyWith(
                        color: Colors.white,
                        fontSize: 14.0,
                      )
                    : CDTextStyle.body2.copyWith(
                        color: Colors.blueGrey[700],
                        fontSize: 14.0,
                      ),
              ),
              // Text(
              //   messageData!.chatMessage!.message!,
              //   style: isMe!
              //       ? CDTextStyle.body2.copyWith(
              //           color: Colors.white,
              //           fontSize: 14.0,
              //         )
              //       : CDTextStyle.body2.copyWith(
              //           color: Colors.blueGrey[700],
              //           fontSize: 14.0,
              //         ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
