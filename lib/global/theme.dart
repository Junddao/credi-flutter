export 'style/cdcolors.dart';
export 'style/cdtextstyle.dart';

import 'package:flutter/material.dart';
import 'style/cdcolors.dart';

const BuildContext? defaultContext = null;
final ThemeData kThemeData = ThemeData(
  primarySwatch: CDColors.blue5 as MaterialColor?,
  backgroundColor: Colors.white,
  accentColor: Colors.deepPurple,
  accentColorBrightness: Brightness.dark,
  buttonTheme: ButtonTheme.of(defaultContext!).copyWith(
    buttonColor: Colors.pink,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
);

boxShadow() {
  return BoxDecoration(
    color: Colors.white,
    border: Border.all(
      color: CDColors.gray4,
      width: 1,
    ),
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(
        color: Color(0x0c212528),
        offset: Offset(0, 8),
        blurRadius: 6,
        spreadRadius: 0,
      ),
    ],
  );
}
