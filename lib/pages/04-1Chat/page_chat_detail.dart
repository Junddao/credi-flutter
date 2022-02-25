import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:crediApp/generated/locale_keys.g.dart';
import 'package:crediApp/global/components/cd_bottom_sheet.dart';
import 'package:crediApp/global/components/cd_image_picker.dart';
import 'package:crediApp/global/components/cdbutton.dart';

import 'package:crediApp/global/components/common_dialog.dart';
import 'package:crediApp/global/components/view_state_container.dart';
import 'package:crediApp/global/enums/message_type.dart';
import 'package:crediApp/global/enums/order_state_type.dart';
import 'package:crediApp/global/enums/product_state_type.dart';
import 'package:crediApp/global/enums/view_state.dart';

import 'package:crediApp/global/models/chat/chat_create_request_model.dart';
import 'package:crediApp/global/models/chat/chat_get_message_response_model.dart';
import 'package:crediApp/global/models/chat/chat_message_model.dart';
import 'package:crediApp/global/models/config_model.dart';
import 'package:crediApp/global/models/file/task_info.dart';
import 'package:crediApp/global/models/product/product_response_model.dart';
import 'package:crediApp/global/models/user/user_response_model.dart';
import 'package:crediApp/global/models/user_order/user_order_accept_model.dart';
import 'package:crediApp/global/models/user_order/user_order_response_model.dart';
import 'package:crediApp/global/models/user_order/user_order_view_info_response_model.dart';
import 'package:crediApp/global/providers/chat.dart';
import 'package:crediApp/global/providers/file_controller.dart';
import 'package:crediApp/global/providers/parent_provider.dart';
import 'package:crediApp/global/providers/user.dart';
import 'package:crediApp/global/singleton.dart';
import 'package:crediApp/pages/04-1Chat/cell_chat_file.dart';
import 'package:crediApp/pages/04-1Chat/cell_chat_image.dart';
import 'package:crediApp/pages/04-1Chat/cell_chat_button.dart';
import 'package:crediApp/pages/99Others/error_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heic_to_jpg/heic_to_jpg.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import './cell_chat_header.dart';
import './cell_chat_message.dart';
import './cell_chat_order.dart';
import '../../global/constants.dart';
import '../../global/models/user_order/user_order_model.dart';
import '../../global/network/auth.dart';
import '../../global/providers/providers.dart';
import '../../global/util.dart';

import 'package:easy_localization/easy_localization.dart';

class PageChatDetail extends StatefulWidget {
  final int? userId;
  final int? chatRoomId;
  final int? bidId;

  PageChatDetail({this.userId, this.chatRoomId, this.bidId});

  @override
  _PageChatDetailState createState() => _PageChatDetailState();
}

class _PageChatDetailState extends State<PageChatDetail> {
  AuthMethods authMethods = new AuthMethods();

  TextEditingController tecMessage = new TextEditingController();
  ScrollController _listViewController = new ScrollController();
  // Stream<QuerySnapshot>? chatMessageStream;

  List<File> _images = [];
  List<String> _imageUrl = [];
  List<String> _fileUrl = [];
  List<AssetEntity> _selectedAssetList = [];

  int? _chatRoomId;

  late BuildContext _orderListDialogContext;
  late BuildContext _makingListDialogContext;

  ReceivePort receivePort = ReceivePort();

