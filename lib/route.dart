import 'package:crediApp/global/components/photo_viewer.dart';
import 'package:crediApp/global/models/user/user_response_model.dart';
import 'package:crediApp/global/singleton.dart';
import 'package:crediApp/pages/00Intro/Intro/page_intro.dart';
import 'package:crediApp/pages/00Intro/Intro/page_intro_slider.dart';
import 'package:crediApp/pages/00Intro/Login/page_agreement.dart';
import 'package:crediApp/pages/00Intro/Login/page_login.dart';
import 'package:crediApp/pages/00Intro/Login/page_preview.dart';
import 'package:crediApp/pages/00Intro/Login/page_signup.dart';
import 'package:crediApp/pages/00Intro/Login/page_signup_detail.dart';
// import 'package:crediApp/pages/00Product/page_create_product.dart';
import 'package:crediApp/pages/00Product/page_create_product.dart';
import 'package:crediApp/pages/00Product/page_product_bid_detail.dart';
import 'package:crediApp/pages/00Product/page_product_bid_list.dart';
import 'package:crediApp/pages/00Product/page_product_detail.dart';
import 'package:crediApp/pages/00Product/page_rate.dart';
import 'package:crediApp/pages/00Product/page_success_create_product.dart';
import 'package:crediApp/pages/01Home/page_user_guide.dart';
import 'package:crediApp/pages/04-1Chat/page_chat.dart';
import 'package:crediApp/pages/04-1Chat/page_chat_detail.dart';
import 'package:crediApp/pages/04-1Chat/page_order_list.dart';
import 'package:crediApp/pages/05Settings/page_success_load_my_request.dart';
import 'package:crediApp/pages/05Settings/page_user_alarm_setting.dart';
import 'package:crediApp/pages/05Settings/page_user_load_my_request.dart';
import 'package:crediApp/pages/05Settings/page_user_settings_detail.dart';
import 'package:crediApp/pages/07CompanyInfo/page_company_info.dart';
import 'package:crediApp/pages/99Others/version_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crediApp/page_tabs.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    dynamic arguments = settings.arguments;

    switch (settings.name) {
      case 'PageTabs':
        return CupertinoPageRoute(
          builder: (_) => PageTabs(),
          settings: settings,
        );

      case 'PageUserGuide':
        return CupertinoPageRoute(
          builder: (_) => PageUserGudie(),
          settings: settings,
        );

      case 'PageIntroSlider':
        return CupertinoPageRoute(
          builder: (_) => PageIntroSlider(),
          settings: settings,
        );

      case 'PageIntro':
        return CupertinoPageRoute(
          builder: (_) => PageIntro(),
          settings: settings,
        );

      case 'PageAgreement':
        return CupertinoPageRoute(
          builder: (_) => PageAgreement(
            isThirdPartySignup: arguments,
          ),
        );

      case 'PageSignUpDetail':
        return CupertinoPageRoute(
          builder: (_) => PageSignUpDetail(),
          settings: settings,
        );

      case 'PageSignUp':
        return CupertinoPageRoute(
          builder: (_) => PageSignUp(),
          settings: settings,
        );

      case 'PageLogin':
        return CupertinoPageRoute(
          builder: (_) => PageLogin(),
          settings: settings,
        );

      case 'PagePreview':
        return CupertinoPageRoute(
          builder: (_) => PagePreview(),
          settings: settings,
        );

      case 'VersionPage':
        return CupertinoPageRoute(
          builder: (_) => VersionPage(),
          settings: settings,
        );

      case 'PageUserSettingsDetail':
        return CupertinoPageRoute(
          builder: (_) => PageUserSettingsDetail(),
          settings: settings,
        );

      case 'PageRate':
        return CupertinoPageRoute(
          builder: (_) => PageRate(
            bidResponseData: arguments[0],
            productResponseData: arguments[1],
          ),
          settings: settings,
        );

      case 'PageChatDetail':
        return CupertinoPageRoute(
          builder: (_) => PageChatDetail(
            userId: arguments[0],
            chatRoomId: arguments[1],
            bidId: arguments[2],
          ),
          settings: settings,
        );

      case 'PageChatRoom':
        return CupertinoPageRoute(
          builder: (_) => PageChatRoom(),
          settings: settings,
        );

      case 'PageProductBidList':
        return CupertinoPageRoute(
          builder: (_) => PageProductBidList(
            productId: arguments,
          ),
          settings: settings,
        );

      case 'PageProductBidDetail':
        return CupertinoPageRoute(
          builder: (_) => PageProductBidDetail(
            bidResponseData: arguments[0],
            productResponseData: arguments[1],
          ),
          settings: settings,
        );

      case 'PageProductDetail':
        return CupertinoPageRoute(
          builder: (_) => PageProductDetail(
            productResponseData: arguments,
          ),
          settings: settings,
        );

      case 'PageCreateProduct':
        return CupertinoPageRoute(
          builder: (_) => PageCreateProduct(
            productResponsedata: arguments,
          ),
          settings: settings,
        );
      // case 'PageCreateProduct':
      //   return CupertinoPageRoute(
      //     builder: (_) => PageCreateProduct(
      //       productResponsedata: arguments,
      //     ),
      //     settings: settings,
      //   );

      case 'PageOrderList':
        return CupertinoPageRoute(
          builder: (_) => PageOrderList(
            otherUserData: arguments[0],
            sendDoneRequest: arguments[1],
            onRequestOrder: arguments[2],
          ),
          settings: settings,
          fullscreenDialog: true,
        );

      case 'PageCompanyInfo':
        return CupertinoPageRoute(
          builder: (_) => PageCompanyInfo(
            otherUserId: arguments,
          ),
          settings: settings,
        );

      case 'PhotoViewer':
        return CupertinoPageRoute(
          builder: (_) => PhotoViewer(
            filePath: arguments,
          ),
          settings: settings,
        );

      case 'SuccessCreateProductPage':
        return CupertinoPageRoute(
          builder: (_) => SuccessCreateProductPage(),
          settings: settings,
        );

      case 'PageUserLoadMyRequest':
        return CupertinoPageRoute(
          builder: (_) => PageUserLoadMyRequest(),
          settings: settings,
        );

      case 'PageSuccessLoadMyRequest':
        return CupertinoPageRoute(
          builder: (_) => PageSuccessLoadMyRequest(),
          settings: settings,
        );

      case 'PageUserAlarmSetting':
        return CupertinoPageRoute(
          builder: (_) => PageUserAlarmSetting(),
          settings: settings,
        );

      default:
        return CupertinoPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('${settings.name} 는 lib/route.dart에 정의 되지 않았습니다.'),
            ),
          ),
        );
    }
  }

  static loadMain(BuildContext context) {
    if (Singleton.shared.userData!.user!.agreeTerms == true) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('PageTabs', (route) => false);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
        'PageAgreement',
        (route) => false,
        arguments: true,
      );
    }
  }

  static loadSignUpWithSNS(BuildContext context) {
    if (Singleton.shared.userData!.user?.agreeTerms == true) {
      Navigator.of(context).pushNamed('PageSignUpDetail');
    } else {
      Navigator.of(context).pushNamed(
        'PageAgreement',
        arguments: true,
      );
    }
  }

  static loadSignUpWithEmail(BuildContext context) {
    if (Singleton.shared.userData == null) {
      Singleton.shared.userData = UserResponseData();
    }

    if (Singleton.shared.userData!.user?.agreeTerms == true) {
      Navigator.of(context).pushNamed('PageSignUp');
    } else {
      Navigator.of(context).pushNamed(
        'PageAgreement',
        arguments: false,
      );
    }
  }
}
