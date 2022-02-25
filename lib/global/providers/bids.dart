import 'package:crediApp/global/models/bid/bid_model.dart';
import 'package:crediApp/global/models/bid/bid_response_model.dart';
import 'package:crediApp/global/providers/parent_provider.dart';
import 'package:crediApp/global/service/api_service.dart';
import 'package:crediApp/global/util.dart';

class BidChangeNotifier extends ParentProvider {
  List<BidResponseData>? bidList = [];

  Future<void> createBid(Bid bid) async {
    try {
      setStateBusy();
      logger.i('start bid create api call .');
      var api = ApiService();
      await api.post('/bid/create', bid.toMap());
      logger.i('End bid create api call .');
      setStateIdle();
    } catch (error) {
      setStateError();
    }
  }

  Future<List<BidResponseData>?> getBidByProductId(int productId) async {
    try {
      setStateBusy();
      logger.i('start bid getBidByProductId api call .');
      var api = ApiService();
      BidResponse bidResponse = BidResponse();
      var response = await api.get('/bid/get/product/${productId.toString()}');
      bidResponse = BidResponse.fromMap(response);
      bidList = bidResponse.data;
      logger.i('End bid getBidByProductId api call .');
      setStateIdle();
      // notifyListeners();
    } catch (error) {
      setStateError();
    }
  }

  Future<List<BidResponseData>?> getMyBidList() async {
    setStateBusy();
    try {
      logger.i('start bid getMyBidList api call .');
      var api = ApiService();
      BidResponse bidResponse = BidResponse();
      var response = await api.get('/bid/get/me');
      bidResponse = BidResponse.fromMap(response);
      bidList = bidResponse.data;
      logger.i('End bid getMyBidList api call .');
      setStateIdle();
    } catch (error) {
      setStateError();
    }

    // singleton 에 user에 써줘야 하지 않나?
  }

  void updateBidList(result) {
    setStateBusy();
    try {
      bidList = result.docs;
      logger.e("\n\n------ $bidList --------");
      setStateIdle();
    } catch (error) {
      setStateError();
    }
  }
}
