import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/theme.dart';
import 'package:flutter/material.dart';

class HomeIntroWidget extends StatelessWidget {
  const HomeIntroWidget({Key? key, this.goUserGuide}) : super(key: key);

  final Function? goUserGuide;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 80),
        Text('3분이면', style: CDTextStyle.bold24black01),
        Text('제조 견적 요청 끝!', style: CDTextStyle.bold24black01),
        SizedBox(height: 10),
        InkWell(
          onTap: () {
            goUserGuide!();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: CDColors.blue03,
                width: 0.5,
              ),
              color: CDColors.white02,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image.asset('assets/icons/ic_directions.png'),
                Text('이용 방법 보기', style: CDTextStyle.light12blue03),
              ],
            ),
          ),
        ),
        SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: CDColors.blue01,
                  child: Image.asset('assets/icons/ic_silicon.png'),
                ),
                SizedBox(height: 4),
                Text('실리콘', style: CDTextStyle.regular12black01),
              ],
            ),
            Column(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: CDColors.blue01,
                  child: Image.asset('assets/icons/ic_steel.png'),
                ),
                SizedBox(height: 4),
                Text('금속', style: CDTextStyle.regular12black01),
              ],
            ),
            Column(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: CDColors.blue01,
                  child: Image.asset('assets/icons/ic_plastic.png'),
                ),
                SizedBox(height: 4),
                Text('플라스틱', style: CDTextStyle.regular12black01),
              ],
            ),
            Column(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: CDColors.blue01,
                  child: Image.asset('assets/icons/ic_glass.png'),
                ),
                SizedBox(height: 4),
                Text('유리', style: CDTextStyle.regular12black01),
              ],
            ),
            Column(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: CDColors.blue01,
                  child: Image.asset('assets/icons/ic_wood.png'),
                ),
                SizedBox(height: 4),
                Text('원목', style: CDTextStyle.regular12black01),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
