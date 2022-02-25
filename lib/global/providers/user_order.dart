import 'package:crediApp/global/models/user_order/user_order_accept_model.dart';
import 'package:crediApp/global/models/user_order/user_order_create_reponse_model.dart';
import 'package:crediApp/global/models/user_order/user_order_model.dart';
import 'package:crediApp/global/models/user_order/user_order_response_model.dart';
import 'package:crediApp/global/models/user_order/user_order_view_info_response_model.dart';
import 'package:crediApp/global/providers/parent_provider.dart';
import 'package:crediApp/global/service/api_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class UserOrderChangeNotifier extends ParentProvider {
  UserOrderResponse? userOrderResponse = UserOrderResponse();

  Future<UserOrderCreateResponseData?> createUserOrder(
      UserOrder userOrder) async {
    try {
      setStateBusy();

      var api = ApiService();
      UserOrderCreateResponse userOrderCreateResponse =
          UserOrderCreateResponse();
      var response = await api.post('/user_order/create', userOrder.toMap());
      userOrderCreateResponse = UserOrderCreateResponse.fromMap(response);
      setStateIdle();
      return userOrderCreateResponse.data;
    } catch (error) {
      setStateError();
    }
  }

  Future<void> getUserOrderByMe(UserOrder userOrder) async {
    try {
      setStateBusy();
      var api = ApiService();
      await api.get('/user_order/get/send');
      setStateIdle();
    } catch (error) {
      setStateError();
    }
  }

  Future<void> getUserOrderToMe(UserOrder userOrder) async {
    try {
      setStateBusy();
      var api = ApiService();
      await api.get('/user_order/get/receive');
      setStateIdle();
    } catch (error) {
      setStateError();
    }
  }

  Future<void> accept(UserOrderAccept userOrderAccept) async {
    try {
      setStateBusy();
      var api = ApiService();
      await api.post('/user_order/accept', userOrderAccept.toMap());
      setStateIdle();
    } catch (error) {
      setStateError();
    }
  }

  Future<List<UserOrderResponseData>?> getUserOrderByProductId(
      int productId) async {
    try {
      setStateBusy();
      var api = ApiService();

      var response = await api.get('/user_order/get/product_id/$productId');
      userOrderResponse = UserOrderResponse.fromMap(response);
      setStateIdle();
    } catch (error) {
      setStateError();
    }
  }
}
