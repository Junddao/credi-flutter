import 'package:crediApp/global/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:crediApp/global/constants.dart';

class ButtonBid extends StatelessWidget {
  const ButtonBid({
    Key? key,
    this.press,
  }) : super(key: key);

  final Function? press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press as void Function()?,
      // child: Container(
      //   margin: EdgeInsets.all(kDefaultPadding),
      //   padding: EdgeInsets.symmetric(
      //     horizontal: kDefaultPadding,
      //     vertical: kDefaultPadding / 2,
      //   ),
      //   decoration: BoxDecoration(
      //     color: CDColors.blue5,
      //     borderRadius: BorderRadius.circular(30),
      //   ),
      child: Container(
        color: Colors.blue,
        child: RoundedButton(
          text: "견적 작성",
          color: CDColors.blue5,
          textColor: Colors.white,
          press: press,
        ),
      ),
    );
  }
}
