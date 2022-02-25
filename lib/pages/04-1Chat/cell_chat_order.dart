import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/models/user_order/user_order_view_info_response_model.dart';
import 'package:flutter/material.dart';

class CellChatOrder extends StatelessWidget {
  const CellChatOrder(
      {Key? key,
      required this.context,
      this.userOrderViewInfoResponseData,
      this.isMe,
      required this.onAcceptOrder,
      required this.onDeclineOrder})
      : super(key: key);
  final BuildContext context;
  final UserOrderViewInfoResponseData? userOrderViewInfoResponseData;
  final bool? isMe;
  final Function onAcceptOrder;
  final Function onDeclineOrder;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // Map<String, dynamic> productJson =
    //     json.decode(messageData!.chatMessage!.productJson!);
    // ProductResponseData productResponseData =
    //     ProductResponseData.fromMap(productJson);
    return Column(
      children: [
        Row(children: [
          isMe! ? Spacer() : Container(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              userOrderViewInfoResponseData!.orderCreateAt!,
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
              ? EdgeInsets.only(
                  top: 0.0, bottom: 8.0, left: size.width - 240 - 8, right: 8)
              : EdgeInsets.only(
                  top: 0.0, bottom: 8.0, left: 8, right: size.width - 240 - 8),
          width: 240,
          // color: Colors.white,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: CDColors.blue_chat),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Text("발주요청서", style: CDTextStyle.title2),
                    ),
                    Text(
                      "\n수량과 가격 등 상세 내용은\n상호 논의를 통해 변경 될 수 있습니다.\n",
                      style: CDTextStyle.body2.copyWith(
                        fontSize: 13,
                        color: CDColors.black03,
                      ),
                    ),
                    Text(
                      "제품명",
                      style: CDTextStyle.body2.copyWith(
                        fontSize: 13,
                        color: CDColors.black04,
                      ),
                    ),
                    Text(
                      "${userOrderViewInfoResponseData!.productName!}",
                      style: CDTextStyle.h1.copyWith(
                        fontSize: 14,
                        color: CDColors.black02,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Divider(),
                    Row(
                      children: [
                        Text(
                          "일시",
                          style: CDTextStyle.body2.copyWith(
                            fontSize: 13,
                            color: CDColors.black04,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "${userOrderViewInfoResponseData!.orderCreateAt!}",
                          style: CDTextStyle.h1.copyWith(
                            fontSize: 14,
                            color: CDColors.black02,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
