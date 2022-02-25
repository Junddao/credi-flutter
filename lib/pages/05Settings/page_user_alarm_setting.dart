import 'dart:io';

import 'package:crediApp/global/components/cdbutton.dart';
import 'package:crediApp/global/components/common_dialog.dart';
import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/models/user/user_request_model.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:crediApp/global/singleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageUserAlarmSetting extends StatefulWidget {
  const PageUserAlarmSetting({Key? key}) : super(key: key);

  @override
  _PageUserAlarmSettingState createState() => _PageUserAlarmSettingState();
}

class _PageUserAlarmSettingState extends State<PageUserAlarmSetting> {
  bool _pushAlarmToggle = true;
  bool _smsAlarmToggle = true;
  bool _emailAlarmToggle = true;

  @override
  void initState() {
    _pushAlarmToggle = Singleton.shared.userData!.user!.pushEnabled!;
    _smsAlarmToggle = Singleton.shared.userData!.user!.smsEnabled!;
    _emailAlarmToggle = Singleton.shared.userData!.user!.emailEnabled!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      bottomSheet: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
          child: CDButton(
            width: size.width - 40,
            text: "저장",
            press: onSave,
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      iconTheme: IconThemeData(color: CDColors.nav_title),
      elevation: 1,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Text('알림설정', style: CDTextStyle.nav),
    );
  }

  Widget _body() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultHorizontalPadding,
            vertical: kDefaultVerticalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              //
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          '견적 요청 진행 상황, 이벤트 등\n알림을 받아보세요!',
                          style: CDTextStyle.bold18black01.merge(
                            TextStyle(height: 1.6),
                          ),
                        ),
                        SizedBox(height: 50),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SwitchListTile(
              title: Text(
                '앱 푸시 알림',
                style: CDTextStyle.regular16black01,
              ),
              onChanged: (bool value) {
                setState(() {
                  if (Platform.isIOS) {
                    CommonDialog.oneButtonDialog(
                      context,
                      '푸시 알림 동의 안내',
                      '환경 설정에서 푸시 상태를 변경해 주세요.',
                    );
                  }

                  _pushAlarmToggle = value;
                });
              },
              value: _pushAlarmToggle,
            ),
            SwitchListTile(
              title: Text(
                'SMS 알림',
                style: CDTextStyle.regular16black01,
              ),
              onChanged: (bool value) {
                setState(() => _smsAlarmToggle = value);
              },
              value: _smsAlarmToggle,
            ),
            SwitchListTile(
              title: Text(
                '이메일 알림',
                style: CDTextStyle.regular16black01,
              ),
              onChanged: (bool value) {
                setState(() => _emailAlarmToggle = value);
              },
              value: _emailAlarmToggle,
            ),
            // 하단 버튼 사이즈 만큼 공백 추가.
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }

  void onSave() async {
    Singleton.shared.userData!.user = Singleton.shared.userData!.user!.copyWith(
      pushEnabled: _pushAlarmToggle,
      smsEnabled: _smsAlarmToggle,
      emailEnabled: _emailAlarmToggle,
    );

    context
        .read(userNotifier)
        .setUser(UserRequest(user: Singleton.shared.userData!.user!))
        .then((value) async {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("저장되었습니다."),
        ),
      );

      Navigator.pop(context);
    });
  }
}
