import 'package:crediApp/generated/locale_keys.g.dart';
import 'package:crediApp/global/components/cdbutton.dart';
import 'package:crediApp/global/theme.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:easy_localization/easy_localization.dart';

class CommonDialog {
  static Future<void> oneButtonDialog(
      BuildContext context, String title, String content) async {
    await showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: CDTextStyle.bold24blue04),
                  SizedBox(height: 15),
                  Text(content, style: CDTextStyle.regular14black03),
                  SizedBox(height: 15),
                  CDButton(
                    width: double.infinity,
                    text: LocaleKeys.close.tr(),
                    press: () {
                      Navigator.pop(dialogContext);
                    },
                    type: ButtonType.transparent,
                  ),
                ],
              ),
            ),
          );
        });
  }

  static Future<void> orderRequestDialog(
      BuildContext context,
      String title,
      String content,
      String productName,
      String finishDate,
      Function onConfirm,
      Function onClose) async {
    await showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: CDTextStyle.bold24blue04),
                  SizedBox(height: 15),
                  Text(content, style: CDTextStyle.regular14black03),
                  SizedBox(height: 10),
                  Text(LocaleKeys.product_name.tr(),
                      style: CDTextStyle.regular14black01),
                  SizedBox(height: 10),
                  Text(productName, style: CDTextStyle.regular14black03),
                  SizedBox(height: 15),
                  Text(LocaleKeys.finish_date.tr(),
                      style: CDTextStyle.regular14black01),
                  SizedBox(height: 10),
                  Text(finishDate, style: CDTextStyle.regular14black03),
                  SizedBox(height: 15),
                  CDButton(
                    width: double.infinity,
                    text: LocaleKeys.confirm.tr(),
                    press: () {
                      Navigator.pop(dialogContext);
                      onConfirm();
                    },
                  ),
                  SizedBox(height: 10),
                  CDButton(
                    width: double.infinity,
                    text: LocaleKeys.close.tr(),
                    press: () {
                      Navigator.pop(dialogContext);
                      onClose();
                    },
                    type: ButtonType.transparent,
                  ),
                ],
              ),
            ),
          );
        });
  }

  static Future<bool> requestCameraPermission(BuildContext context) async {
    PermissionStatus status = await Permission.camera.request();
    if (!status.isGranted) {
      // 허용이 안된 경우
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("권한 설정을 확인해주세요."),
              actions: [
                TextButton(
                    onPressed: () {
                      openAppSettings(); // 앱 설정으로 이동
                    },
                    child: Text('설정하기')),
              ],
            );
          });
      return false;
    }
    return true;
  }

  static Future<bool> requestPhotoPermission(BuildContext context) async {
    PermissionStatus status = await Permission.photos.request();
    if (!status.isGranted) {
      // 허용이 안된 경우
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("권한 설정을 확인해주세요."),
            actions: [
              TextButton(
                  onPressed: () {
                    openAppSettings(); // 앱 설정으로 이동
                  },
                  child: Text('설정하기')),
            ],
          );
        },
      );
      return false;
    }
    return true;
  }

  static Future<bool> requestStoragePermission(BuildContext context) async {
    PermissionStatus status = await Permission.storage.request();
    if (!status.isGranted) {
      // 허용이 안된 경우
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("권한 설정을 확인해주세요."),
            actions: [
              TextButton(
                  onPressed: () {
                    openAppSettings(); // 앱 설정으로 이동
                  },
                  child: Text('설정하기')),
            ],
          );
        },
      );
      return false;
    }
    return true;
  }

  static Future<bool> checkAppVersionDialog(BuildContext context) async {
    bool result = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('업데이트 후 사용할 수 있습니다.'),
          actions: [
            TextButton(
                onPressed: () {
                  result = true;
                  // Navigator.of(context).pop(true);
                },
                child: Text('스토어로 이동')),
          ],
        );
      },
    );
    return true;
  }
}
