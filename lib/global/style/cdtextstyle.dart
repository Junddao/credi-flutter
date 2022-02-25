import 'package:flutter/material.dart';
import 'cdcolors.dart';

class CDTextStyle {
  static const nav = TextStyle(
      fontFamily: 'Roboto',
      fontSize: 17,
      fontWeight: FontWeight.w700,
      color: Color(0xFF1F1F1F),
      fontStyle: FontStyle.normal);
  static const title2 = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w400, color: CDColors.text2);
  static const body2 = TextStyle(
      fontSize: 14, fontWeight: FontWeight.w400, color: CDColors.text2);
  static const button =
      TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.white);
  static const cellBoldBody = TextStyle(
      fontSize: 13, fontWeight: FontWeight.w700, color: CDColors.text2);
  static const cellBody = TextStyle(
      fontSize: 13, fontWeight: FontWeight.w400, color: CDColors.text2);

  static const h1 = TextStyle(
      fontSize: 38, fontWeight: FontWeight.w400, color: CDColors.gray9);
  static const h2 = TextStyle(
      fontSize: 28, fontWeight: FontWeight.w400, color: CDColors.gray9);
  static const h3 = TextStyle(
      fontSize: 22, fontWeight: FontWeight.w400, color: CDColors.gray9);
  static const h4 = TextStyle(
      fontSize: 20, fontWeight: FontWeight.w400, color: CDColors.gray9);
  static const h5 = TextStyle(
      fontSize: 18, fontWeight: FontWeight.w400, color: CDColors.gray9);
  static const h6 = TextStyle(
      fontSize: 18, fontWeight: FontWeight.w400, color: CDColors.gray9);
  static const p1 = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w400, color: CDColors.gray9);
  static const p2 = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w400, color: CDColors.gray9);
  static const p3 = TextStyle(
      fontSize: 14, fontWeight: FontWeight.w400, color: CDColors.gray9);
  static const p4 = TextStyle(
      fontSize: 12, fontWeight: FontWeight.w300, color: CDColors.gray9);
  static const p5 = TextStyle(
      fontSize: 12, fontWeight: FontWeight.w200, color: CDColors.gray9);

  static regularFont({double fontSize = 12, color = CDColors.gray9}) {
    return TextStyle(
        fontSize: fontSize, fontWeight: FontWeight.w400, color: color);
  }

  static boldFont({double fontSize = 12, color = CDColors.gray9}) {
    return TextStyle(
        fontSize: fontSize, fontWeight: FontWeight.bold, color: color);
  }

  static const bold6white01 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 6,
    fontWeight: FontWeight.w700,
    color: CDColors.white01,
    fontStyle: FontStyle.normal,
  );

  static const regular11black01 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: CDColors.black01,
    fontStyle: FontStyle.normal,
  );

  static const regular11black04 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: CDColors.black04,
    fontStyle: FontStyle.normal,
  );

  static const regular11blue03 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: CDColors.blue03,
    fontStyle: FontStyle.normal,
  );

  static const regular9black03 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 9,
    fontWeight: FontWeight.w400,
    color: CDColors.black03,
    fontStyle: FontStyle.normal,
  );

  static const black17white02 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: CDColors.white02,
    fontStyle: FontStyle.normal,
  );

  static const light12blue03 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: CDColors.blue03,
    fontStyle: FontStyle.normal,
  );

  static const regular12blue03 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: CDColors.blue03,
    fontStyle: FontStyle.normal,
  );

  static const regular12black01 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: CDColors.black01,
    fontStyle: FontStyle.normal,
  );
  static const regular12white02 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: CDColors.white02,
    fontStyle: FontStyle.normal,
  );

  static const regular12black04 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: CDColors.black04,
    fontStyle: FontStyle.normal,
  );

  static const regular12black05 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: CDColors.black05,
    fontStyle: FontStyle.normal,
  );

  static const regular18black05 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: CDColors.black05,
    fontStyle: FontStyle.normal,
  );
  static const regular14black05 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: CDColors.black05,
    fontStyle: FontStyle.normal,
  );

  static const regular18black03 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: CDColors.black03,
    fontStyle: FontStyle.normal,
  );

  static const bold13black03 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: CDColors.black03,
    fontStyle: FontStyle.normal,
  );

  static const bold16black01 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: CDColors.black01,
    fontStyle: FontStyle.normal,
  );

  static const bold13white01 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: CDColors.white01,
    fontStyle: FontStyle.normal,
  );

  static const regular16black01 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: CDColors.black01,
    fontStyle: FontStyle.normal,
  );

  static const regular16black02 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: CDColors.black02,
    fontStyle: FontStyle.normal,
  );

  static const regular24black01 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: CDColors.black01,
    fontStyle: FontStyle.normal,
  );

  static const regular16blue03 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: CDColors.blue03,
    fontStyle: FontStyle.normal,
  );

  static const regular13black03 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: CDColors.black03,
    fontStyle: FontStyle.normal,
  );

  static const regular14black01 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: CDColors.black01,
    fontStyle: FontStyle.normal,
  );

  static const regular14white01 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: CDColors.white01,
    fontStyle: FontStyle.normal,
  );

  static const regular14white02 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: CDColors.white02,
    fontStyle: FontStyle.normal,
  );

  static const regular14black03 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: CDColors.black03,
    fontStyle: FontStyle.normal,
  );

  static const regular14blue03 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: CDColors.blue03,
    fontStyle: FontStyle.normal,
  );

  static const bold14black03underline = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: CDColors.black03,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.underline,
  );
  static const bold14black01 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: CDColors.black01,
    fontStyle: FontStyle.normal,
  );

  static const regular14black04 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: CDColors.black04,
    fontStyle: FontStyle.normal,
  );
  static const bold14blue03 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: CDColors.blue03,
    fontStyle: FontStyle.normal,
  );

  static const bold14blue04 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: CDColors.blue04,
    fontStyle: FontStyle.normal,
  );

  static const regular13black01 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: CDColors.black01,
    fontStyle: FontStyle.normal,
  );

  static const regular16black03 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: CDColors.black03,
    fontStyle: FontStyle.normal,
  );

  static const regular17black01 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: CDColors.black01,
    fontStyle: FontStyle.normal,
  );

  static const regular17black04 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: CDColors.black04,
    fontStyle: FontStyle.normal,
  );

  static const regular17blue03 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: CDColors.blue03,
    fontStyle: FontStyle.normal,
  );

   static const regular17blue04 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: CDColors.blue04,
    fontStyle: FontStyle.normal,
  );

  static const bold17white02 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: CDColors.white02,
    fontStyle: FontStyle.normal,
  );

  static const bold18black01 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: CDColors.black01,
    fontStyle: FontStyle.normal,
  );

  static const bold18blue03 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: CDColors.blue03,
    fontStyle: FontStyle.normal,
  );

  static const bold16blue03 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: CDColors.blue03,
    fontStyle: FontStyle.normal,
  );

  static const bold20black01 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: CDColors.black01,
    fontStyle: FontStyle.normal,
  );

  static const bold24black01 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: CDColors.black01,
    fontStyle: FontStyle.normal,
  );

  static const bold24blue04 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: CDColors.blue04,
    fontStyle: FontStyle.normal,
  );

  static const bold28black01 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: CDColors.black01,
    fontStyle: FontStyle.normal,
  );

  static const bold32Blue03 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: CDColors.blue03,
    fontStyle: FontStyle.normal,
  );

  static const bold32Black01 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: CDColors.black01,
    fontStyle: FontStyle.normal,
  );

  static const medium10black05 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: CDColors.black05,
    fontStyle: FontStyle.normal,
  );

  static const medium12blue03 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: CDColors.blue03,
    fontStyle: FontStyle.normal,
  );

  static const bold12white02 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: CDColors.white02,
    fontStyle: FontStyle.normal,
  );

  static const bold12black05 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: CDColors.black05,
    fontStyle: FontStyle.normal,
  );

  static const bold14white02 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: CDColors.white02,
    fontStyle: FontStyle.normal,
  );

  static const bold24white02 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: CDColors.white02,
    fontStyle: FontStyle.normal,
  );
}
