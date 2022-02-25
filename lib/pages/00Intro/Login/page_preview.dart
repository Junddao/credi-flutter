import 'dart:io';

import 'package:crediApp/generated/locale_keys.g.dart';
import 'package:crediApp/global/components/cdbutton.dart';
import 'package:crediApp/global/components/plain_text_field.component.dart';
import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/helperfunctions.dart';
import 'package:crediApp/global/models/config_model.dart';
import 'package:crediApp/global/models/user/user_model.dart';
import 'package:crediApp/global/models/user/user_response_model.dart';
import 'package:crediApp/global/network/auth.dart';

import 'package:crediApp/global/providers/providers.dart';
import 'package:crediApp/global/providers/tabstates.dart';
import 'package:crediApp/global/singleton.dart';
import 'package:crediApp/global/util.dart';
import 'package:crediApp/pages/00Intro/Intro/components/custom_sign_in_with_apple.dart';
import 'package:crediApp/pages/01Home/page_home.dart';
import 'package:crediApp/route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/all.dart' as kakao;
import 'package:kakao_flutter_sdk/user.dart' as kakaoUser;

class PagePreview extends StatefulWidget {
  @override
  _PagePreviewState createState() => _PagePreviewState();
}

class _PagePreviewState extends State<PagePreview> {
  int _selectedIndex = 0;
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();

  List _pages = [
    PageHome(
      isPreview: true,
    ),
    Container(),
    Container(),
    Container(),
    Container(),
  ];

