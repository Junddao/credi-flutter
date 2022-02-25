import 'dart:io';

import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/models/chat/chat_get_message_response_model.dart';
import 'package:crediApp/global/models/file/task_info.dart';
import 'package:crediApp/global/style/cdtextstyle.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CellChatFile extends StatelessWidget {
  const CellChatFile(
      {Key? key,
      required this.context,
      this.messageData,
      this.isMe,
      this.task,
      required this.onClickFile})
      : super(key: key);

  final BuildContext context;
  final bool? isMe;
  final TaskInfo? task;
  final ChatGetMessageResponseData? messageData;
  final Function(TaskInfo)? onClickFile;

  @override
  Widget build(BuildContext context) {
    double percent = ((task!.progress ?? 0) / 100).toDouble().abs();
    if (task!.progress == -1) {
      percent = 1.0;
    }
    print(percent);
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
                onTap: () => onClickFile!(task!),
                child: Container(
                  padding: EdgeInsets.all(8),
                  height: 50,
                  decoration: BoxDecoration(
                    color: CDColors.white02,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // width: SizeConfig.screenWidth / 2,
                  child: Row(
                    children: [
                      Image.asset('assets/icons/ic_download.png'),
                      SizedBox(width: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(task!.name!,
                              style: CDTextStyle.regular11black01),
                          // Text(task!.!,
                          //     style: CDTextStyle.regular11black01),
                          // Platform.isIOS
                          //     ? SizedBox.shrink()
                          //     : LinearPercentIndicator(
                          //         width: 100.0,
                          //         lineHeight: 8.0,
                          //         percent: percent,
                          //         center: new Text((percent * 100).toString(),
                          //             style: CDTextStyle.bold6white01),
                          //         backgroundColor: Colors.grey,
                          //         progressColor: Colors.blue,
                          //       ),
                        ],
                      ),
                    ],
                  ),
                  // child: Column(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Expanded(
                  //       child: Center(
                  //         child: Icon(Icons.file_present_rounded),
                  //       ),
                  //     ),
                  //     Text('눌러서 다운로드', style: CDTextStyle.regular11black01),
                  //     // Text('${task!.progress ?? 0}',
                  //     //     style: CDTextStyle.regular11black01),

                  //     Platform.isIOS
                  //         ? SizedBox.shrink()
                  //         : LinearPercentIndicator(
                  //             width: 100.0,
                  //             lineHeight: 8.0,
                  //             percent: percent,
                  //             center: new Text((percent * 100).toString(),
                  //                 style: CDTextStyle.bold6white01),
                  //             backgroundColor: Colors.grey,
                  //             progressColor: Colors.blue,
                  //           ),
                  //   ],
                  // ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
