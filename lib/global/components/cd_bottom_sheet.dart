import 'package:crediApp/generated/locale_keys.g.dart';
import 'package:crediApp/global/components/cdbutton.dart';
import 'package:crediApp/global/style/cdcolors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CDBottomSheet {
  CrossAxisAlignment? _crossAxisAlignment;
  String? _mainIcon;
  String? _title;
  String? _buttonTitle;
  Function? _function;
  Future<dynamic> getMyBottomSheet({
    BuildContext? context,
    CrossAxisAlignment? crossAxisAlignment,
    String? mainIcon,
    String? title,
    String? buttonTitle,
    Function? function,
  }) async {
    _crossAxisAlignment = crossAxisAlignment;
    _mainIcon = mainIcon;
    _title = title;
    _buttonTitle = buttonTitle;
    _function = function!;

    return showModalBottomSheet(
        context: context!,
        isScrollControlled: true,
        builder: buildBottomSheet,
        backgroundColor: Colors.transparent);
  }

  Widget buildBottomSheet(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: CDColors.white02,
      ),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: _crossAxisAlignment ?? CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              _mainIcon!,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              _title!,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 50,
            ),
            CDButton(
              width: double.infinity,
              text: _buttonTitle!,
              press: _function!,
              type: ButtonType.dark,
            ),
            SizedBox(height: 10),
            CDButton(
              width: double.infinity,
              text: LocaleKeys.close.tr(),
              type: ButtonType.transparent,
              press: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
