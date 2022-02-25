import 'package:crediApp/global/enums/bid_state_type.dart';
import 'package:crediApp/global/service/service_string_utils.dart';
import 'package:crediApp/global/style/cdtextstyle.dart';
import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/models/bid/bid_response_model.dart';
import 'package:crediApp/global/util.dart';
import 'package:crediApp/global/components/cdbutton.dart';
import 'package:flutter/material.dart';

class CellBid extends StatelessWidget {
  final Color? buttonColor;
  final BidResponseData bidResponseData;
  final String? state;
  final Function onPageRating;
  final Function onPageChatDetail;
  final Function onShowBidDetail;
  const CellBid({
    Key? key,
    required this.bidResponseData,
    required this.onPageRating,
    required this.onPageChatDetail,
    required this.onShowBidDetail,
    this.buttonColor,
    this.state,
  }) : super(key: key);

  final textStyleTitle =
      const TextStyle(fontSize: 13, color: Color(0xFF9d9d9d));
  final textStyleBody = const TextStyle(fontSize: 14, color: Color(0xFF1f1f1f));

  Color borderColorForCurrentState() {
    switch (state) {
      case BidStateType.making:
        return CDColors.blue03;
      case BidStateType.done:
        return CDColors.blue04;
      default:
        return CDColors.black04;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // color: Color(0xFFF7F7F7),
        border: Border.all(
          color: borderColorForCurrentState(),
        ),
      ),
      child: Row(
        children: [
          Flexible(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${bidResponseData.bid!.companyName}",
                        style: CDTextStyle.cellBoldBody.copyWith(fontSize: 17),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed('PageCompanyInfo',
                              arguments: bidResponseData.bid!.factoryId);
                        },
                        child: Row(
                          children: [
                            Text('업체정보', style: CDTextStyle.regular14black04),
                            Icon(
                              Icons.chevron_right,
                              color: CDColors.black04,
                              size: 15.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "최소수량",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            softWrap: false,
                            style: textStyleTitle,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "개당금액",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            softWrap: false,
                            style: textStyleTitle,
                          ),
                        ],
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ServiceStringUtils.quantity(
                                bidResponseData.bid!.quantityMin ?? 0),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            softWrap: false,
                            style: CDTextStyle.cellBoldBody,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ServiceStringUtils.won(
                                bidResponseData.bid!.cost ?? 0),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            softWrap: false,
                            style: CDTextStyle.cellBoldBody,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    "업체 메시지",
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: textStyleTitle,
                  ),
                  SizedBox(height: 4),
                  Text(
                    bidResponseData.bid!.description!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    softWrap: false,
                    style: CDTextStyle.cellBody,
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      state == null
                          ? SizedBox.shrink()
                          : Expanded(child: _buildConsultingButton()),
                      Expanded(child: _buildBidDetailButton()),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Icon(Icons.chevron_right), // detail closure
        ],
      ),
    );
  }

  Widget _buildConsultingButton() {
    if ([BidStateType.chatting, BidStateType.making].contains(state)) {
      return CDButton(
        margin: EdgeInsets.only(right: 4),
        height: 48,
        text: "상담하기",
        press: () {
          onPageChatDetail();
        },
      );
    } else if (state == BidStateType.done) {
      logger.i(bidResponseData.bid!);
      return CDButton(
        margin: EdgeInsets.only(right: 4),
        height: 48,
        text: "후기작성",
        type: ButtonType.dark,
        press: () {
          onPageRating();
        },
      );
    } else {
      return Container();
    }
  }

  Widget _buildBidDetailButton() {
    return CDButton(
      margin: EdgeInsets.only(left: 4),
      height: 48,
      text: "상세견적보기",
      type: ButtonType.normal_blue02,
      press: () {
        onShowBidDetail();
      },
    );
  }
}
