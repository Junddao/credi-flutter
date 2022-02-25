import 'package:crediApp/global/models/info/event_response_model.dart';
import 'package:crediApp/global/models/info/factory_board_response_model.dart';
import 'package:crediApp/global/models/info/faq_response_model.dart';
import 'package:crediApp/global/models/info/magazine_response_model.dart';
import 'package:crediApp/global/models/system/system_app_version.dart';
import 'package:crediApp/global/providers/parent_provider.dart';
import 'package:crediApp/global/service/api_service.dart';

class InfoChangeNotifier extends ParentProvider {
  List<EventResponseData>? eventResponseDatas = [];
  List<FaqResponseData>? faqResponseDatas = [];
  List<MagazineResponseData>? magazineResponseDatas = [];
  List<FactoryBoardResponseData>? factoryBoardResponseData = [];

  int selectedFactoryBoardCategoryIndex = 0;

  void selectFaqItem(index) {
    faqResponseDatas![index].faq!.isSelected =
        !(faqResponseDatas![index].faq!.isSelected!);
    notifyListeners();
  }

  void selectFactoryBoardItem(int _selectedFactoryBoardCategoryIndex) {
    selectedFactoryBoardCategoryIndex = _selectedFactoryBoardCategoryIndex;
    notifyListeners();
  }

  Future<String?> getFactoryBoard(String category) async {
    try {
      setStateBusy();

      var api = ApiService();
      var response = await api.getWithoutToken('/info/factory_board/$category');
      FactoryBoardResponse factoryBoardResponse =
          FactoryBoardResponse.fromMap(response);
      factoryBoardResponseData = factoryBoardResponse.data;

      setStateIdle();
    } catch (error) {
      setStateError();
    }
  }

  Future<String?> getEvent() async {
    try {
      setStateBusy();

      var api = ApiService();
      var response = await api.getWithoutToken('/info/event');
      EventResponse eventResponse = EventResponse.fromMap(response);
      eventResponseDatas = eventResponse.data;

      setStateIdle();
    } catch (error) {
      setStateError();
    }
  }

  Future<String?> getFaq() async {
    try {
      setStateBusy();

      var api = ApiService();
      var response = await api.getWithoutToken('/info/faq');
      FaqResponse faqResponse = FaqResponse.fromMap(response);
      faqResponseDatas = faqResponse.data;

      setStateIdle();
    } catch (error) {
      setStateError();
    }
  }

  Future<String?> getMagazine() async {
    try {
      setStateBusy();

      var api = ApiService();
      var response = await api.getWithoutToken('/info/magazine');
      MagazineResponse magazineResponse = MagazineResponse.fromMap(response);
      magazineResponseDatas = magazineResponse.data;

      setStateIdle();
    } catch (error) {
      setStateError();
    }
  }
}
