import 'package:crediApp/global/enums/view_state.dart';
import 'package:crediApp/global/providers/WebSocket.dart';
import 'package:crediApp/global/providers/bids.dart';
import 'package:crediApp/global/providers/chat.dart';
import 'package:crediApp/global/providers/file_controller.dart';
import 'package:crediApp/global/providers/analytics.dart';
import 'package:crediApp/global/providers/info.dart';
import 'package:crediApp/global/providers/rating.dart';
import 'package:crediApp/global/providers/system.dart';
import 'package:crediApp/global/providers/tabstates.dart';
import 'package:crediApp/global/providers/user_order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:crediApp/global/providers/products.dart';
import 'package:crediApp/global/providers/user.dart';

bool isInitLoading = false;

initViewState() {
  isInitLoading = true;
}

uninitViewState() {
  isInitLoading = false;
}

final tabProvider = ChangeNotifierProvider<TabStates>((ref) {
  return TabStates();
});

final userNotifier = ChangeNotifierProvider<UserChangeNotifier>((ref) {
  return UserChangeNotifier();
});

final productListNotifier =
    ChangeNotifierProvider<ProductChangeNotifier>((ref) {
  return ProductChangeNotifier();
});

final bidListNotifier = ChangeNotifierProvider<BidChangeNotifier>((ref) {
  return BidChangeNotifier();
});

final userOrderListNotifier =
    ChangeNotifierProvider<UserOrderChangeNotifier>((ref) {
  return UserOrderChangeNotifier();
});

final chatListNotifier = ChangeNotifierProvider<ChatChangeNotifier>((ref) {
  return ChatChangeNotifier();
});

final ratingListNotifier = ChangeNotifierProvider<RatingChangeNotifier>((ref) {
  return RatingChangeNotifier();
});

final fileControllerNotifier =
    ChangeNotifierProvider<FileControllerChangeNotifier>((ref) {
  return FileControllerChangeNotifier();
});

final systemNotifier = ChangeNotifierProvider<SystemChangeNotifier>((ref) {
  return SystemChangeNotifier();
});

final webSocketNotifier =
    ChangeNotifierProvider<WebSocketChangeNotifier>((ref) {
  return WebSocketChangeNotifier();
});

final firebaseAnalyticsNotifier =
    ChangeNotifierProvider<AnalyticsNotifire>((ref) {
  return AnalyticsNotifire();
});

final infoChangeNotifier = ChangeNotifierProvider<InfoChangeNotifier>((ref) {
  return InfoChangeNotifier();
});