  List<TaskInfo>? _tasks = [];

  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    Logger().d('chat room detail --');
    initViewState();

    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);

    Future.microtask(
      () async {
        await refresh();
      },
    );

    super.initState();
  }

  Future refresh() async {
    _chatRoomId = await createChatRoom();
    logger.v("chatRoomId : $_chatRoomId");
    await Future.wait([
      context.read(userNotifier).getUserById(widget.userId!),
      context
          .read(chatListNotifier)
          .chatGetMessageAllByChatRoomId(_chatRoomId!),
    ]).then((value) => uninitViewState());
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      String? id = data[0];
      DownloadTaskStatus? status = data[1];
      int? progress = data[2];

      if (_tasks != null && _tasks!.isNotEmpty) {
        for (int i = 0; i < _tasks!.length; i++) {
          if (_tasks![i].taskId == id) {
            setState(() {
              _tasks![i].status = status;
              _tasks![i].progress = progress;
            });
          }
        }
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  @override
  void dispose() {
    print('chatDetailDispose');
    uninitViewState();
    _unbindBackgroundIsolate();
    tecMessage.dispose();
    _listViewController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  AppBar _appBar() {
    String title = widget.userId == ConfigModel().crediId ? '고객센터' : '견적 상담';
    return AppBar(
      iconTheme: IconThemeData(color: CDColors.nav_title),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.of(context).pop(true);
          // context.read(chatListNotifier).chatGetNewMessageCount().then((value) {
          //   Navigator.of(context).pop(true);
          // });
        },
      ),
      title: Text(title, style: CDTextStyle.nav),
    );
  }

  Widget _body() {
    return Consumer(
      builder: (context, watch, child) {
        ChatChangeNotifier _chatChangeNotifier = watch(chatListNotifier);
        UserChangeNotifier _userChangeNotifier = watch(userNotifier);
        FileControllerChangeNotifier fileControllerChangeNotifier =
            watch(fileControllerNotifier);
        if (isInitLoading == true) {
          return ViewStateContainer.busyContainer();
        } else if (_chatChangeNotifier.state == ViewState.Error ||
            _userChangeNotifier.state == ViewState.Error ||
            fileControllerChangeNotifier.state == ViewState.Error) {
          return ErrorPage();
        } else {
          List<ChatGetMessageResponseData>? messages =
              _chatChangeNotifier.chatGetMessageResponseData!;
          UserResponseData otherUserData = _userChangeNotifier.otherUserData!;

          //file 일 경우 멀티 다운로드 관리를 위해 task 생성해 준다.
          int cnt = 0;
          for (int i = 0; i < messages.length; i++) {
            if (messages[i].chatMessage!.type == MessageType.file) {
              cnt++;
            }
          }

          if (cnt != _tasks!.length) {
            _tasks!.clear();
            messages.forEach((element) {
              if (element.chatMessage!.type == MessageType.file) {
                String _name = element.chatMessage!.message!.split('/').last;
                String link = element.chatMessage!.message!;
                _tasks!.add(TaskInfo(name: _name, link: link));
              }
            });
          }
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: <Widget>[
                _buildChatHeader(otherUserData),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(color: CDColors.blue0),
                    child: ClipRRect(
                      child: _buildChatMessageList(messages),
                    ),
                  ),
                ),
                _buildMessageComposer(otherUserData),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildChatHeader(UserResponseData otherUserData) {
    if (otherUserData.userId == ConfigModel().crediId) {
      return Container();
    }

    return Container(
      height: 55,
      child: CellChatHeader(
        name: otherUserData.user!.name,
        onProfile: () {
          _onProfile(otherUserData);
        },
        onRequestOrder: () => _onRequestOrderList(otherUserData),
      ),
    );
  }

  Widget _buildChatMessageList(List<ChatGetMessageResponseData>? messages) {
    return ListView.builder(
      controller: _listViewController,
      reverse: true,
      padding: EdgeInsets.only(top: 15.0),
      itemCount: messages!.length,
      itemBuilder: (context, index) {
        // String text = snapshot.data.documents[index].data()["message"];
        // Timestamp timestamp = snapshot.data.documents[index].data()["createdAt"];
        // DateFormat format = new DateFormat.yMMMd().add_Hms();
        ChatGetMessageResponseData messageData = messages[index];

        bool isMe = messageData.chatMessage!.sendUserId ==
            Singleton.shared.userData!.userId;
        // Message message = Message(message: text, createdAt: timestamp);

        return _buildMessage(messageData, isMe);
      },
    );
  }

  _buildMessage(ChatGetMessageResponseData messageData, bool isMe) {
    switch (messageData.chatMessage!.type) {
      case MessageType.text:
        final CellChatMessage msg = CellChatMessage(
          context: context,
          messageData: messageData,
          isMe: isMe,
        );
        return msg;

      case MessageType.order:
        UserOrderViewInfoResponseData? data = messageData.orderInfo;

        final CellChatOrder msg = CellChatOrder(
          context: context,
          userOrderViewInfoResponseData: data,
          isMe: isMe,
          onAcceptOrder: () {
            _onAcceptOrder(messageData, true);
          },
          onDeclineOrder: () {
            _onAcceptOrder(messageData, false);
          },
        );
        return msg;

      case MessageType.image:
        final CellChatImage msg = CellChatImage(
            context: context,
            messageData: messageData,
            isMe: isMe,
            onClickImage: () {
              _onClickImage(messageData);
            });
        return msg;

      case MessageType.file:
        TaskInfo? task;
        _tasks!.forEach((element) {
          if (element.link == messageData.chatMessage!.message) {
            task = element;
          }
        });
        final CellChatFile msg = CellChatFile(
            context: context,
            messageData: messageData,
            isMe: isMe,
            task: task,
            onClickFile: (task) {
              _onClickFile(task);
            });
        return msg;

      case MessageType.button:
        final CellChatButton msg = CellChatButton(
          context: context,
          messageData: messageData,
          isMe: isMe,
        );
        return msg;

      default:
        final CellChatMessage msg = CellChatMessage(
          context: context,
          messageData: messageData,
          isMe: isMe,
          // onOpen: () {
          //   _onAcceptOrder(messageData, true);
          // },
          // onDeclineOrder: () {
          //   _onAcceptOrder(messageData, false);
          // },
        );
        return msg;
    }
  }

  _buildCall(UserResponseData otherUserData) {
    String? otherUserPhoneNum = otherUserData.user!.phoneNumber;

    otherUserPhoneNum == '' || otherUserPhoneNum == null
        ? ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("등록된 전화번호가 없습니다."),
            ),
          )
        : CDBottomSheet().getMyBottomSheet(
            context: context,
            crossAxisAlignment: CrossAxisAlignment.center,
            title: otherUserPhoneNum,
            mainIcon: 'assets/icons/ic_phone_call.png',
            buttonTitle: LocaleKeys.calling.tr(),
            function: onCallPress,
          );
  }

  _buildMail(UserResponseData otherUserData) {
    String? otherUserEmail = otherUserData.user!.email;
    otherUserEmail == '' || otherUserEmail == null
        ? ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("등록된 메일 주소가 없습니다."),
            ),
          )
        : CDBottomSheet().getMyBottomSheet(
            context: context,
            crossAxisAlignment: CrossAxisAlignment.center,
            title: otherUserEmail,
            mainIcon: 'assets/icons/ic_email.png',
            buttonTitle: LocaleKeys.send_mail.tr(),
            function: onSendEmail,
          );
  }

  _buildMessageComposer(UserResponseData otherUserData) {
    return SafeArea(
      bottom: true,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                onShowAdditionalButton(otherUserData);
              },
              child: Image.asset('assets/icons/circle_plus.png'),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 42,
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFEFEFEF)),
                  borderRadius: BorderRadius.circular(21),
                  color: Color(0xFFF8F8F8),
                ),
                child: Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: TextField(
                        controller: tecMessage,
                        onChanged: (value) {},
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: CDTextStyle.p3,
                        decoration: InputDecoration.collapsed(
                          hintText: '메세지를 입력하세요',
                        ),
                      ),
                    ),
                    InkWell(
                      child: Container(
                        child: Image.asset("assets/icons/bt_send.png"),
                        padding: EdgeInsets.all(4),
                      ),
                      onTap: _sendMessage,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<int> createChatRoom() async {
    // chatroomId가 있으면
    // if ((widget.chatRoomId == 0 || widget.chatRoomId == null) == false) {
    //   logger.i('already have chat room');
    //   context.read(chatListNotifier).id = widget.chatRoomId;
    //   return widget.chatRoomId!;
    // }

    ChatCreateRequest chat = ChatCreateRequest(
      clientId: Singleton.shared.userData!.userId,
      factoryId: widget.userId,
      bidId: widget.bidId,
    );

    // 채팅방이 있으면 채팅방 번호를 return 함
    return await context.read(chatListNotifier).chatCreate(chat);
  }

  Future<void> getOtherUser() async {
    await context.read(userNotifier).getUserById(widget.userId!);
  }

  Future<void> getChatMessage(int chatRoomId) async {
    logger.i("getChatMessage");

    await context
        .read(chatListNotifier)
        .chatGetMessageAllByChatRoomId(chatRoomId);

    // await context.read(productListNotifier).refresh();
  }

  _sendMessage() async {
    if (tecMessage.text.isEmpty) {
      return;
    }

    ChatMessage chatMessage = ChatMessage(
      sendUserId: Singleton.shared.userData!.userId,
      sendUserName: Singleton.shared.userData!.user!.name,
      message: tecMessage.text,
      type: MessageType.text,
      chatRoomId: _chatRoomId,
    );
    tecMessage.text = '';
    _sendMessageToServer(chatMessage);
  }

  Future<void> _sendFileMessage(String filePath, String type) async {
    ChatMessage chatMessage = ChatMessage(
      sendUserId: Singleton.shared.userData!.userId,
      sendUserName: Singleton.shared.userData!.user!.name,
      message: filePath,
      type: type,
      chatRoomId: _chatRoomId,
    );
    tecMessage.text = '';
    await _sendMessageToServer(chatMessage);
  }

  _onProfile(UserResponseData otherUserData) {
    Navigator.of(context)
        .pushNamed('PageCompanyInfo', arguments: otherUserData.userId);
  }

  _onClickImage(ChatGetMessageResponseData messageData) async {
    logger.i("click Image");

    Navigator.of(context)
        .pushNamed('PhotoViewer', arguments: messageData.chatMessage!.message!);
  }

  _onClickFile(TaskInfo taskInfo) async {
    logger.i("click file");

    _downloadFile(taskInfo);
  }

  _onRequestOrderList(UserResponseData otherUserData) {
    _orderListDialogContext = context;

    Navigator.of(context).pushNamed('PageOrderList', arguments: [
      otherUserData,
      _sendDoneRequest,
      _onRequestOrder,
    ]);
  }

  _onRequestOrder(BuildContext context, ProductResponseData productResponseData,
      UserResponseData otherUserData) {
    String today = DateTime.now().toShortDateString();
    CommonDialog.orderRequestDialog(
        context,
        LocaleKeys.order_dialog_title.tr(),
        LocaleKeys.order_dialog_content.tr(),
        productResponseData.product!.productName!,
        today, () {
      _sendOrderRequest(productResponseData, otherUserData);
      Navigator.pop(_orderListDialogContext);
    }, () => false);
  }

  _sendOrderRequest(ProductResponseData productResponseData,
      UserResponseData otherUserData) async {
    logger.i("_sendOrderRequest");

    ChatMessage chatMessage = ChatMessage(
      chatRoomId: _chatRoomId,
      message: "${Singleton.shared.userData!.user!.name}님의 발주가 도착했습니다.",
      sendUserId: Singleton.shared.userData!.userId,
      sendUserName: Singleton.shared.userData!.user!.name,
      type: MessageType.order,
    );

    UserOrderResponseData userOrderResponseData = UserOrderResponseData(
      userOrder: UserOrder(
        chatRoomId: _chatRoomId,
        fromUserId: Singleton.shared.userData!.userId,
        fromUserName: Singleton.shared.userData!.user!.name,
        toUserId: otherUserData.userId,
        toUserName: otherUserData.user!.name,
        productId: productResponseData.productId,
        isConsultingNeeded: productResponseData.product!.isConsultingNeeded,
        quantity: productResponseData.product!.quantity,
        state: OrderStateType.pending,
      ),
    );

    await context
        .read(userOrderListNotifier)
        .getUserOrderByProductId(productResponseData.productId!)
        .then((value) async {
      if (value != null &&
          value.length > 0 &&
          value.last.userOrder!.state == OrderStateType.pending) {
        logger.i('-- others --');

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("이미 발주되어있습니다. 변경이 필요하시면 고객센터로 문의 부탁드립니다.")));
      } else {
        logger.i('-- brand new --');
        await context
            .read(userOrderListNotifier)
            .createUserOrder(userOrderResponseData.userOrder!);
      }
    }).catchError((e) {
      logger.e(e);
    });
  }

  _onAcceptOrder(ChatGetMessageResponseData messageData, bool accept) async {
    logger.i("Ok");

    UserOrderAccept userOrderAccept = UserOrderAccept(
      userOrderId: messageData.chatMessage!.userOrderId,
      isAccept: accept,
    );

    await context.read(userOrderListNotifier).accept(userOrderAccept);
  }

  _onRequestMakingList(UserResponseData otherUserData) {
    _makingListDialogContext = context;
    logger.i("_onRequestMakingList");

    Navigator.of(context).pushNamed('PageMakingList', arguments: [
      widget.userId,
      otherUserData,
      _sendDoneRequest,
      _onRequestMaking,
    ]);
  }

  _onRequestMaking(
      BuildContext context, ProductResponseData productResponseData) {
    String today = DateTime.now().toShortDateString();
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          content: Container(
            padding: EdgeInsets.all(8),
            // decoration:
            //     BoxDecoration(border: Border.all(color: CDColors.blue6)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("제작완료", style: CDTextStyle.title2),
                Text(
                  "\n아래 제작이 완료되었습니까?.\n",
                  style: CDTextStyle.body2.copyWith(
                    fontSize: 13,
                    color: CDColors.black03,
                  ),
                ),
                Text(
                  "제품명",
                  style: CDTextStyle.body2.copyWith(
                    fontSize: 13,
                    color: CDColors.black04,
                  ),
                ),
                Text(
                  "${productResponseData.product!.productName}",
                  style: CDTextStyle.h1.copyWith(
                    fontSize: 14,
                    color: CDColors.black02,
                  ),
                ),
                Divider(),
                Row(
                  children: [
                    Text(
                      "일시",
                      style: CDTextStyle.body2.copyWith(
                        fontSize: 13,
                        color: CDColors.black04,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "$today",
                      style: CDTextStyle.h1.copyWith(
                        fontSize: 14,
                        color: CDColors.black02,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: Text("취소")),
            TextButton(
                onPressed: () {
                  _sendDoneRequest(productResponseData);
                  Navigator.pop(dialogContext);
                  Navigator.pop(_makingListDialogContext);
                },
                child: Text("확인")),
          ],
        );
      },
    );
  }

  _sendDoneRequest(ProductResponseData productResponseData) async {
    logger.i("done Request");

    productResponseData.product!.state = ProductStateType.done;

    await context.read(productListNotifier).updateProductState(
        productResponseData.productId, productResponseData.product!.state!);
  }

  Future<void> _sendMessageToServer(ChatMessage myMessage) async {
    // 서버에 오더 메세지 쓰기
    await context.read(chatListNotifier).sendMessage(myMessage);
  }

  void onCallPress() async {
    String _phoneNumber = 'tel:' +
        (context.read(userNotifier).otherUserData!.user!.phoneNumber ?? '');
    if (await canLaunch(_phoneNumber)) {
      await launch(_phoneNumber);
    } else {
      throw 'Could not launch ${'tel:' + context.read(systemNotifier).systemConfigData!.phoneNumber!}';
    }
  }

  void onSendEmail() async {
    String email = context.read(userNotifier).otherUserData!.user!.email ?? '';
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunch(emailLaunchUri.toString())) {
      await launch(emailLaunchUri.toString());
    } else {
      throw 'Could not launch ${emailLaunchUri.toString()}';
    }
  }

  void onClosePress() async {
    Navigator.of(context).pop();
  }

  onShowAdditionalButton(UserResponseData otherUserData) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return onShowAdditionalButtonBottomSheet(context, otherUserData);
        },
        backgroundColor: Colors.transparent);
  }

  Widget onShowAdditionalButtonBottomSheet(
      BuildContext context, UserResponseData otherUserData) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: CDColors.white02,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 30, horizontal: kDefaultHorizontalPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      _buildCall(otherUserData);
                    },
                    child: Column(
                      children: [
                        Image.asset('assets/icons/ic_phone_call.png'),
                        SizedBox(height: 8),
                        Text('전화번호'),
                      ],
                    ),
                  ),
                  // SizedBox(width: 20),
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      _buildMail(otherUserData);
                    },
                    child: Column(
                      children: [
                        Image.asset('assets/icons/ic_email.png'),
                        SizedBox(height: 8),
                        Text('메일주소'),
                      ],
                    ),
                  ),
                  // SizedBox(width: 20),
                  InkWell(
                    onTap: () async {
                      getImageAndUploadToServer();
                      Navigator.pop(context);
                    },
                    child: Column(
                      children: [
                        Image.asset('assets/icons/ic_image.png'),
                        SizedBox(height: 8),
                        Text('앨범'),
                      ],
                    ),
                  ),
                  // SizedBox(width: 20),
                  InkWell(
                    onTap: () async {
                      getFileAndUploadToServer();
                      Navigator.pop(context);
                    },
                    child: Column(
                      children: [
                        Image.asset('assets/icons/ic_file.png'),
                        SizedBox(height: 8),
                        Text('파일'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            CDButton(
              width: MediaQuery.of(context).size.width - 48,
              text: LocaleKeys.close.tr(),
              type: ButtonType.transparent,
              press: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void getFileAndUploadToServer() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      List<File> files = [File(result.files.single.path!)];

      await context
          .read(fileControllerNotifier)
          .uploadFiles(files)
          .then((value) async {
        _fileUrl = value!.files!;
      });

      if (_fileUrl.isNotEmpty) {
        _fileUrl.forEach((file) async {
          await _sendFileMessage(file, MessageType.file);
        });
      }
      // loading 닫아야함.
      context.read(fileControllerNotifier).setStateIdle();
    } else {
      // User canceled the picker
    }
  }

  Future<void> getImageAndUploadToServer() async {
    _selectedAssetList = (await CDImagePicker().cameraAndStay(
        context: context, assets: _selectedAssetList, maxAssetsCount: 5))!;

    context.read(fileControllerNotifier).setStateBusy();
    await getFileList();
    await updateImageToServer();
    if (_imageUrl.isNotEmpty) {
      _imageUrl.forEach(
        (image) async {
          await _sendFileMessage(image, MessageType.image);
        },
      );
    }
    // loading 닫아야함.
    context.read(fileControllerNotifier).setStateIdle();
  }

  Future<void> getFileList() async {
    _images.clear();

    for (final AssetEntity asset in _selectedAssetList) {
      // If the entity `isAll`, that's the "Recent" entity you want.
      File? file = await asset.originFile;
      if (file != null) {
        var filePath = file.absolute.path;
        print('original size = ${asset.width} / ${asset.height}');
        if (asset.width > 1080 && asset.height > 1080) {
          final int? shorterSide =
              asset.width < asset.height ? asset.width : asset.height;
          final int resizePercent = (1080.0 / shorterSide! * 100).toInt();

          File compressedFile = await FlutterNativeImage.compressImage(filePath,
              quality: 85, percentage: resizePercent);

          print('resize Percent = $resizePercent');
          print('compressed File = ${compressedFile.toString()}');

          filePath = compressedFile.path;
        }
        try {
          if (filePath.toLowerCase().endsWith(".heic") ||
              filePath.toLowerCase().endsWith(".heif")) {
            String? jpgPath = await HeicToJpg.convert(filePath);
            File file = File(jpgPath!);

            _images.add(file);
          } else {
            File file = File(filePath);

            _images.add(file);
          }
        } on Exception catch (e) {
          print(e.toString());
        }
      }
    }
  }

  Future<File> compressFile(File file) async {
    File compressedFile = await FlutterNativeImage.compressImage(
      file.path,
      quality: 80,
    );
    return compressedFile;
  }

  Future<void> updateImageToServer() async {
    if (_images.isNotEmpty) {
      await context
          .read(fileControllerNotifier)
          .uploadImages(_images)
          .then((value) async {
        _imageUrl = value!.images!;
      });
    }
  }

  void _downloadFile(TaskInfo task) async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      if (Platform.isAndroid) {
        if (task.status != DownloadTaskStatus.complete) {
          final baseStorage = (await getExternalStorageDirectory())!.path;
          String fileName = task.link!.split('/').last;
          String filePath = baseStorage + '/' + fileName;
          print(filePath);
          bool fileExist = await File(filePath).exists();
          if (fileExist == false) {
            task.taskId = await FlutterDownloader.enqueue(
              url: task.link!,
              fileName: fileName,
              savedDir: baseStorage,
            );
          }
        }

        // Share.share(task.link!);
      } else {
        Share.shareFiles([task.link!]);
      }
    } else {
      print('no permission');
    }
  }
}
