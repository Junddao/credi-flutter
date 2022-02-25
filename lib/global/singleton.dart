import 'package:crediApp/global/models/config_model.dart';
import 'package:crediApp/global/models/user/user_model.dart';
import 'package:crediApp/global/models/user/user_response_model.dart';

class Singleton {
  static final shared = Singleton();

  UserResponseData? userData;

  Map<String?, UserResponseData> userMap = {
    "credi":
        UserResponseData(user: User(name: "크레디", email: "hello@credi.co.kr"))
  };

  Future<void> setUser(UserResponseData userResponseData) async {
    updateUserMap(userResponseData);
    Singleton.shared.userData = userResponseData;
    if (Singleton.shared.userData!.user!.email == "hello@credi.co.kr") {
      Singleton.shared.userData!.userId = ConfigModel().crediId;
      // SingletonV2.shared.user =
      //     User.supportJson(userSnapshot.data() as Map<String, dynamic>);
    }
  }

  Future<void> updateUserMap(UserResponseData userResponseData) async {
    userMap['${userResponseData.userId}'] = userResponseData;
  }

  Future<User?> updateCurrentUser(String userId) async {}
}