  @override
  void initState() {
    // Future.microtask(() {
    //   return showModalBottomSheet(
    //       context: context,
    //       isScrollControlled: true,
    //       builder: buildBottomSheet,
    //       backgroundColor: Colors.transparent);
    // });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildBottomSheet(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: CDColors.white02,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultHorizontalPadding,
            vertical: kDefaultVerticalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
            ),
            Text('로그인', style: CDTextStyle.bold24black01),
            SizedBox(
              height: 50,
            ),
            Container(
              width: MediaQuery.of(context).size.width -
                  kDefaultHorizontalPadding * 2,
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed('PageLogin');
                            },
                            child: Image.asset(
                                'assets/icons/email_login_button.png')),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: InkWell(
                            onTap: () {
                              _loginWithKakao();
                            },
                            child: Image.asset(
                                'assets/icons/kakao_login_button.png')),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: InkWell(
                            onTap: () {
                              _loginWithNaver();
                            },
                            child: Image.asset(
                                'assets/icons/naver_login_button.png')),
                      ),
                      Platform.isAndroid
                          ? SizedBox.shrink()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: InkWell(
                                  onTap: () {
                                    _loginWithApple();
                                  },
                                  child: Image.asset(
                                      'assets/icons/apple_login_button.png')),
                            ),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: TextButton(
                child: Text(
                  '이메일로 회원가입',
                  style: CDTextStyle.regular17blue04,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('PageSignUp');
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: TextButton(
                child: Text(
                  '둘러보기',
                  style: TextStyle(
                      fontSize: 18,
                      color: CDColors.black03,
                      fontWeight: FontWeight.w400),
                ),
                onPressed: onClosePress,
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  void onClosePress() async {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Consumer(builder: (_, watch, __) {
        TabStates tabStatesProvider = watch(tabProvider);
        _selectedIndex = tabStatesProvider.selectedIndex;
        return Scaffold(
          // extendBody: true,
          body: _body(),
          bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: _bottomNavigationBar(tabStatesProvider)),
          floatingActionButton: Container(
            height: 100,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(
                  top: 25,
                  left: SizeConfig.screenWidth / 2 - 30,
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: buildBottomSheet,
                          backgroundColor: Colors.transparent);
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: CDColors.blue03,
                      child: Icon(Icons.add, size: 36, color: CDColors.white02),
                    ),
                  ),
                ),
              ],
            ),
          ),

          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      }),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: CDColors.nav_title),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Text(LocaleKeys.login.tr(), style: CDTextStyle.nav),
    );
  }

  Widget _body() {
    // if (_selectedIndex == 2) {
    //   _selectedIndex = 0;
    // }
    return isLoading
        ? Center(
            child: Container(
              child: CircularProgressIndicator(),
            ),
          )
        : _pages[_selectedIndex];
  }

  _bottomNavigationBar(TabStates tabStatesProvider) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      backgroundColor: CDColors.white02,

      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      onTap: (index) {
        _onItemTapped(index, tabStatesProvider);
      },
      items: [
        BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/icons/ic_home.png"),
              size: 28,
            ),
            label: '홈'),
        BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/icons/ic_folder.png"),
              size: 28,
            ),
            label: '견적요청'),
        BottomNavigationBarItem(icon: SizedBox.shrink(), label: ''),
        BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/icons/ic_message.png"),
              size: 28,
            ),
            label: '메세지'),
        BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/icons/ic_person.png"),
              size: 28,
            ),
            label: '내정보'),
      ],
      selectedFontSize: 11,
      unselectedFontSize: 11,
      selectedItemColor: CDColors.blue03,
      unselectedItemColor: CDColors.black04,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    );
  }

  void _onItemTapped(int index, TabStates tabStatesProvider) async {
    // 혹시라도 아래 탭 누르면 그냥 안옮김.
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: buildBottomSheet,
        backgroundColor: Colors.transparent);
  }

  _issueAccessToken(String authCode) async {
    logger.v("authCode : $authCode");
    try {
      var token = await kakao.AuthApi.instance.issueAccessToken(authCode);
      kakao.TokenManager.instance.setToken(token);
      logger.v(token.toJson());
      // Navigator.of(context).push(
      //     MaterialPageRoute(
      //       builder: (context) => Home()
      //     ));
      var user = await kakao.UserApi.instance.me();
      var email = user.kakaoAccount!.email!;
      if (user.kakaoAccount == null) {
        logger.v(user.kakaoAccount!.email);
        ScaffoldMessenger.of(context).showSnackBar((SnackBar(
          content: Text(LocaleKeys.not_exist_email.tr()),
        )));
        _stopLoading();
        return;
      }
      logger.v(user.toJson());
      final String accessToken = token.toJson()["access_token"].toString();
      // logger.v("kakao token: ${accessToken}");
      _createKakaoAccountRequest(accessToken, email);
    } catch (e) {
      logger.v(e.toString());
      ScaffoldMessenger.of(context).showSnackBar((SnackBar(
        content: Text('${e.toString()}'),
      )));
      _stopLoading();
    }
  }

  _stopLoading() {
    if (isLoading == true) {
      setState(() {
        isLoading = false;
      });
    }
  }

  _onErrorLogin(Object error) {
    _stopLoading();
    print('kakao login error');
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   content: Text('$error'),
    // ));
  }

  _createKakaoAccountRequest(String token, String email) async {
    authMethods
        .signInWithKakao(token)
        .catchError(_onErrorLogin)
        .then((result) async {
      if (result!.email == '') {
        // 신규 생성
        fb.User? fbUser = fb.FirebaseAuth.instance.currentUser;
        User _user = User(
            email: result.socialEmail, // ios에서는 fbUser의 email을 못가져옴.
            name: result.name,
            agreeTerms: result.agreeTerms);
        Singleton.shared.userData =
            UserResponseData(user: _user, userId: result.userId);

        await HelperFunctions.saveUserId(result.userId);
      } else {
        // 등록된 유저
        UserResponseData? userResponseData =
            await context.read(userNotifier).getUser();

        Singleton.shared.userData = userResponseData;

        // 강제로 이메일 넣어줌
        // Singleton.shared.userData!.user!.email = result.socialEmail;

        if (Singleton.shared.userData?.user!.email == "hello@credi.co.kr") {
          Singleton.shared.userData!.userId = ConfigModel().crediId;
        }

        await HelperFunctions.saveUserId(userResponseData!.userId);
      }
      HelperFunctions.saveUserDataInfo(Singleton.shared.userData!);

      _stopLoading();
      if (Singleton.shared.userData!.user!.name == '') {
        HelperFunctions.saveLoggedIn(false);
        Routers.loadSignUpWithSNS(context);
      } else {
        HelperFunctions.saveLoggedIn(true);
        Routers.loadMain(context);
      }
    });
  }

  _loginWithKakao() async {
    setState(() {
      isLoading = true;
    });
    try {
      final isKakaoInstalled = await kakao.isKakaoTalkInstalled();
      // var code = isKakaoInstalled
      //     ? await kakaoUser.UserApi.instance.loginWithKakaoTalk()
      //     // ? await kakao.AuthCodeClient.instance.request()
      //     : await kakaoUser.UserApi.instance.loginWithKakaoAccount();

      var code = isKakaoInstalled
          ? await kakao.AuthCodeClient.instance.requestWithTalk()
          // ? await kakao.AuthCodeClient.instance.request()
          : await kakao.AuthCodeClient.instance.request();

      await _issueAccessToken(code);
    } catch (e) {
      logger.e(e.toString());
      _stopLoading();
    }
  }

  _loginWithNaver() async {
    setState(() {
      isLoading = true;
    });
    await authMethods.signInWithNaverWeb().then((result) async {
      if (result!.email == '') {
        // 신규 생성
        fb.User? fbUser = fb.FirebaseAuth.instance.currentUser;
        User _user = User(
            email: result.socialEmail,
            name: result.name,
            agreeTerms: result.agreeTerms);
        Singleton.shared.userData =
            UserResponseData(user: _user, userId: result.userId);

        await HelperFunctions.saveUserId(result.userId);
      } else {
        // 등록된 유저
        UserResponseData? userResponseData =
            await context.read(userNotifier).getUser();

        Singleton.shared.userData = userResponseData;
        if (Singleton.shared.userData?.user!.email == "hello@credi.co.kr") {
          Singleton.shared.userData!.userId = ConfigModel().crediId;
        }

        await HelperFunctions.saveUserId(userResponseData!.userId);
      }

      HelperFunctions.saveUserDataInfo(Singleton.shared.userData!);

      _stopLoading();
      if (Singleton.shared.userData!.user!.name == '') {
        HelperFunctions.saveLoggedIn(false);
        Routers.loadSignUpWithSNS(context);
      } else {
        HelperFunctions.saveLoggedIn(true);
        Routers.loadMain(context);
      }
    });
  }

  _loginWithApple() async {
    setState(() {
      isLoading = true;
    });
    await authMethods
        .signInWithApple()
        .catchError(_onErrorLogin)
        .then((result) async {
      if (result!.email == '') {
        // 신규 생성
        fb.User? fbUser = fb.FirebaseAuth.instance.currentUser;
        User _user = User(
            email: fbUser!.email,
            name: result.name,
            agreeTerms: result.agreeTerms);
        Singleton.shared.userData =
            UserResponseData(user: _user, userId: result.userId);

        await HelperFunctions.saveUserId(result.userId);
      } else {
        // 등록된 유저
        UserResponseData? userResponseData =
            await context.read(userNotifier).getUser();

        Singleton.shared.userData = userResponseData;
        if (Singleton.shared.userData?.user!.email == "hello@credi.co.kr") {
          Singleton.shared.userData!.userId = ConfigModel().crediId;
        }

        await HelperFunctions.saveUserId(userResponseData!.userId);
      }

      HelperFunctions.saveUserDataInfo(Singleton.shared.userData!);

      _stopLoading();
      if (Singleton.shared.userData!.user!.name == "") {
        HelperFunctions.saveLoggedIn(false);
        Routers.loadSignUpWithSNS(context);
      } else {
        HelperFunctions.saveLoggedIn(true);
        Routers.loadMain(context);
      }
    });
  }
}
