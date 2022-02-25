import 'package:flutter/material.dart';
import 'package:crediApp/global/constants.dart';
import 'color_dot.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    Key? key,
    this.count,
    this.index,
  }) : super(key: key);

  final int? count;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center, children: _buildDots()),
    );
  }

  List<Widget> _buildDots() {
    final List<Widget> listDot = [];
    for (var i = 0; i < count!; i++) {
      listDot.add(
        ColorDot(
          fillColor: Color(0xFF80989A),
          isSelected: i == index,
        ),
      );
    }
    return listDot;
  }
}
