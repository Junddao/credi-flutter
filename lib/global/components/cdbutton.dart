import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:crediApp/global/constants.dart';

class ButtonType {
  const ButtonType._(this.type);

  final String type;
  static const normal = ButtonType._('normal');
  static const normal_blue02 = ButtonType._('normal_blue02');
  static const normal_blue04 = ButtonType._('normal_blue04');
  static const dark = ButtonType._('dark');
  static const success = ButtonType._('success');
  static const warning = ButtonType._('warning');
  static const disabled = ButtonType._('disabled');
  static const transparent = ButtonType._('transparent');
  static const normal_black = ButtonType._('default_black');
  static const decline = ButtonType._('decline');

  @override
  String toString() {
    return const <String, String>{
      'normal': 'ButtonType.normal',
      'normal_blue02': 'ButtonType.normal_blue02',
      'normal_blue04': 'ButtonType.normal_blue04',
      'dark': 'ButtonType.dark',
      'transparent': 'ButtonType.transparent',
      'success': 'ButtonType.success',
      'warning': 'ButtonType.warning',
      'disabled': 'ButtonType.disabled',
      'normal_black': 'ButtonType.normal_black',
      'decline': 'ButtonType.decline'
    }[type]!;
  }

  Color? buttonColor() {
    return const <String, Color>{
      'normal': CDColors.blue03,
      'normal_blue02': CDColors.blue02,
      'normal_blue04': Colors.transparent,
      'dark': CDColors.blue04,
      'transparent': Colors.transparent,
      'success': CDColors.blue03,
      'warning': CDColors.red01,
      'disabled': CDColors.blue03,
      'normal_black': CDColors.blue03,
      'decline': CDColors.decline,
    }[type];
  }

  Color? textColor() {
    return const <String, Color>{
      'normal': Colors.white,
      'normal_blue02': Colors.white,
      'normal_blue04': CDColors.blue04,
      'dark': Colors.white,
      'transparent': CDColors.gray3,
      'success': CDColors.gray3,
      'warning': Colors.white,
      'disabled': CDColors.gray3,
      'normal_black': CDColors.gray3,
      'decline': Colors.white,
    }[type];
  }
}

class CDButton extends StatelessWidget {
  // final Size size;
  final String text;
  final Function press;
  final EdgeInsets? margin;
  final double? width;
  final double height;
  final double radius;
  final ButtonType type;
  CDButton({
    // required this.size,
    Key? key,
    required this.text,
    required this.press,
    this.margin,
    this.width,
    this.height = 50,
    this.radius = 14,
    this.type = ButtonType.normal,
  }) : super(key: key);

  Color? color = CDColors.blue03;
  Color? textColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    color = type.buttonColor();
    textColor = type.textColor();
    return Container(
      // color: Colors.red,
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: FlatButton(
            padding: EdgeInsets.symmetric(horizontal: 0),
            color: color,
            onPressed: press as void Function()?,
            child: Text(
              text,
              style: CDTextStyle.button.copyWith(color: textColor),
            )),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('height', height));
  }
}
