import 'dart:io';

import 'package:crediApp/generated/locale_keys.g.dart';
import 'package:crediApp/global/models/system/system_config.dart';
import 'package:crediApp/route.dart';
import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/helperfunctions.dart';
import 'package:crediApp/global/models/config_model.dart';
import 'package:crediApp/global/models/user/user_model.dart';
import 'package:crediApp/global/models/user/user_response_model.dart';
import 'package:crediApp/global/network/auth.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:crediApp/global/singleton.dart';
import 'package:crediApp/global/util.dart';
import 'package:crediApp/global/components/cdbutton.dart';
import 'package:crediApp/global/components/plain_text_field.component.dart';
import 'package:crediApp/pages/00Intro/Intro/components/custom_sign_in_with_apple.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart' as kakao;
import 'package:kakao_flutter_sdk/user.dart' as kakaoUser;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

class PageLogin extends StatefulWidget {
  @override
  _PageLoginState createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tecEmail;
  late TextEditingController _tecPassword;

  @override
  void initState() {
    _tecEmail = new TextEditingController();
    _tecPassword = new TextEditingController();
    Future.microtask(() {
      return showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: buildBottomSheet,
          backgroundColor: Colors.transparent);
    });

    super.initState();
  }

  @override
  void dispose() {
    _tecEmail.dispose();
    _tecPassword.dispose();
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
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(LocaleKeys.wait.tr(),
                style: TextStyle(fontSize: 36, color: CDColors.blue03)),
            SizedBox(
              height: 20,
            ),
            Text(
              LocaleKeys.login_banner_title.tr(),
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 50,
            ),
            CDButton(
              width: MediaQuery.of(context).size.width - 48,
              text: LocaleKeys.contact_service_center.tr(),
              press: onCallPress,
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: TextButton(
                child: Text(
                  LocaleKeys.close_forever.tr(),
                  style: TextStyle(
                      fontSize: 18,
                      color: CDColors.black03,
                      fontWeight: FontWeight.w400),
                ),
                onPressed: onClosePress,
              ),
            ),
          ],
        ),
      ),
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final node = FocusScope.of(context);
    return Scaffold(
      appBar: _buildAppBar(),
      body: Builder(
        builder: (context) => Container(
          // color: CDColors.primary,
          width: size.width,
          height: size.height,
          child: isLoading
              ? Center(
                  child: Container(
                    child: CircularProgressIndicator(),
                  ),
                )
              : GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    unfocusKeyboard(context);
                  },
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // const SizedBox(height: 100),
                            // Hero(
                            //   tag: 'logo',
                            //   child: Image.asset(
                            //     "assets/icons/ic_logo_text.png",
                            //     width: 209,
                            //     height: 50,
                            //   ),
                            // ),
                            const SizedBox(height: 80),
                            PlainTextField(
                              controller: _tecEmail,
                              hintText: LocaleKeys.email.tr(),
                              textInputAction: TextInputAction.next,
                              onChanged: (value) {},
                              onEditingComplete: () => node.nextFocus(),
                              validator: (val) {
                                return val == null ||
                                        !RegExp(Constants.emailRegex)
                                            .hasMatch(val)
                                    ? LocaleKeys.check_email.tr()
                                    : null;
                              },
                            ),
                            const SizedBox(height: 8),
                            PlainTextField(
                              controller: _tecPassword,
                              hintText: LocaleKeys.password.tr(),
                              showSecure: true,
                              isSecure: true,
                              onChanged: (value) {},
                              onEditingComplete: () => onLogin(context),
                              validator: (value) {
                                return value == null || value.length > 5
                                    ? null
                                    : LocaleKeys.check_password.tr();
                              },
                            ),
                            const SizedBox(height: 8),
                            Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: InkWell(
                                onTap: () {
                                  logger.i("TODO");
                                  // TODO
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) {
                                  //       return LoginScreen();
                                  //     },
                                  //   ),
                                  // );
                                },
                                child: Text(
                                  LocaleKeys.forgot_password.tr(),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),

                            const SizedBox(height: 48),
                            CDButton(
                              width: size.width - 40,
                              text: LocaleKeys.login.tr(),
                              press: () {
                                onLogin(context);
                              },
                            ),
                            CDButton(
                              width: size.width - 40,
                              type: ButtonType.transparent,
                              text: LocaleKeys.sign_up.tr(),
                              press: () => Routers.loadSignUpWithEmail(context),
                            ),
                            Divider(color: CDColors.divider),
                            const SizedBox(height: 8),
                            const SizedBox(height: 8),

                            _buildNaverLogin(context),
                            const SizedBox(height: 8),
                            _buildKakaoLogin(context),
                            const SizedBox(height: 8),
                            if (Platform.isIOS)
                              Column(
                                children: [
                                  _buildAppleLogin(context),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            const SizedBox(height: 30),
                            Text(
                              LocaleKeys.service_center.tr(),
                              style: CDTextStyle.regularFont(
                                fontSize: 14,
                                color: CDColors.black03,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              context
                                  .read(systemNotifier)
                                  .systemConfigData!
                                  .phoneNumber!,
                              style: CDTextStyle.boldFont(
                                fontSize: 18,
                                color: CDColors.black03,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
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

  _buildAppleLogin(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width - 40,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.black,
      ),
      clipBehavior: Clip.hardEdge,
      child: SignInWithAppleButton(
        text: LocaleKeys.apple_login.tr(),
        iconAlignment: IconAlignment.left,
        onPressed: () => _loginWithApple(),
      ),
    );
  }

  _buildKakaoLogin(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () => _loginWithKakao(),
      child: Container(
        width: size.width - 40,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.yellow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 22),
            Image.asset(
              "assets/icons/ic_logo_kakao.png",
              width: 24,
              height: 24,
            ),
            Spacer(),
            Text(
              LocaleKeys.kakao_login.tr(),
              style: CDTextStyle.button.copyWith(color: Colors.black54),
            ),
            Spacer(),
            const SizedBox(width: 24),
            const SizedBox(width: 22),
          ],
        ),
      ),
    );
  }

  _buildNaverLogin(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () => _loginWithNaver(),
      child: Container(
        width: size.width - 40,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Color(0xff03c75a),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 22),
            Image.asset(
              "assets/icons/ic_logo_naver.png",
              width: 24,
              height: 24,
            ),
            Spacer(),
            Text(
              LocaleKeys.naver_login.tr(),
              style: CDTextStyle.button.copyWith(color: Colors.white),
            ),
            Spacer(),
            const SizedBox(width: 24),
            const SizedBox(width: 22),
          ],
        ),
      ),
    );
  }

  unfocusKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  onLogin(BuildContext context) {
    unfocusKeyboard(context);
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(LocaleKeys.check_email_password.tr()),
      ));
      return;
    }

    HelperFunctions.saveUserEmail(_tecEmail.text);

    setState(() {
      isLoading = true;
    });
    authMethods
        .signInWithEmailAndPassword(_tecEmail.text.trim(), _tecPassword.text)
        .catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$onError'),
      ));
      _stopLoading();
    }).then((result) async {
      if (result!.user!.emailVerified == true) {
        // 등록된 유저
        UserResponseData? userResponseData =
            await context.read(userNotifier).getUser();

        Singleton.shared.userData = userResponseData;
        if (Singleton.shared.userData?.user!.email == "hello@credi.co.kr") {
          Singleton.shared.userData!.userId = ConfigModel().crediId;
        }

        await HelperFunctions.saveUserId(userResponseData!.userId);
        HelperFunctions.saveUserDataInfo(Singleton.shared.userData!);
        _stopLoading();
        if (Singleton.shared.userData!.user!.name == "") {
          HelperFunctions.saveLoggedIn(false);
          Routers.loadSignUpWithEmail(context);
        } else {
          HelperFunctions.saveLoggedIn(true);
          Routers.loadMain(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(LocaleKeys.use_after_email_verify.tr()),
        ));
        _stopLoading();
      }
    });
  }

  Future showVerifyEmailDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          content: Container(
            child: Text(LocaleKeys.sent_email.tr()),
          ),
          actions: [
            FlatButton(
              child: Text(LocaleKeys.confirm.tr()),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            )
          ],
        );
      },
    );
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
