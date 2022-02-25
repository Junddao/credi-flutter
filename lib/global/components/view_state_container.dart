import 'package:crediApp/global/style/cdcolors.dart';
import 'package:crediApp/global/util.dart';
import 'package:flutter/material.dart';

class ViewStateContainer {
  static Widget busyContainer() {
    return Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        backgroundColor: CDColors.blue5,
      ),
    );
  }

  static Widget errorContainer() {
    return Container(
      child: Center(
        child: Text('error'),
      ),
    );
  }
}
