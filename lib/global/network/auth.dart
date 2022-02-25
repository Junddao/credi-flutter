import 'dart:convert';
import 'dart:math';

import 'package:crediApp/global/helperfunctions.dart';
import 'package:crediApp/global/models/config_model.dart';
import 'package:crediApp/global/models/sign_in/sign_in_model.dart';
import 'package:crediApp/global/models/sign_in/sign_in_request_model.dart';
import 'package:crediApp/global/models/user/user_model.dart';
import 'package:crediApp/global/models/user/user_response_model.dart';
import 'package:crediApp/global/service/api_service.dart';
import 'package:crediApp/global/service/login_service.dart';
import 'package:crediApp/global/util.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthMethods {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;

  UserResponseData? _userFromFirebase(fb.User? user) {
    User _user = User(
        email: user!.email,
        name: user.displayName ?? '',
        emailVerified: user.emailVerified,
        phoneNumber: user.phoneNumber,
        profileImage: user.photoURL);
    UserResponseData userData = UserResponseData(user: _user);
    return userData;
  }

  Future<UserResponseData?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      fb.UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      fb.User? firebaseUser = result.user;
      await getTokenByServer(firebaseUser);

      return _userFromFirebase(firebaseUser);
    } catch (e) {
      print(e.toString());
      fb.FirebaseAuthException? ex = e as fb.FirebaseAuthException;
      if (ex.code == 'user-not-found') {
        throw '유저를 찾을수 없습니다.';
      } else if (ex.code == 'wrong-password') {
        throw '비밀번호가 잘못 되었습니다..';
      } else {
        throw '메일 주소와 비밀번호를 확인해주세요..';
      }

      /// - **invalid-email**:
      ///  - Thrown if the email address is not valid.
      /// - **user-disabled**:
      ///  - Thrown if the user corresponding to the given email has been disabled.
      /// - **user-not-found**:
      ///  - Thrown if there is no user corresponding to the given email.
      /// - **wrong-password**:
      ///  - Thrown if the password is invalid for the given email, or the account
      ///    corresponding to the email does not have a password set.
      // }
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      print('signUpWithEmailAndPassword()');
      fb.UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      fb.User firebaseUser = result.user!;

      SignInData signInData = await getTokenByServer(firebaseUser);
      signInData.socialEmail = email;

      await firebaseUser.sendEmailVerification();

      return signInData;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<SignInData?> signInWithKakao(String token) async {
    final Map<String, dynamic> data = await LoginService().kakaoLogin(token);

    String customToken = data['customToken'] ?? '';
    String email = data['email'] ?? '';

    fb.UserCredential? result = await _auth.signInWithCustomToken(customToken);

    fb.User? firebaseUser = result.user;
    SignInData signInData = await getTokenByServer(firebaseUser);
    signInData.socialEmail = email;

    return signInData;

    // aws server에 token 요청
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Future<fb.UserCredential> signInWithNaver() async {
  //   // NaverLoginResult res = await FlutterNaverLogin.logIn();
  //   // setState(() {
  //   //     name = res.account.name;
  //   // });

  //   NaverLoginResult res = await FlutterNaverLogin.logIn();
  //   logger.v(res.account);

  //   // NaverAccessToken token = await FlutterNaverLogin.currentAccessToken;
  //   // logger.v(token);
  //   // setState(() {
  //   //   accesToken = res.accessToken;
  //   //   tokenType = res.tokenType;
  //   // });

  //   return fb.FirebaseAuth.instance.signInWithCustomToken("testToken");
  // }

  Future<SignInData?> signInWithNaverWeb() async {
    final clientId = ConfigModel().naverClientId;
    final clientSecret = "ZCQblSahcX";
    final clientState = Uuid().v4();
    String? token;
    String? email;

    String? baseUrl = ConfigModel().serverBaseUrl;

    final url = Uri.https('nid.naver.com', '/oauth2.0/authorize', {
      'response_type': 'code',
      'client_id': clientId,
      'redirect_uri': "$baseUrl/auth/verification/naver",
      // 'redirect_uri': "https://s3.ap-northeast-2.amazonaws.com/test.credi.co.kr/callback.html",
      // "credi://login", //'<네이버에 등록한 authrization_code 받을 return uri 입력>',
      'state': clientState,
    });

    final result = await FlutterWebAuth.authenticate(
        url: url.toString(), callbackUrlScheme: "credi");
    // credi: //login?token=asdlfjasdf

    logger.v(result);
    final body = Uri.parse(result).queryParameters;
    token = body['token'] ?? '';
    email = body['email'] ?? '';
    logger.v(body);
    if (token == null) {
      throw ErrorDescription("Failed to receive Token Failed");
    }

    fb.UserCredential fbUserCredential =
        await fb.FirebaseAuth.instance.signInWithCustomToken(token);
    fb.User? firebaseUser = fbUserCredential.user;

    // aws server에 token 요청
    SignInData signInData = await getTokenByServer(firebaseUser);
    signInData.socialEmail = email;
    return signInData;
  }

  Future<SignInData?> signInWithApple() async {
    var redirectURL = "https://crediapp-0.firebaseapp.com/callback.apple";
    // var redirectURL = "https://crediapp-0.firebaseapp.com/__/auth/handler";
    var clientID = "crediApp.credi.com";

    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
      // webAuthenticationOptions: WebAuthenticationOptions(
      //     clientId: clientID, redirectUri: Uri.parse(redirectURL)),
    );

    print(appleCredential.authorizationCode);
    final oauthCredential = fb.OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
      // accessToken: appleCredential.authorizationCode,
    );

    fb.User? firebaseUser =
        (await fb.FirebaseAuth.instance.signInWithCredential(oauthCredential))
            .user!;

    // aws server에 token 요청
    SignInData signInData = await getTokenByServer(firebaseUser);

    return signInData;

    // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
    // after they have been validated with Apple (see `Integration` section for more information on how to do this)
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return '로그아웃 실패. 다시 시도해주세요.';
    }
  }

  Future<SignInData> getTokenByServer(fb.User? firebaseUser) async {
    // String idToken = await firebaseUser!.getIdToken();
    SignInRequestModel signInRequestModel =
        await LoginService().getSignInRequest(firebaseUser);

    var api = ApiService();
    // Map<String, dynamic> map = {
    //   'firebaseIdToken': idToken,
    //   'osType' : osType,
    //   'osVersion': osVersion,
    //   'deviceModel': deviceModel,
    // };

    Map<String, dynamic> _data =
        await api.post('/auth/signin', signInRequestModel.toMap());
    SignInData signInData = SignInData.fromMap(_data['data']);
    HelperFunctions.writeToken(signInData.token!);

    return signInData;
  }
}

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
