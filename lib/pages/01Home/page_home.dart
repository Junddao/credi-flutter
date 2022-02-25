import 'package:crediApp/global/components/cdbutton.dart';
import 'package:crediApp/global/components/view_state_container.dart';
import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/enums/factory_board_category_type.dart';
import 'package:crediApp/global/enums/view_state.dart';
import 'package:crediApp/global/helperfunctions.dart';
import 'package:crediApp/global/providers/info.dart';
import 'package:crediApp/global/providers/parent_provider.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:crediApp/global/singleton.dart';
import 'package:crediApp/pages/01Home/components/event_widget.dart';
import 'package:crediApp/pages/01Home/components/home_intro_widget.dart';
import 'package:crediApp/pages/01Home/components/magazine_widget.dart';
import 'package:crediApp/pages/01Home/components/popular_partner_widget.dart';
import 'package:crediApp/pages/01Home/components/question_widget.dart';
import 'package:crediApp/pages/99Others/error_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class PageHome extends StatefulWidget {
  final bool? isPreview;
  const PageHome({Key? key, this.isPreview}) : super(key: key);

  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  @override
  void initState() {
    initViewState();
    Future.microtask(() {
      context.read(firebaseAnalyticsNotifier).sendAnalyticsEvent('PageHome');
      refresh();
    });
    super.initState();
  }

  void refresh() async {
    Future.wait([
      context.read(infoChangeNotifier).getEvent(),
      context
          .read(infoChangeNotifier)
          .getFactoryBoard(FactoryBoardCategoryType.categoryMap.keys.first),
      context.read(infoChangeNotifier).getFaq(),
      context.read(infoChangeNotifier).getMagazine(),
    ]).then((value) {
      uninitViewState();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: _body(),
    );
  }

  _body() {
    return Consumer(builder: (_, watch, child) {
      InfoChangeNotifier _infoChagneNotifier = watch(infoChangeNotifier);
      if (isInitLoading == true) {
        return ViewStateContainer.busyContainer();
      } else if (_infoChagneNotifier.state == ViewState.Error) {
        return ErrorPage();
      }

      List<String> _imageUrls = [];

      _infoChagneNotifier.eventResponseDatas!.forEach((element) {
        _imageUrls.add(element.event!.image!);
      });

      return SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(vertical: kDefaultVerticalPadding),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultHorizontalPadding),
                child: HomeIntroWidget(goUserGuide: goUserGuide),
              ),
              SizedBox(height: 40),

              PopularPartnerWidget(makeOrder: makeOrder),

              widget.isPreview!
                  ? SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultHorizontalPadding),
                      child: CDButton(
                        text: '견적 요청',
                        press: makeOrder,
                        width: SizeConfig.screenWidth,
                        type: ButtonType.dark,
                      ),
                    ),

              widget.isPreview! ? SizedBox.shrink() : SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultHorizontalPadding),
                child: EventWidget(openEvent: openEvent),
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.only(left: kDefaultHorizontalPadding),
                child: MagazineWidget(openMagazine: openMagazine),
              ),

              SizedBox(height: 40),
              QuestionWidget(),
              SizedBox(height: 40),
              // magagineWidget(),
              // nationalSupportProjectWidget(),
            ],
          ),
        ),
      );
    });
  }

  void goUserGuide() {
    Navigator.of(context).pushNamed('PageUserGuide');
  }

  void makeOrder() async {
    Navigator.of(context).pushNamed('PageCreateProduct');
  }

  void openEvent(String url) async {
    // launch(url);
    if (await canLaunch(url)) {
      await launch(
        url,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  void openMagazine(String url) async {
    // launch(url);
    if (await canLaunch(url)) {
      await launch(
        url,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
