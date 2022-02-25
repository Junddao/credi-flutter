import 'package:crediApp/global/theme.dart';
import 'package:flutter/material.dart';

class DeletePhotoButton extends StatelessWidget {
  const DeletePhotoButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "사진삭제",
              style: CDTextStyle.regularFont(
                fontSize: 14,
                color: CDColors.black02.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
