import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:crediApp/global/constants.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    // required this.size,
    Key? key,
    this.text,
    this.press,
    this.color = kPrimaryColor,
    this.textColor = Colors.white,
    this.margin,
    this.width,
    this.height = kCellHeight,
  }) : super(key: key);

  final double height;
  final EdgeInsets? margin;
  final Function? press;
  // final Size size;
  final String? text;

  final Color color, textColor;
  final double? width;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('height', height));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height * 0.5),
        child: FlatButton(
          // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          color: color,
          onPressed: press as void Function()?,
          child: Text(
            text!,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}

class RoundButton extends StatelessWidget {
  const RoundButton({
    // required this.size,
    Key? key,
    required this.text,
    required this.press,
    this.color = CDColors.blue5,
    this.textColor = Colors.white,
  }) : super(key: key);

  final VoidCallback press;
  // final Size size;
  final String text;

  final Color color, textColor;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: StadiumBorder(),
      color: this.color,
      onPressed: press,
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
