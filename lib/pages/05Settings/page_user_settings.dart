import 'dart:core';

import 'package:crediApp/generated/locale_keys.g.dart';
import 'package:crediApp/global/models/config_model.dart';
import 'package:crediApp/global/models/user/user_type_model.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:crediApp/global/singleton.dart';
import 'package:crediApp/global/components/cdbutton.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../global/constants.dart';
import '../../global/helperfunctions.dart';
import '../../global/network/auth.dart';
import '../../global/util.dart';

import '../../pages/04-1Chat/page_chat_detail.dart';
import '../../pages/05Settings/cell_avatar_name.dart';

class PageUserSettings extends StatefulWidget {
  @override
  _PageUserSettingsState createState() => _PageUserSettingsState();
}

class _PageUserSettingsState extends State<PageUserSettings> {
  AuthMethods authMethods = new AuthMethods();
  bool isRequester = false;
  // String userType = Singleton.shared.userData!.user!.userType!;
  bool isNotificationEnabled = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Add code after super
    Future.microtask(() {
      context
          .read(firebaseAnalyticsNotifier)
          .sendAnalyticsEvent('PageUserSetting');
    });
    print(Singleton.shared.userData!.userId);
  }

  @override
  Widget build(BuildContext context) {
    logger.i(this.runtimeType);
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      body: Consumer(
        builder: (_, watch, widget) {
          //변경사항 감지
          watch(userNotifier);
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    children: [
                      CellProfile(),
                      Divider(),
                      InkWell(
                        onTap: onLoadMyReqeust,
                        child: Container(
                          height: 40,
                          child: Row(children: [
                            Text(
                              "요청 내역 불러오기",
                              style: CDTextStyle.regular16black01,
                            )
                          ]),
                        ),
                      ),
                      Divider(),
                      InkWell(
                        onTap: onSupport,
                        child: Container(
                          height: 40,
                          child: Row(children: [
                            Text(
                              "고객센터",
                              style: CDTextStyle.regular16black01,
                            )
                          ]),
                        ),
                      ),
                      Divider(),
                      InkWell(
                        onTap: onServiceTerms,
                        child: Container(
                          height: 40,
                          child: Row(children: [
                            Text(
                              "서비스 이용약관",
                              style: CDTextStyle.regular16black01,
                            )
                          ]),
                        ),
                      ),
                      Divider(),
                      InkWell(
                        onTap: onPrivacyTerms,
                        child: Container(
                          height: 40,
                          child: Row(children: [
                            Text(
                              "개인정보 취급방침",
                              style: CDTextStyle.regular16black01,
                            )
                          ]),
                        ),
                      ),
                      Divider(),
                      buildVersionInfo(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: CDColors.white01,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('(주)크레디코퍼레이션',
                            style: CDTextStyle.regular11black01),
                        SizedBox(height: 20),
                        Text('대표이사 : 이지훈', style: CDTextStyle.regular9black03),
                        SizedBox(height: 5),
                        Text('개인정보관리책임자 : 김우린',
                            style: CDTextStyle.regular9black03),
                        SizedBox(height: 5),
                        Text('사업자등록번호 : 550-88-01957',
                            style: CDTextStyle.regular9black03),
                        SizedBox(height: 5),
                        Text('통신판매업신고번호 : 2021-서울종로-1408',
                            style: CDTextStyle.regular9black03),
                        SizedBox(height: 5),
                        Text(
                            '고객센터 : ${context.read(systemNotifier).systemConfigData!.phoneNumber!}',
                            style: CDTextStyle.regular9black03),
                        SizedBox(height: 5),
                        Text('이메일 : hello@credi.co.kr',
                            style: CDTextStyle.regular9black03),
                        SizedBox(height: 5),
                        Text(
                            '주소 :  ${context.read(systemNotifier).systemConfigData!.address!}',
                            style: CDTextStyle.regular9black03),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: CDColors.nav_title),
      backgroundColor: Colors.white,
      elevation: 1,
      centerTitle: true,
      title: Text("내정보", style: CDTextStyle.nav),
    );
  }

  buildVersionInfo() {
    print('버전 가져요기');
    return FutureBuilder(
        future: _version(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              //error가 발생하게 될 경우 반환하게 되는 부분
              // logger.v("error : ${snapshot.error}");
              return Container();
              // return Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Text(
              //     'Error: ${snapshot.error}',
              //     style: TextStyle(fontSize: 15),
              //   ),
              // );
            } else {
              // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
              logger.v("snapshot : $snapshot");
              return InkWell(
                child: Container(
                  height: 40,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "앱버젼 ",
                                style: CDTextStyle.regular16black01,
                              ),
                              TextSpan(
                                text: snapshot.data,
                                style: CDTextStyle.regular16blue03,
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
              );
            }
          }
          //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
          return CircularProgressIndicator();
        });
  }

  Future<String> _version() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // String appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    // String buildNumber = packageInfo.buildNumber;
    return "$version";
  }

  onSupport() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: buildBottomSheet,
        backgroundColor: Colors.transparent);
  }

  onPrivacyTerms() {
    launch(ConfigModel().termUrl);
  }

  onServiceTerms() {
    launch(ConfigModel().privatePolicyUrl);
  }

  createChatRoomAndStartConversation(
      {BuildContext? context, int? otherUserId}) async {
    if (otherUserId == Singleton.shared.userData!.userId) {
      return;
    }
    String chatRoomId =
        getChatRoomId(otherUserId!, Singleton.shared.userData!.userId!);
    List<int?> users = [otherUserId, Singleton.shared.userData!.userId!];
    Map<String, dynamic> chatRoomMap = {
      "user": users,
      "chat_room_id": chatRoomId
    };

    logger.i("chat with : $otherUserId");
    await Navigator.of(context!).pushNamed('PageChatDetail',
        arguments: [otherUserId, 0, 0]).then((value) async {
      context.read(chatListNotifier).chatGetNewMessageCount();
    });
  }

  Widget buildBottomSheet(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: CDColors.white02,
      ),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/icons/help_circle.png'),
            SizedBox(
              height: 30,
            ),
            Text(
              LocaleKeys.customer_center_help_title.tr(),
              style: CDTextStyle.regular24black01,
            ),
            SizedBox(height: 20),
            Text(LocaleKeys.customer_center_help_subtitle.tr(),
                style: CDTextStyle.regular13black03),
            SizedBox(height: 20),
            Text(LocaleKeys.customer_center_work_time.tr(),
                style: CDTextStyle.regular13black03),
            SizedBox(height: 20),
            CDButton(
              width: MediaQuery.of(context).size.width - 48,
              text: "채팅 상담",
              press: onChatPress,
            ),
            SizedBox(height: 20),
            CDButton(
              width: MediaQuery.of(context).size.width - 48,
              text: "전화 상담",
              press: onCallPress,
            ),
            SizedBox(height: 20),
            Center(
              child: TextButton(
                child: Text(
                  '닫기',
                  style: CDTextStyle.regular18black03,
                ),
                onPressed: onClosePress,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onChatPress() async {
    createChatRoomAndStartConversation(
      context: _scaffoldKey.currentContext,
      otherUserId: ConfigModel().crediId,
    );
  }

  void onCallPress() async {
    if (await canLaunch(
        'tel:' + context.read(systemNotifier).systemConfigData!.phoneNumber!)) {
      await launch(
          'tel:' + context.read(systemNotifier).systemConfigData!.phoneNumber!);
    } else {
      throw 'Could not launch ${'tel:' + context.read(systemNotifier).systemConfigData!.phoneNumber!}';
    }
  }

  void onClosePress() async {
    Navigator.of(context).pop();
  }

  void onLoadMyReqeust() {
    Navigator.of(context).pushNamed('PageUserLoadMyRequest');
  }
}
