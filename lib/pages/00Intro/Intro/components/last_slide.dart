import 'package:crediApp/global/theme.dart';
import 'package:flutter/material.dart';

class LastSlide extends StatelessWidget {
  const LastSlide({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 140),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 150),
                child: Container(
                  height: 1,
                  color: CDColors.blue03,
                ),
              ),
            ),
            Container(
              height: 300,
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: Text(
                  "이 모든 것을\n크레디 하나로\n\n",
                  style: CDTextStyle.h1.copyWith(fontSize: 24),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 143),
                child: Container(
                  height: 7,
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: 7,
                    width: 7,
                    decoration: BoxDecoration(
                      color: CDColors.blue03,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
