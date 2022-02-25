import 'dart:convert';

import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/models/config_model.dart';
import 'package:http/http.dart' as http;
import 'package:crediApp/global/util.dart';

class WebService {
  Future<Map<String, dynamic>> loginWithKakao(token) async {
    final String url = "/auth/verification";
    print("url: $url");
    final params = {
      "type": "kakao",
      "token": token,
    };
    final headers = {"Content-Type": "application/json"};

    Uri uri = Uri.https(ConfigModel().serverBaseUrl, url);
    final http.Response response =
        await http.post(uri, headers: headers, body: json.encode(params));
    // final response = await http.post(Uri(path: url), body: params);

    logger.v(response);
    if (response.statusCode == 200) {
      final result = response.body;
      logger.v(result);
      return jsonDecode(result)['data'];
    } else {
      print('error : ${response.statusCode} failed to login with token');
      print(response.body);
      throw Exception("${response.statusCode} failed to login with token");
    }
  }
}
