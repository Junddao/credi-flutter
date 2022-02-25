import 'dart:async';
import 'dart:convert';

import 'package:crediApp/env/environment.dart';
import 'package:crediApp/generated/locale_keys.g.dart';
import 'package:crediApp/global/models/system/system_config.dart';
import 'package:crediApp/route.dart';
import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/helperfunctions.dart';
import 'package:crediApp/global/models/config_model.dart';
import 'package:crediApp/global/models/user/user_response_model.dart';
import 'package:crediApp/global/network/auth.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:crediApp/global/singleton.dart';
import 'package:crediApp/global/util.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:package_info/package_info.dart';
import 'package:easy_localization/easy_localization.dart';

class PageIntro extends StatefulWidget {
  @override
  _PageIntroState createState() => _PageIntroState();
}

class _PageIntroState extends State<PageIntro> {
  late BuildContext _context;
  // StreamSubscription? streamUserSubscription;

  @override
  void initState() {
    super.initState();

    checkAppVersion().then(
      (result) async {
        // 전화번호, 주소 받아오기.
        await context.read(systemNotifier).getSystemConfig();
        if (result == false) {
          Navigator.of(context).pushNamed('VersionPage');
        } else {
          String? myToken = await HelperFunctions.readToken();

          // 화면 loading 씨간
          Future.delayed(Duration(seconds: 1));

          // token 없으면 login
          if (myToken == '') {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('PagePreview', (route) => false);
          } else {
            UserResponseData? userResponseData =
                await context.read(userNotifier).getUser().catchError(
              (onError) {
                // 토큰 만료시 login 화면으로 이동
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('PagePreview', (route) => false);
              },
            );

            Singleton.shared.setUser(userResponseData!).then((result) {
              if (Singleton.shared.userData == null) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('PagePreview', (route) => false);
              } else {
                Routers.loadMain(context);
              }
            });
          }
        }
      },
    );
  }

  Future<bool?> checkAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    //버전 확인
    String? serverMinVersion =
        await context.read(systemNotifier).getAppVersion();
    List<String> splitServerMinVersion = serverMinVersion!.split('.');
    List<String> splitMyVersion = packageInfo.version.split('.');

    for (int i = 0; i < splitMyVersion.length; i++) {
      Logger().d(
          'serverMinVersion : ${splitServerMinVersion[i]} , myVersion : ${splitMyVersion[i]}');
      if (int.parse(splitServerMinVersion[i]) > int.parse(splitMyVersion[i])) {
        return false;
      }
    }

    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> readConfigFile() async {
    var configJson;
    if (Environment.buildType == BuildType.dev) {
      configJson = await rootBundle.loadString('assets/texts/config_dev.json');
    } else {
      configJson = await rootBundle.loadString('assets/texts/config_live.json');
    }

    print(configJson);
    final configObject = jsonDecode(configJson);
    ConfigModel().fromJson(configObject);
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: CDColors.blue5,
        child: Stack(
          children: [
            //
            Positioned(
              top: 166,
              left: 35,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/icons/intro_title.png'),
                    SizedBox(height: 20),
                    Image.asset('assets/icons/text_credi.png'),
                  ],
                ),
              ),
            ),
            // Positioned(
            //   top: 286,
            //   left: size.width * 0.5 + 63 + 4,
            //   child: Align(
            //     alignment: Alignment.bottomLeft,
            //     child: Container(
            //       width: 10,
            //       height: 10,
            //       child: Image.asset("assets/icons/ic_comma.png"),
            //     ),
            //   ),
            // ),
            Positioned(
              bottom: 61,
              left: 0,
              right: 0,
              child: Container(
                width: 60,
                height: 32,
                child: Image.asset("assets/icons/ic_logo.png"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
