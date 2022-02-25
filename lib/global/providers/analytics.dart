import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

class AnalyticsNotifire with ChangeNotifier {
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  final facebookAppEvents = FacebookAppEvents();

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: analytics);

  Future<void> sendAnalyticsEvent(String eventName) async {
    await analytics.logEvent(
      name: eventName,
      // parameters: <String, dynamic>{
      //   'credi_event': eventName,
      // },
    );

    await facebookAppEvents.logEvent(
      name: eventName,
    );
  }

  Future setCurrentScreen(String screenName) async {
    await analytics.setCurrentScreen(screenName: screenName);
    await facebookAppEvents.logEvent(name: screenName);
  }
}
