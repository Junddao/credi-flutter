import 'package:crediApp/route.dart';
import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/helperfunctions.dart';
import 'package:crediApp/global/models/user/user_model.dart';
import 'package:crediApp/global/models/user/user_request_model.dart';
import 'package:crediApp/global/models/user/user_response_model.dart';
import 'package:crediApp/global/network/auth.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:crediApp/global/singleton.dart';
import 'package:crediApp/global/util.dart';
import 'package:crediApp/global/components/cdbutton.dart';
import 'package:crediApp/global/components/plain_text_field.component.dart';
import 'package:crediApp/pages/00Intro/Intro/background.component.dart';
import 'package:crediApp/pages/00Intro/Login/page_login.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageSignUp extends StatefulWidget {
  @override
  _PageSignUpState createState() => _PageSignUpState();
}

class _PageSignUpState extends State<PageSignUp> {
  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  final _formKey = GlobalKey<FormState>();
  // TextEditingController tecUserName = new TextEditingController();
  late TextEditingController _tecEmail;
  late TextEditingController _tecPassword;
  late TextEditingController _tecPasswordCheck;
  late TextEditingController _tecNickname;
  late TextEditingController _tecCompany;
  late TextEditingController _tecPhone;
  fb.User? firebaseUser;

  @override
  void initState() {
    _tecEmail = new TextEditingController();
    _tecPassword = new TextEditingController();
    _tecPasswordCheck = new TextEditingController();
    _tecNickname = new TextEditingController();
    _tecCompany = new TextEditingController();
    _tecPhone = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final node = FocusScope.of(context);
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Background(
        child: isLoading
            ? Center(
                child: Container(
                  child: CircularProgressIndicator(),
                ),
              )
            : GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),
                          Text(
                            "안녕하세요 의뢰인님!\n다양한 제조공장을 만나보세요.",
                            style: CDTextStyle.regularFont(fontSize: 18.0),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "제조공장 제휴 신청은 고객센터로 문의해주세요.\n고객센터 : ${context.read(systemNotifier).systemConfigData!.phoneNumber!}",
                            style: CDTextStyle.regularFont(fontSize: 12.0),
                          ),
                          const SizedBox(height: 53),
                          PlainTextField(
                            controller: _tecEmail,
                            hintText: "이메일",
                            keyboardType: TextInputType.emailAddress,
                            // textInputAction: TextInputAction.next,
                            onEditingComplete: () =>
                                context.nextEditableTextFocus(),
                            showClear: true,
                            onChanged: (value) {},
                            validator: (val) {
                              return val == null ||
                                      !RegExp(Constants.emailRegex)
                                          .hasMatch(val)
                                  ? "이메일이 맞는지 확인해주세요"
                                  : null;
                            },
                          ),
                          const SizedBox(height: 8),
                          PlainTextField(
                            controller: _tecPassword,
                            hintText: "비밀번호",
                            showSecure: true,
                            isSecure: true,
                            onEditingComplete: () =>
                                context.nextEditableTextFocus(),
                            validator: (value) {
                              return value == null || value.length < 6
                                  ? "비밀번호를 6 글자 이상으로 해주세요"
                                  : null;
                            },
                          ),
                          const SizedBox(height: 8),
                          PlainTextField(
                            controller: _tecPasswordCheck,
                            hintText: "비밀번호 확인",
                            showSecure: true,
                            isSecure: true,
                            onEditingComplete: () =>
                                context.nextEditableTextFocus(),
                            validator: (value) {
                              logger.i(
                                  "$value == ${_tecPassword.text} = ${value == _tecPassword.text}");
                              return value == _tecPassword.text
                                  ? null
                                  : "비밀번호가 서로 다릅니다";
                            },
                          ),
                          const SizedBox(height: 8),
                          PlainTextField(
                            controller: _tecNickname,
                            hintText: "닉네임",
                            showClear: true,
                            onEditingComplete: () =>
                                context.nextEditableTextFocus(),
                            validator: (value) {
                              return value == null || value.length < 1
                                  ? "닉네임을 확인해주세요"
                                  : null;
                            },
                          ),
                          const SizedBox(height: 8),
                          PlainTextField(
                            controller: _tecCompany,
                            hintText: "회사명 (선택)",
                            showClear: true,
                            onEditingComplete: () =>
                                context.nextEditableTextFocus(),
                            validator: (value) {
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          PlainTextField(
                            controller: _tecPhone,
                            keyboardType: TextInputType.phone,
                            hintText: "연락처",
                            showClear: true,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              return value == null || value.length < 1
                                  ? "연락처를 확인해주세요"
                                  : null;
                            },
                            onFieldSubmitted: (text) {
                              onSignUp(context);
                            },
                          ),
                          const SizedBox(height: 24),
                          CDButton(
                            width: size.width - 40,
                            text: "회원가입",
                            press: () {
                              onSignUp(context);
                            },
                          ),
                          const SizedBox(height: 8),
                          CDButton(
                              width: size.width - 40,
                              text: "로그인으로 돌아가기",
                              // press: () {},
                              press: onBack,
                              type: ButtonType.transparent),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: CDColors.nav_title),
      backgroundColor: Colors.white,
      elevation: 1,
      centerTitle: true,
      title: Text("회원가입", style: CDTextStyle.nav),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        color: CDColors.gray8,
        onPressed: () async {
          await Navigator.of(context).pushReplacementNamed('PagePreview');
        },
      ),
    );
  }

  onBack() {
    // Navigator.of(context).pop();

    Navigator.of(context).pushReplacementNamed('PagePreview');
  }

  onSignUp(BuildContext context) {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    final String email = _tecEmail.text;
    final String nickname = _tecNickname.text;
    final String company = _tecCompany.text;
    final String phone = _tecPhone.text;
    HelperFunctions.saveUserEmail(email);
    setState(() {
      isLoading = true;
    });
    logger.i("here");
    authMethods
        .signUpWithEmailAndPassword(email, _tecPassword.text)
        .catchError((e) {
      setState(() {
        isLoading = false;
      });
      if (e.toString().contains('email-already-in-use')) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("이미 가입되었거나 잘못된 형식입니다.")));
      } else {
        showVerifyEmailDialog(context).then((value) {});
      }
    }).then((result) async {
      setState(() {
        isLoading = false;
      });
      User _user = User(
        email: email,
        name: nickname,
        companyName: company,
        phoneNumber: phone,
        agreeTerms: true,
      );

      Singleton.shared.userData =
          UserResponseData(user: _user, userId: result.userId);

      // TODO api test 진행중 , user model 생성 다시해야할듯..
      UserRequest userRequest =
          UserRequest(user: Singleton.shared.userData!.user!);
      await context.read(userNotifier).setUser(userRequest);
      await HelperFunctions.saveUserId(result.userId);
      await showVerifyEmailDialog(context);
    });
  }

  Future showVerifyEmailDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          content: Container(
            child: Text("이메일을 보냈습니다. 확인후 이어서 진행해주세요."),
          ),
          actions: [
            FlatButton(
              child: Text("확인"),
              onPressed: () {
                Navigator.pop(dialogContext);
                signIn(context);
              },
            )
          ],
        );
      },
    );
  }

  signIn(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("이메일 및 비밀번호가 맞는지 확인 해주세요"),
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
    }).then((result) async {
      if (result!.user!.emailVerified! == false) {
        setState(() {
          isLoading = false;
        });
        onBack();
        return;
      }
      logger.w(result);
      Singleton.shared.userData = await context.read(userNotifier).getUser();
      HelperFunctions.saveUserId(result.userId);
      HelperFunctions.saveLoggedIn(true);
      HelperFunctions.saveUserInfo(Singleton.shared.userData!.user);

      Routers.loadMain(context);
    });
  }
}
