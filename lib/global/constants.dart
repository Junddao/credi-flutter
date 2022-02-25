import 'package:flutter/material.dart';
export './theme.dart';
import './theme.dart';

const String test_image_url =
    'https://upload.wikimedia.org/wikipedia/commons/5/5f/%ED%95%9C%EA%B3%A0%EC%9D%80%2C_%EB%AF%B8%EC%86%8C%EA%B0%80_%EC%95%84%EB%A6%84%EB%8B%A4%EC%9B%8C~_%281%29.jpg';

// APP
const String APP_NAME = "크레디 - 만듦이 이어지는 곳";
// API

// const kPrimaryColor = Colors.deepPurpleAccent;
const kPrimaryLightColor = Colors.purpleAccent;
// const kBlue = Color.fromRGBO(140, 190, 255, 1);
const double kCellHeight = 54;

// const kPrimaryColor = Color(0xFF035AA6);
// const kSecondaryColor = Color(0xFFFFA41B);
// const kTextColor = Color(0XFF000839);
const kTextLightColor = Color(0xFF747474);
// const kBlueColor = Color(0xFF40BAD5);

// const kPrimaryColor = Color(0xFF498EFF);
const kPrimaryColor = CDColors.blue5;
const kBlueColor = Color(0xFF498EFF);
// const kPrimaryColor = Color(0xFFA95EFA);
const kSecondaryColor = Color(0xFFFF3F6F8);
const kTextColor = Color(0XFF171717);

const kDefaultPadding = 24.0;
const kDefaultVerticalPadding = 10.0;
const kDefaultHorizontalPadding = 24.0;

// default shadow
const kDefaultShadow = BoxShadow(
  offset: Offset(0, 15),
  blurRadius: 27,
  color: Colors.black12, // Black wiht 12% opacity
);

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
    defaultSize = orientation == Orientation.landscape
        ? screenHeight * 0.024
        : screenWidth * 0.025;
  }
}

class Constants {
  static String myName = "";
  static String myId = "";
  static BorderRadius boxBorder = BorderRadius.circular(8);
  // static User myUser = User();
  static var emailRegex =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
}

getChatRoomId(int a, int b) {
  // logger.i("$a , $b");
  if (a.compareTo(b) > 0) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}

bool isNumber(String? value) {
  if (value == null) {
    return true;
  }
  final n = num.tryParse(value);
  return n != null;
}
