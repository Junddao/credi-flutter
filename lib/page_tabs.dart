import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:crediApp/global/enums/tab_type.dart';
import 'package:crediApp/global/helperfunctions.dart';
import 'package:crediApp/global/models/chat/chat_get_message_response_model.dart';
import 'package:crediApp/global/models/config_model.dart';
import 'package:crediApp/global/models/user/user_request_model.dart';
import 'package:crediApp/global/models/user/user_type_model.dart';
import 'package:crediApp/global/models/web_socket/web_socket_message_model.dart';
import 'package:crediApp/global/providers/chat.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:crediApp/global/providers/tabstates.dart';
import 'package:crediApp/global/service/fcm_push_manager.dart';
import 'package:crediApp/global/singleton.dart';
import 'package:crediApp/pages/01Home/page_home.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:web_socket_channel/io.dart';

import 'global/constants.dart';

import 'pages/00Product/page_product_list.dart';
import 'pages/04-1Chat/page_chat.dart';
import 'pages/05Settings/page_user_settings.dart';

class PageTabs extends StatefulWidget {
  const PageTabs({
    Key? key,
  }) : super(key: key);

  @override
  _PageTabsState createState() => _PageTabsState();
}

class _PageTabsState extends State<PageTabs> {
  // webSocket 변수
  IOWebSocketChannel? channel;
  int _selectedIndex = 0;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List _pages = [
    PageHome(isPreview: false),
    PageProductList(),
    Container(),
    PageChatRoom(),
    PageUserSettings(),
  ];

  @override
  void initState() {
    super.initState();
    initViewState();
    print('tab init');

    Future.microtask(() async {
      await context
          .read(chatListNotifier)
          .chatGetNewMessageCount()
          .then((value) {
        uninitViewState();
      });
      await FcmPushManager().init(initScheduled: false);
      FcmPushManager().registerNotification().then((value) async {
        await context
            .read(userNotifier)
            .setUser(UserRequest(user: Singleton.shared.userData!.user!));
        await HelperFunctions.readToken().then((value) {
          channelconnect(value!);
        });
      });
    });
    listenNotifications();
  }

  void listenNotifications() =>
      FcmPushManager().onNotifications.stream.listen(onClickNotification);

  void onClickNotification(String? payload) async {
    Map map = json.decode(payload!);

    int otherUserId = int.parse(map['otherUserId']);
    String chatroom = map['chatRoomId'] ?? '';
    int bidId = 0; // push 에는 bidId 를 담아서 보낼수 없기 때문에 0 (default)로 담아서 보냄

    if (chatroom != '') {
      int chatRoomId = int.parse(chatroom);
      Route<dynamic>? route = NavigationHistoryObserver().top;
      print(context.read(chatListNotifier).id);
      if (route!.settings.name == 'PageChatDetail' &&
          context.read(chatListNotifier).id == chatRoomId) {
        return;
      } else {
        Navigator.of(context).pushNamed('PageChatDetail',
            arguments: [otherUserId, chatRoomId, bidId]).then((value) async {
          context.read(chatListNotifier).chatGetNewMessageCount();
        });
      }
    }
  }

  @override
  void dispose() {
    print('tab dispose');
    channel!.sink.close();
    super.dispose();
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
                      Navigator.of(context).pushNamed('PageCreateProduct');
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

  Widget _body() {
    // if (_selectedIndex == 2) {
    //   _selectedIndex = 0;
    // }
    return _pages[_selectedIndex];
  }

  channelconnect(String token) {
    try {
      channel = IOWebSocketChannel.connect(
        ConfigModel().webSocketServer,
        pingInterval: Duration(seconds: 3),
        headers: {
          'Credi-Token': token,
        },
      );

      channel!.stream.listen(
        (message) async {
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //   content: Text('$message'),
          //   duration: Duration(milliseconds: 100),
          // ));
          if (message == "connected") {
            Logger().d("Connection establised.");
          }
          // 채팅방 id
          else {
            Logger().d('web-socket_message :$message');

            await updateChatMessage(message);
          }
          // context.read(webSocketNotifier).setMessage(message);
        },
        onDone: () {
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //   content: Text('disconnected!'),
          //   duration: Duration(milliseconds: 100),
          // ));
          Logger().d("Web socket is closed");
          Future.delayed(Duration(seconds: 1), channelconnect(token));
        },
        onError: (error) {
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //   content: Text('error!'),
          //   duration: Duration(milliseconds: 100),
          // ));
          Logger().d('error ' + error.toString());
        },
      );
    } catch (_) {
      print("error on connecting to websocket.");
    }
  }

  void _onItemTapped(int index, TabStates tabStatesProvider) async {
    // 혹시라도 아래 탭 누르면 그냥 안옮김.
    if (index == 2) {
      return;
    } else {
      setState(() {
        tabStatesProvider.selectedIndex = index;
        // _selectedIndex = index;
      });
    }
  }

  Future<void> updateChatMessage(String message) async {
    print(
        "${context.read(chatListNotifier).chatGetMessageResponseData!.length}");
    WebSocketMessage webSocketMessage = WebSocketMessage.fromJson(message);
    // 채팅방이 열려있는 경우

    Route<dynamic>? route = NavigationHistoryObserver().top;
    if (route != null) print('thisPage :  ${route.settings.name}');
    await context.read(chatListNotifier).chatGetNewMessageCount();
    if (route!.settings.name == 'PageChatDetail') {
      // 첫 채팅이면.

      if (context.read(chatListNotifier).chatGetMessageResponseData!.isEmpty) {
        await context
            .read(chatListNotifier)
            .chatGetMessageAllByChatRoomId(webSocketMessage.chatRoomId!);
      }
      // 기존 채팅 있을경우
      else {
        ChatGetMessageResponseData messageData =
            context.read(chatListNotifier).chatGetMessageResponseData!.first;

        if (messageData.chatMessage!.chatRoomId ==
            webSocketMessage.chatRoomId) {
          // message 가 order면
          if (webSocketMessage.type == WebSocketMessageType.order) {
            await context
                .read(chatListNotifier)
                .updateOrderState(webSocketMessage);
          }
          // message 가 text, system 이면
          else {
            var newMessageData = await context
                .read(chatListNotifier)
                .getMessageNew(messageData.chatMessage!.chatRoomId!,
                    messageData.createdAt!, messageData.chatMessageId!);
            await context
                .read(chatListNotifier)
                .updateMessageDatas(newMessageData);
          }
        }
      }
    }
    // 다른곳에 있는 경우  badge하세용.
    else {
      await context.read(chatListNotifier).chatGetAll();
    }
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
            icon: Consumer(builder: (_, watch, __) {
              ChatChangeNotifier chatNotifier = watch(chatListNotifier);
              int newMessageCnt = chatNotifier.newMessage!;
              return Badge(
                showBadge: newMessageCnt == 0 ? false : true,
                badgeContent:
                    Text('$newMessageCnt', style: CDTextStyle.regular12white02),
                child: ImageIcon(
                  AssetImage("assets/icons/ic_message.png"),
                  size: 28,
                ),
              );
            }),
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
}
