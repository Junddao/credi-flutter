import 'package:flutter/material.dart';

class PhotoPageIndicator extends StatelessWidget {
  final String text;

  const PhotoPageIndicator(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Center(
            widthFactor: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                text,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          // padding: EdgeInsets.symmetric(horizontal: 10),
          height: 28,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Color(0xB3636363),
          ),
        ),
      ),
    );
  }
}
