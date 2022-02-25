import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/models/info/faq_response_model.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/provider.dart';
import 'package:riverpod/riverpod.dart';

class QuestionWidget extends StatefulWidget {
  const QuestionWidget({Key? key}) : super(key: key);

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  @override
  Widget build(BuildContext context) {
    List<FaqResponseData>? faqList =
        context.read(infoChangeNotifier).faqResponseDatas;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: kDefaultHorizontalPadding),
          child: Text('자주 묻는 질문', style: CDTextStyle.bold16black01),
        ),
        SizedBox(height: 11),
        Container(
          // height: SizeConfig.screenWidth * 0.5,
          width: double.infinity,
          child: ListView.builder(
            padding: EdgeInsets.only(top: 20),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: faqList!.length,
            itemBuilder: (context, index) {
              return _listTile(faqList, index);
            },
          ),
        ),
      ],
    );
  }

  _listTile(List<FaqResponseData>? faqList, int index) {
    var faqResponseData = faqList![index];

    return InkWell(
      onTap: () {
        context.read(infoChangeNotifier).selectFaqItem(index);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultHorizontalPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Text('Q.${index + 1}',
                            style: CDTextStyle.bold14blue03),
                      ),
                      SizedBox(width: 8),
                      Text(faqResponseData.faq!.title!,
                          style: CDTextStyle.regular14black01),
                    ],
                  ),
                  faqResponseData.faq!.isSelected == true
                      ? Icon(
                          Icons.keyboard_arrow_up_rounded,
                          color: CDColors.blue03,
                        )
                      : Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: CDColors.black04,
                        ),
                ],
              ),
            ),
            faqResponseData.faq!.isSelected == true
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultHorizontalPadding),
                    decoration: BoxDecoration(
                      color: CDColors.white01,
                    ),
                    child: Text(
                      faqResponseData.faq!.description!,
                      style: CDTextStyle.regular14black03
                          .merge(TextStyle(height: 1.6)),
                      // maxLines: isExpandIndroduce == false ? 4 : 2000,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
