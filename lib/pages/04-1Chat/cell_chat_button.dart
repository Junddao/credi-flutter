import 'dart:convert';

import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/enums/button_message_type.dart';
import 'package:crediApp/global/models/chat/chat_button_type_message_model.dart';
import 'package:crediApp/global/models/chat/chat_get_message_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class CellChatButton extends StatelessWidget {
  const CellChatButton(
      {Key? key, required this.context, this.messageData, this.isMe})
      : super(key: key);

  final BuildContext context;
  final bool? isMe;
  final ChatGetMessageResponseData? messageData;

  @override
  Widget build(BuildContext context) {
    var map = parseMessage(messageData!.chatMessage!.message!);
    ChatButtonTypeMessageModel welcomeMsg =
        ChatButtonTypeMessageModel.fromMap(map);
    return Column(
      children: [
        Row(
          children: [
            Container(),
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
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 0.0, bottom: 8.0, left: 0, right: 80),
          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
          width: MediaQuery.of(context).size.width * 0.75,
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(12),
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
                text: welcomeMsg.content!,
                style: CDTextStyle.body2.copyWith(
                  color: Colors.blueGrey[700],
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: 6.0,
            // vertical: 10.0,
          ),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: welcomeMsg.buttons!.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                welcomeMsg.buttons![index].type == ButtonMessageType.link
                    ? goLinkPage(welcomeMsg.buttons![index].target!)
                    : goNavPage(welcomeMsg.buttons![index].target!);
              },
              child: Container(
                margin: EdgeInsets.only(
                    top: 8.0,
                    bottom: 8.0,
                    left: 0,
                    right: MediaQuery.of(context).size.width * 0.4),
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 12.0),
                // width: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(
                      int.parse('0xff${welcomeMsg.buttons![index].color!}')),
                ),
                child: Center(
                  child: Text(welcomeMsg.buttons![index].title!,
                      style: CDTextStyle.regular14white02),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Map<String, dynamic> parseMessage(String message) {
    var map = json.decode(message);
    return map;
  }

  void goLinkPage(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  goNavPage(String page) {
    // Navigator.of(context).pushNamed(page);
    Navigator.of(context).pushNamed("PageCreateProduct");
  }
}
