import 'package:crediApp/generated/locale_keys.g.dart';
import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/singleton.dart';
import 'package:crediApp/global/style/cdtextstyle.dart';
import 'package:crediApp/global/components/cdbutton.dart';
import 'package:crediApp/pages/00Intro/Intro/components/last_slide.dart';
import 'package:crediApp/route.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'components/intro_slide.dart';

class PageIntroSlider extends StatefulWidget {
  const PageIntroSlider({Key? key}) : super(key: key);

  @override
  _PageIntroSliderState createState() => _PageIntroSliderState();
}

class _PageIntroSliderState extends State<PageIntroSlider> {
  double _currentPage = 0;
  bool _showButton = false;
  late final PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (value) => _onPageChanged(value),
            children: [
              IntroSlide(
                title: LocaleKeys.intro1_title.tr(),
                description: LocaleKeys.intro1_description.tr(),
                pathImage: "assets/icons/ic_intro_product.png",
              ),
              IntroSlide(
                title: LocaleKeys.intro2_title.tr(),
                description: LocaleKeys.intro2_description.tr(),
                pathImage: "assets/icons/ic_intro_chat.png",
              ),
              IntroSlide(
                title: LocaleKeys.intro3_title.tr(),
                description: LocaleKeys.intro3_description.tr(),
                pathImage: "assets/icons/ic_intro_order.png",
              ),
              LastSlide(),
            ],
          ),
          _showButton
              ? Positioned(
                  left: 20,
                  bottom: 30,
                  child: CDButton(
                    width: MediaQuery.of(context).size.width - 40,
                    text: LocaleKeys.start.tr(),
                    press: onDonePress,
                  ),
                )
              : Stack(
                  children: [
                    Positioned(
                      width: MediaQuery.of(context).size.width,
                      bottom: 17,
                      height: 40,
                      child: Container(
                        child: DotsIndicator(
                          dotsCount: 4,
                          position: _currentPage,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 18,
                      bottom: 17,
                      height: 40,
                      child: TextButton(
                        child: Text(
                          "SKIP",
                          style: CDTextStyle.boldFont(
                            fontSize: 14,
                            color: CDColors.black03,
                          ),
                        ),
                        onPressed: () => _onSkip(),
                      ),
                    ),
                  ],
                )
        ],
      ),
    );
  }

  _onPageChanged(int page) {
    setState(() {
      _currentPage = page.toDouble();
      _showButton = page == 3;
    });
  }

  _onSkip() {
    _pageController.jumpToPage(3);
  }

  void onDonePress() {
    // Do what you want
    if (Singleton.shared.userData == null) {
      Navigator.of(context).pushNamed('PageLogin');
    } else {
      Routers.loadMain(context);
    }

    // // Do what you want
    // if (Singleton.shared.user == null) {
    //   Navigator.pushReplacement(
    //     context,
    //     new MaterialPageRoute(builder: (context) => PageLogin()),
    //   );
    // } else {
    //   Routes.loadMain(context);
    // }
  }

  ButtonStyle myButtonStyle() {
    return ButtonStyle(
      textStyle: MaterialStateProperty.all<TextStyle>(
        CDTextStyle.p3.copyWith(
          fontSize: 14,
          color: CDColors.black04,
        ),
      ),
      // shape: MaterialStateProperty.all<OutlinedBorder>(StadiumBorder()),
      // backgroundColor: MaterialStateProperty.all<Color>(Color(0x33ffcc5c)),
      // overlayColor: MaterialStateProperty.all<Color>(Color(0x33ffcc5c)),
    );
  }
}
