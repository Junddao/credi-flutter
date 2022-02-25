import 'package:cached_network_image/cached_network_image.dart';
import 'package:crediApp/global/components/cdbutton.dart';
import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/enums/factory_board_category_type.dart';
import 'package:crediApp/global/models/info/factory_board_response_model.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:crediApp/global/style/cdcolors.dart';
import 'package:crediApp/global/style/cdtextstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopularPartnerWidget extends StatefulWidget {
  const PopularPartnerWidget({Key? key, this.makeOrder}) : super(key: key);

  // 공장 list 정보
  // 견적요청 function
  final Function? makeOrder;

  @override
  State<PopularPartnerWidget> createState() => _PopularPartnerWidgetState();
}

class _PopularPartnerWidgetState extends State<PopularPartnerWidget> {
  @override
  Widget build(BuildContext context) {
    List<FactoryBoardResponseData> factoryBoardResponseData =
        context.read(infoChangeNotifier).factoryBoardResponseData!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: kDefaultHorizontalPadding),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: '실시간 ', style: CDTextStyle.bold16black01),
                TextSpan(text: 'TOP ', style: CDTextStyle.bold16blue03),
                TextSpan(text: '공장', style: CDTextStyle.bold16black01),
              ],
            ),
          ),
        ),
        wrapWidget(factoryBoardResponseData),
        SizedBox(height: 15),
        subTitleWidget(factoryBoardResponseData),

        // SizedBox(height: 10),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: kDefaultHorizontalPadding),
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 20),
            physics: NeverScrollableScrollPhysics(),
            itemCount: factoryBoardResponseData.length,
            itemBuilder: (context, index) {
              return _factoryTile(factoryBoardResponseData, index);
            },
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  wrapWidget(List<FactoryBoardResponseData> factoryBoardResponseData) {
    return Padding(
      padding: const EdgeInsets.only(left: kDefaultHorizontalPadding),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _buildChoiceList(factoryBoardResponseData),
        ),
      ),
    );
  }

  _buildChoiceList(List<FactoryBoardResponseData> factoryBoardResponseData) {
    List<Widget> chips = [];
    int selectedItemIndex =
        context.read(infoChangeNotifier).selectedFactoryBoardCategoryIndex;
    for (int i = 0; i < FactoryBoardCategoryType.categoryMap.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.only(left: 0, right: 10),
        child: ChoiceChip(
          label: Container(
            width: SizeConfig.screenWidth * 0.18,
            alignment: Alignment.center,
            child:
                Text(FactoryBoardCategoryType.categoryMap.values.elementAt(i)),
          ),
          shape: selectedItemIndex == i
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                )
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(color: CDColors.black04, width: 1),
                ),
          labelStyle: selectedItemIndex == i
              ? CDTextStyle.bold12white02
              : CDTextStyle.bold12black05,
          backgroundColor: CDColors.white02,
          selectedColor: CDColors.blue03,
          selected: selectedItemIndex == i,
          onSelected: (bool value) {
            context.read(infoChangeNotifier).selectFactoryBoardItem(i);
            context.read(infoChangeNotifier).getFactoryBoard(
                FactoryBoardCategoryType.categoryMap.keys.elementAt(i));
            // setState(() {});
            // setState(() {
            //   selectedIndex = i;
            // });
          },
        ),
      );
      chips.add(item);
    }

    return chips;
  }

  subTitleWidget(List<FactoryBoardResponseData> factoryBoardResponseData) {
    int selectedIndex =
        context.read(infoChangeNotifier).selectedFactoryBoardCategoryIndex;
    String subTitle = '';
    switch (selectedIndex) {
      case 0:
        subTitle = '본격적인 생산 전, 시제품 제작을 통해 제품을 검증 해보세요!';
        break;
      case 1:
        subTitle = 'MOQ 제한이 낮아 소량생산  제품도 대응이 가능합니다.';
        break;
      case 2:
        subTitle = '컨설팅을 통해 개선사항을 도출하고 보완해 보세요!';
        break;
      case 3:
        subTitle = '기능/생산성을 고려한 최적의 제품을 설계하고 제안합니다.';
        break;
      default:
    }
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: kDefaultHorizontalPadding),
      child: Text(subTitle, style: CDTextStyle.regular12black04),
    );
  }

  _factoryTile(
      List<FactoryBoardResponseData> factoryBoardResponseData, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          factoryBoardResponseData[index].factoryBoard!.image != ''
              ? CircleAvatar(
                  radius: 25,
                  backgroundImage: CachedNetworkImageProvider(
                      factoryBoardResponseData[index].factoryBoard!.image!),
                  backgroundColor: Colors.transparent,
                )
              : CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.transparent,
                  child: Icon(Icons.person),
                ),
          SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(factoryBoardResponseData[index].factoryBoard!.companyName!,
                  style: CDTextStyle.bold14black01),
              SizedBox(height: 4),
              Text(factoryBoardResponseData[index].factoryBoard!.name!,
                  style: CDTextStyle.regular12black01),
              SizedBox(height: 4),
              Text(factoryBoardResponseData[index].factoryBoard!.hashTag!,
                  style: CDTextStyle.medium12blue03),
            ],
          ),
        ],
      ),
    );
  }
}
