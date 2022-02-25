import 'package:flutter/material.dart';

/// Example of widget with padding
extension ExtendedText on Widget {
  addContainer() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      color: Colors.yellow,
      child: this,
    );
  }
}

extension ExtendedTextStyle on TextStyle {
  withColor(Color color) {
    TextStyle temp = this.merge(TextStyle(color: color));
    return temp;
  }
}
