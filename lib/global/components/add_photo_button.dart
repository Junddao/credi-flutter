import 'package:flutter/material.dart';

class AddPhotoButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddPhotoButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: 52,
          height: 52,
          child: FlatButton(
            onPressed: onPressed,
            padding: EdgeInsets.zero,
            child: Image.asset(
              "assets/icons/bt_add.png",
            ),
          ),
        ),
        // RoundButton(
        //   text: "+",
        //   press: () {
        //     showChoiceDialog(context);
        //   },
        // ),
      ),
    );
  }
}
