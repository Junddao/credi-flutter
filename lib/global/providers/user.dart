import 'package:crediApp/global/models/common_response_model.dart';
import 'package:crediApp/global/models/user/user_request_model.dart';
import 'package:crediApp/global/models/user/user_response_model.dart';
import 'package:crediApp/global/providers/parent_provider.dart';
import 'package:crediApp/global/service/api_service.dart';
import 'package:crediApp/global/singleton.dart';

class UserChangeNotifier extends ParentProvider {
  bool isLoading = false;

  CommonResponse? setUserResponse = CommonResponse();
  UserResponseData? otherUserData = UserResponseData();

  Future<void> setUser(UserRequest users) async {
    try {
      setStateBusy();
      var api = ApiService();

      var response = await api.post('/user/set', users.toMap());
      setUserResponse = CommonResponse.fromMap(response);
      setStateIdle();
    } catch (error) {
      setStateError();
    }
  }

  Future<UserResponseData?> getUser() async {
    UserResponse? userResponse;
    try {
      setStateBusy();
      var api = ApiService();

      var response = await api.get('/user/get/me');
      userResponse = UserResponse.fromMap(response);
      setStateIdle();
    } catch (error) {
      setStateError();
    }

    return userResponse!.data;
  }

  Future<void> getUserById(int id) async {
    try {
      setStateBusy();
      var api = ApiService();

      var response = await api.get('/user/get/index/$id');
      otherUserData = UserResponse.fromMap(response).data!;

      //singleton usermap 에 추가
      Singleton.shared.userMap['${otherUserData!.userId}'] = otherUserData!;
      setStateIdle();
    } catch (error) {
      setStateError();
    }
  }
}
