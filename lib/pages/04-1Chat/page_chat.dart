import 'package:crediApp/global/components/view_state_container.dart';
import 'package:crediApp/global/enums/view_state.dart';
import 'package:crediApp/global/models/chat/chat_create_request_model.dart';
import 'package:crediApp/global/models/chat/chat_get_all_response_model.dart';
import 'package:crediApp/global/models/chat/chat_message_model.dart';
import 'package:crediApp/global/models/config_model.dart';
import 'package:crediApp/global/models/user/user_type_model.dart';
import 'package:crediApp/global/providers/chat.dart';
import 'package:crediApp/global/providers/parent_provider.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:crediApp/global/singleton.dart';
import 'package:crediApp/pages/99Others/error_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../global/components/cell_chat_list.dart';
import '../../global/constants.dart';
import '../../global/util.dart';
import 'page_chat_detail.dart';

class PageChatRoom extends StatefulWidget {
  @override
  _PageChatRoomState createState() => _PageChatRoomState();
}

class _PageChatRoomState extends State<PageChatRoom> {
  bool isLoading = false;

  @override
  void initState() {
    initViewState();

    Future.microtask(() {
      context
          .read(firebaseAnalyticsNotifier)
          .sendAnalyticsEvent('PageChatRoom');
      refresh();
    });
    super.initState();
  }

  @override
  void dispose() {
    uninitViewState();
    super.dispose();
  }

  refresh() {
    logger.i("onsearch listen");
    Future.wait([
      context.read(chatListNotifier).chatGetAll(),
      context.read(chatListNotifier).chatGetNewMessageCount(),
    ]).then((value) => uninitViewState());
  }

  @override
  Widget build(BuildContext context) {
    logger.i("_build runtimeType : ${this.runtimeType}");
    return Scaffold(
      appBar: buildAppBar(),
      body: Consumer(
        builder: (context, watch, child) {
          ChatChangeNotifier _chatChangeNotifier = watch(chatListNotifier);
          if (_chatChangeNotifier.state == ViewState.Busy ||
              isInitLoading == true) {
            return ViewStateContainer.busyContainer();
          } else if (_chatChangeNotifier.state == ViewState.Error) {
            return ErrorPage();
          }

          List<ChatGetAllResponseData>? chatRooms =
              _chatChangeNotifier.chatGetAllResponseData!;

          int idx = -1;
          bool hasCrediRoom = false;
          for (int i = 0; i < chatRooms.length; i++) {
            var room = chatRooms[i];
            if (room.factoryId == ConfigModel().crediId) {
              hasCrediRoom = true;
              idx = i;

              break;
            }
          }

          if (hasCrediRoom == true) {
            var room = chatRooms.removeAt(idx);
            chatRooms.insert(0, room);
          } else {
            var room = getCrediChatRoom();
            chatRooms.insert(0, room);
          }

          return Column(
            children: <Widget>[
              chatRoomList(chatRooms),
            ],
          );
        },
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: CDColors.nav_title),
      backgroundColor: Colors.white,
      elevation: 1,
      centerTitle: true,
      title: Text('메세지', style: CDTextStyle.nav),
    );
  }

  void didPopNext() {
    logger.i("DidPopd $runtimeType");
  }

  Widget chatRoomList(List<ChatGetAllResponseData>? chatRooms) {
    logger.i("chatRoomList : ${chatRooms!.length}");

    return Expanded(
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: ClipRRect(
          child: ListView.separated(
            itemCount: chatRooms.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return _buildCrediChatRoom(chatRooms[index]);
              } else {
                ChatGetAllResponseData chatRoom = chatRooms[index];

                int otherUserId =
                    chatRoom.clientId == Singleton.shared.userData!.userId
                        ? chatRoom.factoryId!
                        : chatRoom.clientId!;
                String otherUserName =
                    chatRoom.clientId == Singleton.shared.userData!.userId
                        ? chatRoom.factoryName!
                        : chatRoom.clientName!;

                return CellChatList(
                  // key: snapshot.data.docs[index].data["chat_room_id"],
                  userName: otherUserName,
                  chatRoom: chatRoom,

                  onTap: () {
                    createChatRoomAndStartConversation(
                      context: context,
                      otherUserId: otherUserId,
                      bidId: chatRoom.bidId!,
                      chatRoomId: chatRoom.chatRoomId,
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  ChatGetAllResponseData getCrediChatRoom() {
    int? clientId = Singleton.shared.userData!.userId!;
    int? factoryId = ConfigModel().crediId;
    String? clientName = Singleton.shared.userData!.user!.name;
    String? factoryName = ' 크레디 고객센터';

    ChatGetAllResponseData chatRoom = ChatGetAllResponseData(
      clientId: clientId,
      factoryId: factoryId,
      clientName: clientName,
      factoryName: factoryName,
      newMessageCount: 0,
      chatMessage: ChatMessage(
        message: '문의사항을 남겨주세요.',
      ),
    );

    return chatRoom;
  }

  CellChatList _buildCrediChatRoom(ChatGetAllResponseData chatRoom) {
    String userName = chatRoom.factoryName!;
    if (chatRoom.factoryId == 1) {
      userName = '크레디 고객센터';
    }
    return CellChatList(
        chatRoom: chatRoom,
        userName: userName,
        titleColor: CDColors.blue03,
        icon: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Image.asset("assets/icons/ic_support_agent.png",
              width: 24, height: 24),
        ),
        onTap: () {
          createChatRoomAndStartConversation(
            context: context,
            otherUserId: ConfigModel().crediId,
            bidId: 0,
            chatRoomId: chatRoom.chatRoomId,
          );
        });
  }

  createChatRoomAndStartConversation(
      {required BuildContext context,
      required int otherUserId,
      required int bidId,
      required int? chatRoomId}) async {
    logger.i("chat with : $otherUserId");

    await Navigator.of(context).pushNamed('PageChatDetail',
        arguments: [otherUserId, chatRoomId, bidId]).then(
      (result) {
        refresh();
      },
    );
  }
}
