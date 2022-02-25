import 'dart:async';
import 'dart:convert';

import 'package:crediApp/env/environment.dart';
import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/models/config_model.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:crediApp/global/service/api_service.dart';
import 'package:crediApp/global/util.dart';
import 'package:crediApp/pages/00Intro/Intro/page_intro.dart';
import 'package:crediApp/route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:package_info/package_info.dart';

// void main() async {

//   runServer();
// }

runServer() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterDownloader.initialize();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  ApiService.appVersion = packageInfo.version;
  await ApiService().getDeviceUniqueId();
  print(packageInfo.packageName);

  // initRootLogging();
  // initRootLogger();
  logger.i("initLogger");
  KakaoContext.clientId = '2a00dfc757c43b11d07709687d10b4ee';
  KakaoContext.javascriptClientId = '3c6834264ad149fcb03d238e38263180';
  await readConfigFile();

  // 광고 추적용
  // await AppTrackingTransparency.requestTrackingAuthorization();
  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('ko'),
        Locale('en'),
      ],
      path: 'assets/translations',
      child: ProviderScope(
        child: App(),
      ),
    ),
  );
}

Future<void> readConfigFile() async {
  var configJson;
  if (Environment.buildType == BuildType.dev) {
    configJson = await rootBundle.loadString('assets/texts/config_dev.json');
  } else if (Environment.buildType == BuildType.stage) {
    configJson = await rootBundle.loadString('assets/texts/config_stage.json');
  } else {
    configJson = await rootBundle.loadString('assets/texts/config_prod.json');
  }

  print(configJson);
  final configObject = jsonDecode(configJson);
  ConfigModel().fromJson(configObject);
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // firebase analytics 초기화
  // static FirebaseAnalytics analytics = FirebaseAnalytics();
  // static FirebaseAnalyticsObserver observer =
  //     FirebaseAnalyticsObserver(analytics: analytics);

  @override
  void initState() {
    getDynamicLink();
    super.initState();
  }

  void getDynamicLink() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;

      print(deepLink);
      print(deepLink!.path);

      if (deepLink != null) {
        setState(() {});
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    print(deepLink);

    if (deepLink != null) {
      setState(() {});
    }
  }

  homePage(snapshot) {
    if (snapshot.connectionState != ConnectionState.done) {
      return Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      );
    }

    return PageIntro();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        return FlavorBanner(
          child: MaterialApp(
              builder: (context, child) {
                final data = MediaQuery.of(context);
                return MediaQuery(
                  data: data.copyWith(
                    textScaleFactor: 1.0,
                  ),
                  child: child!,
                );
              },
              // debugShowCheckedModeBanner:
              //     Environment.isDebuggable ? true : false,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  textTheme: GoogleFonts.dmSansTextTheme()
                      .apply(displayColor: kTextColor),
                  primaryColor: CDColors.blue5,
                  bottomSheetTheme:
                      BottomSheetThemeData(backgroundColor: Colors.white),
                  accentColor: CDColors.blue5,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  appBarTheme: AppBarTheme(
                    color: Colors.white,
                    elevation: 1,
                  ),
                  scaffoldBackgroundColor: Colors.white),
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              onGenerateRoute: Routers.generateRoute,
              navigatorObservers: <NavigatorObserver>[
                NavigationHistoryObserver(),
                // observer,
                context.read(firebaseAnalyticsNotifier).getAnalyticsObserver(),
              ],
              home: snapshot.hasError
                  ? Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          Text(
                            "Something went wrong $snapshot",
                          ),
                          Spacer(),
                        ],
                      ),
                    )
                  : homePage(snapshot)),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildBanner({String? message}) => ClipRect(
        child: Banner(
          message: message!,
          location: BannerLocation.topEnd,
          color: Colors.red,
          child: Container(
            margin: const EdgeInsets.all(10.0),
            color: Colors.yellow,
            height: 100,
            child: Center(
              child: Text("Hello, banner!"),
            ),
          ),
        ),
      );
}
