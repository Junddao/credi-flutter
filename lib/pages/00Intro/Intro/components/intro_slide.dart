import 'package:crediApp/global/theme.dart';
import 'package:flutter/material.dart';

class IntroSlide extends StatelessWidget {
  final String title;
  final String description;
  final String pathImage;
  const IntroSlide({
    Key? key,
    required this.title,
    required this.description,
    required this.pathImage,
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
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 150),
                child: Container(
                  height: 1,
                  color: CDColors.blue03,
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: CDTextStyle.h1.copyWith(fontSize: 24),
                ),
                Image.asset(
                  pathImage,
                  width: 220,
                  height: 220,
                ),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: CDTextStyle.h5,
                ),
              ],
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 150),
                child: Container(
                  height: 1,
                  color: CDColors.blue03,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
