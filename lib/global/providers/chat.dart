import 'dart:convert';

import 'package:crediApp/global/models/chat/chat_create_request_model.dart';
import 'package:crediApp/global/models/chat/chat_get_all_response_model.dart';
import 'package:crediApp/global/models/chat/chat_get_message_response_model.dart';
import 'package:crediApp/global/models/chat/chat_message_model.dart';
import 'package:crediApp/global/models/common_response_model.dart';
import 'package:crediApp/global/models/web_socket/web_socket_message_model.dart';
import 'package:crediApp/global/providers/parent_provider.dart';
import 'package:crediApp/global/service/api_service.dart';
import 'package:crediApp/global/util.dart';

class ChatChangeNotifier extends ParentProvider {
  List<ChatGetAllResponseData>? chatGetAllResponseData = [];
  List<ChatGetMessageResponseData>? chatGetMessageResponseData = [];
  int? id = 0;

  int? newMessage = 0;

  Future<int> chatCreate(ChatCreateRequest chat) async {
    try {
      setStateBusy();
      logger.d('/chat/create');

      var api = ApiService();
      var response = await api.post('/chat/create', chat.toMap());
      CommonResponse commonResponse = CommonResponse.fromMap(response);
      id = commonResponse.data['id'];

      setStateIdle();
    } catch (error) {
      setStateError();
    }

    return id!;
  }

  Future<void> sendMessage(ChatMessage chatMessage) async {
    try {
      // setStateBusy();
      var api = ApiService();
      await api.post('/chat/send_message', chatMessage.toMap());
      // setStateIdle();
      notifyListeners();
    } catch (error) {
      setStateError();
    }
  }

  Future<void> chatGetAll() async {
    try {
      setStateBusy();
      var api = ApiService();

      var response = await api.get('/chat/get/all');
      ChatGetAllResponse chatGetAllResponse =
          ChatGetAllResponse.fromMap(response);
      chatGetAllResponseData = chatGetAllResponse.data;
      setStateIdle();
    } catch (error) {
      setStateError();
    }
  }

  Future<void> chatGetMessageAllByChatRoomId(int chatRoomId) async {
    try {
      setStateBusy();
      var api = ApiService();

      var response = await api.get('/chat/get/message/all/$chatRoomId');
      ChatGetMessageResponse chatGetMessageResponse =
          ChatGetMessageResponse.fromMap(response);
      chatGetMessageResponseData = chatGetMessageResponse.data;
      setStateIdle();
    } catch (error) {
      setStateError();
    }
  }

  Future<bool?> chatGetNewMessageCount() async {
    try {
      setStateBusy();
      var api = ApiService();

      Map<String, dynamic> data = await api.get('/chat/get/new_message_count');

      newMessage = data['data']['count'];
      setStateIdle();
      return newMessage != null ? true : false;
    } catch (error) {
      setStateError();
    }
  }

  Future<int> chatGetId(int clientId, int factoryId) async {
    CommonResponse? commonResponse;
    try {
      setStateBusy();
      var api = ApiService();

      var response = await api.get('/chat/get/id/$clientId/$factoryId');
      commonResponse = CommonResponse.fromMap(response);
      setStateIdle();
    } catch (error) {
      setStateError();
    }

    return commonResponse!.data['id'];
  }

  Future<List<ChatGetMessageResponseData>> getMessageNew(
      int chatRoomId, String lastMessageTime, int chatMessageId) async {
    late List<ChatGetMessageResponseData> chatGetMessageResponseData;
    try {
      setStateBusy();
      Map<String, dynamic> map = {
        'chatRoomId': chatRoomId,
        'lastMessageTime': lastMessageTime,
        'lastMessageId': chatMessageId,
      };
      var api = ApiService();
      var response = await api.post('/chat/get/message/new', map);
      ChatGetMessageResponse chatGetMessageResponse =
          ChatGetMessageResponse.fromMap(response);
      chatGetMessageResponseData = chatGetMessageResponse.data!;
      setStateIdle();
    } catch (error) {
      setStateError();
    }

    return chatGetMessageResponseData;
  }

  Future<void> updateMessageDatas(
      List<ChatGetMessageResponseData> newMessageData) async {
    try {
      setStateBusy();
      newMessageData.forEach((element) {
        chatGetMessageResponseData!.insert(0, element);
      });

      setStateIdle();
      notifyListeners();
    } catch (error) {
      setStateError();
    }
  }

  Future<void> updateOrderState(WebSocketMessage webSocketMessage) async {
    try {
      setStateBusy();
      chatGetMessageResponseData!.forEach((element) {
        if (element.chatMessage!.userOrderId == webSocketMessage.orderId) {
          element.orderInfo!.orderState = webSocketMessage.data;
        }
      });
      setStateIdle();
      notifyListeners();
    } catch (error) {
      setStateError();
    }
  }
}
