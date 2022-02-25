import 'dart:io';

import 'package:crediApp/generated/locale_keys.g.dart';
import 'package:crediApp/global/theme.dart';
import 'package:crediApp/global/components/cdbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class VersionPage extends StatefulWidget {
  const VersionPage({Key? key}) : super(key: key);

  @override
  _VersionPageState createState() => _VersionPageState();
}

class _VersionPageState extends State<VersionPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Padding(
        padding: const EdgeInsets.all(24),
        child: CDButton(
          width: MediaQuery.of(context).size.width - 48,
          text: LocaleKeys.go_to_update.tr(),
          type: ButtonType.dark,
          press: () {
            openStoreUrl();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/icons/attention.png'),
            SizedBox(
              height: 24,
            ),
            Text(LocaleKeys.new_version_title.tr(),
                style: CDTextStyle.bold20black01),
            SizedBox(height: 24),
            Text(
              LocaleKeys.new_version_contents.tr(),
              style: CDTextStyle.regular16black03.merge(TextStyle(height: 1.5)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void goToMain(context) {
    Navigator.pushNamedAndRemoveUntil(context, 'PageIntro', (route) => false);
  }

  void openStoreUrl() {
    if (Platform.isIOS) {
      _launchURL(
          'https://apps.apple.com/kr/app/%ED%81%AC%EB%A0%88%EB%94%94-%EB%A7%8C%EB%93%A6%EC%9D%B4-%EC%9D%B4%EC%96%B4%EC%A7%80%EB%8A%94-%EA%B3%B3/id1545831858');
    } else {
      _launchURL(
          'https://play.google.com/store/apps/details?id=com.credi.crediapp');
    }
  }

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
}
