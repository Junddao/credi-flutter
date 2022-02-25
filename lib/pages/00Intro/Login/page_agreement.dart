import 'package:crediApp/global/style/cdtextstyle.dart';
import 'package:crediApp/global/components/circularcheckbox.dart';
import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/helperfunctions.dart';
import 'package:crediApp/global/singleton.dart';
import 'package:crediApp/page_tabs.dart';
import 'package:crediApp/global/components/cdbutton.dart';
import 'package:crediApp/pages/00Intro/Login/page_login.dart';
import 'package:crediApp/pages/00Intro/Login/page_signup.dart';
import 'package:crediApp/pages/00Intro/Login/page_signup_detail.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PageAgreement extends StatefulWidget {
  final bool isThirdPartySignup;

  const PageAgreement({Key? key, required this.isThirdPartySignup})
      : super(key: key);

  @override
  _PageAgreementState createState() => _PageAgreementState();
}

class _PageAgreementState extends State<PageAgreement> {
  Map<String, bool> mapAgreement = {
    "privacy": false,
    "service": false,
    "thirdPartyAccess": false,
  };
  bool get isAgreeAll =>
      (mapAgreement["privacy"] ?? false) &&
      (mapAgreement["service"] ?? false) &&
      (mapAgreement["thirdPartyAccess"] ?? false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(context),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "약관\n동의",
                style: CDTextStyle.boldFont(fontSize: 32),
              ),
              SizedBox(height: 13),
              Text(
                "원활한 크레디 서비스 제공을 위해\n약관 동의가 꼭 필요합니다.",
                style: CDTextStyle.regularFont(
                  fontSize: 13,
                  color: CDColors.black03,
                ),
              ),
              Spacer(),
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: CircularCheckBox(
                        value: isAgreeAll,
                        onChanged: _checkAgreeAll,
                      ),
                    ),
                  ),
                  Text(
                    "전체 약관에 동의합니다.",
                    style: CDTextStyle.boldFont(fontSize: 17),
                  ),
                ],
              ),
              SizedBox(height: 53),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    _buildCheckBox("privacy"),
                    Text(
                      "개인정보 취급방침 (필수)",
                      style: CDTextStyle.regularFont(fontSize: 16),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () => _onPrivacyLink(),
                      child: Text(
                        "보기",
                        style: CDTextStyle.regularFont(
                          fontSize: 16,
                          color: CDColors.black04,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    _buildCheckBox("service"),
                    Text(
                      "사용자 이용약관 (필수)",
                      style: CDTextStyle.regularFont(fontSize: 16),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () => _onServiceLink(),
                      child: Text(
                        "보기",
                        style: CDTextStyle.regularFont(
                          fontSize: 16,
                          color: CDColors.black04,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    _buildCheckBox("thirdPartyAccess"),
                    Text(
                      "제3자 정보제공 동의 (필수)",
                      style: CDTextStyle.regularFont(fontSize: 16),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () => _onThirdPartyAccessLink(),
                      child: Text(
                        "보기",
                        style: CDTextStyle.regularFont(
                          fontSize: 16,
                          color: CDColors.black04,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 56),
              CDButton(
                width: MediaQuery.of(context).size.width - 48,
                text: "동의하고 가입하기",
                press: () => _onAgree(),
              ),
              SizedBox(height: 20),
            ],
          ),
        ));
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: CDColors.nav_title),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          size: 17,
        ),
        onPressed: () {
          HelperFunctions.logout();
          Navigator.of(context).pushReplacementNamed('PagePreview');
        },
      ),
      actions: [],
    );
  }

  Container _buildCheckBox(String category) {
    return Container(
      width: 40,
      height: 40,
      child: FittedBox(
        fit: BoxFit.fill,
        child: CircularCheckBox(
          value: mapAgreement[category]!,
          onChanged: (checked) => _checkAgree(category, checked),
        ),
      ),
    );
  }

  _checkAgreeAll(bool? checked) {
    setState(() {
      mapAgreement.forEach((key, value) {
        mapAgreement[key] = checked ?? false;
      });
    });
  }

  _checkAgree(String category, bool? checked) {
    setState(() {
      mapAgreement[category] = checked ?? false;
    });
  }

  _onPrivacyLink() {
    launch("https://terms.credi.co.kr/privacy.html");
  }

  _onServiceLink() {
    launch("https://terms.credi.co.kr/terms.html");
  }

  _onThirdPartyAccessLink() {
    launch("https://terms.credi.co.kr/thirdpartyaccess.html");
  }

  _onAgree() async {
    if (isAgreeAll) {
      if (widget.isThirdPartySignup) {
        Singleton.shared.userData!.user =
            Singleton.shared.userData!.user!.copyWith(agreeTerms: true);
        if (Singleton.shared.userData!.user!.name != '') {
          // UserRequest userRequest =
          //     UserRequest(user: Singleton.shared.userData!.user!);
          // await context.read(userNotifier).setUser(userRequest);
          Navigator.of(context)
              .pushNamedAndRemoveUntil('PageTabs', (route) => false);
        } else {
          Navigator.of(context).pushNamed('PageSignUpDetail');
        }
      } else {
        Navigator.of(context).pushNamed('PageSignUp');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("약관 동의 후 진행이 가능합니다."),
      ));
    }
  }
}
