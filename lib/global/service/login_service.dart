import 'dart:convert';
import 'dart:io';

import 'package:crediApp/global/models/config_model.dart';
import 'package:crediApp/global/models/sign_in/sign_in_request_model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:package_info/package_info.dart';

class LoginService {
  Future<Map<String, dynamic>> kakaoLogin(String token) async {
    final String _path = "/auth/verification";
    final map = {
      "type": "kakao",
      "token": token,
    };
    final _headers = {"Content-Type": "application/json"};

    var _data = jsonEncode(map);

    print('${ConfigModel().serverBaseUrl}');
    var response = await Dio()
        .post(
          '${ConfigModel().serverBaseUrl}$_path',
          data: _data,
          options: Options(
            headers: _headers,
          ),
        )
        .timeout(Duration(seconds: 10));

    print('Api get : url $_path  done.');
    print('dio response = ${response.toString()}');
    if (response.statusCode == 200) {
      return response.data['data'];
    } else {
      print('error : ${response.statusCode} failed to login with token');
      print(response.data);
      throw Exception("${response.statusCode} failed to login with token");
    }
    //
  }

  Future<SignInRequestModel> getSignInRequest(firebaseUser) async {
    SignInRequestModel signInRequestModel = SignInRequestModel();
    var deviceInfo = DeviceInfoPlugin();

    String? firebaseIdToken = await firebaseUser!.getIdToken();
    String? deviceModel = '';
    String? osType = '';
    String? osVersion = '';

    if (Platform.isAndroid) {
      var androidInfo = await deviceInfo.androidInfo;
      var release = androidInfo.version.release;
      var sdkInt = androidInfo.version.sdkInt;

      deviceModel = androidInfo.model!;
      osType = 'Android';
      osVersion = "Android $release (SDK $sdkInt)";
    } else if (Platform.isIOS) {
      var iosInfo = await deviceInfo.iosInfo;
      var version = iosInfo.systemVersion;
      var machine = iosInfo.utsname.machine;

      deviceModel = machine;
      osType = 'IOS';
      osVersion = version;
    }

    signInRequestModel.firebaseIdToken = firebaseIdToken;
    signInRequestModel.deviceModel = deviceModel;
    signInRequestModel.osType = osType;
    signInRequestModel.osVersion = osVersion;

    return signInRequestModel;
  }
}
