import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:crediApp/global/components/cdinputfield.dart';
import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/helperfunctions.dart';
import 'package:crediApp/global/models/user/user_request_model.dart';
import 'package:crediApp/global/models/user/user_type_model.dart';
import 'package:crediApp/global/network/auth.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:crediApp/global/service/text_input_formatter_phone.dart';
import 'package:crediApp/global/singleton.dart';
import 'package:crediApp/global/util.dart';
import 'package:crediApp/global/components/add_photo_button.dart';
import 'package:crediApp/global/components/cdbutton.dart';
import 'package:crediApp/global/components/delete_photo_button.dart';
import 'package:crediApp/global/components/photo_page_indicator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:random_string/random_string.dart';

class PageUserSettingsDetail extends StatefulWidget {
  @override
  _PageUserSettingsDetailState createState() => _PageUserSettingsDetailState();
}

class _PageUserSettingsDetailState extends State<PageUserSettingsDetail> {
  late TextEditingController _tecName;
  late TextEditingController _tecCompany;
  late TextEditingController _tecPhone;
  late TextEditingController _tecAddress;
  late TextEditingController _tecMainProduct;
  late TextEditingController _tecCompanyId;
  late TextEditingController _tecIntroduce;

  AuthMethods authMethods = new AuthMethods();

  SwiperController _swiperController = SwiperController();
  List<File> _images = [];
  List<String>? _imageUrl = [];
  int _imageIndex = 0;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  // int selectedIndex = Singleton.shared.user.isFactory ? 1 : 0;
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();

    _tecName = TextEditingController();
    _tecCompany = TextEditingController();
    _tecPhone = TextEditingController();
    _tecAddress = TextEditingController();
    _tecMainProduct = TextEditingController();
    _tecCompanyId = TextEditingController();
    _tecIntroduce = TextEditingController();

    logger.i(Singleton.shared.userData!.userId);
    _tecName.text = Singleton.shared.userData!.user!.name!;
    _tecCompanyId.text = Singleton.shared.userData!.user!.companyNumber ?? "";
    _tecCompany.text = Singleton.shared.userData!.user!.companyName ?? "";
    _tecPhone.text = Singleton.shared.userData!.user!.phoneNumber ?? "";

    _tecAddress.text = Singleton.shared.userData!.user!.address ?? "";
    _tecMainProduct.text = Singleton.shared.userData!.user!.mainProduct ?? "";
    _tecIntroduce.text = Singleton.shared.userData!.user!.introduce ?? "";
    _imageUrl = [];
    _images = [];
  }

  @override
  void dispose() {
    _tecName.dispose();
    _tecCompany.dispose();
    _tecPhone.dispose();
    _tecAddress.dispose();
    _tecMainProduct.dispose();
    _tecCompanyId.dispose();
    _tecIntroduce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      bottomSheet: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
          child: CDButton(
            width: size.width - 40,
            text: "저장",
            press: _updateUser,
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Column(
          children: [
            Padding(
              //
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      children: [
                        Container(
                          // padding: EdgeInsets.all(10),
                          child: Form(
                              key: _formKey,
                              child: _buildUserForm(size, context)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      "알람설정",
                      style: CDTextStyle.regular16black01,
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed('PageUserAlarmSetting');
                    },
                  ),
                  ListTile(
                    title: Text(
                      "로그아웃",
                      style: CDTextStyle.regular16black01,
                    ),
                    onTap: logout,
                  ),
                ],
              ),
            ),
            // 하단 버튼 사이즈 만큼 공백 추가.
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }

  void logout() {
    authMethods.signOut().then((value) {
      if (value is String) {
        // fail
        logger.i(value);
        Scaffold.of(context).showSnackBar(SnackBar(content: Text(value)));
      } else {
        // success
        final fcm = FirebaseMessaging.instance;
        fcm.unsubscribeFromTopic(Singleton.shared.userData!.userId.toString());

        HelperFunctions.logout();
        Singleton.shared.userData = null;
        HelperFunctions.removeToken();

        Navigator.of(context)
            .pushNamedAndRemoveUntil('PageLogin', (route) => false);
      }
    });
  }

  Widget _buildUserForm(Size size, BuildContext context) {
    final FocusScopeNode node = FocusScope.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: '안녕하세요 ', style: CDTextStyle.bold18black01),
                TextSpan(
                    text: '${Singleton.shared.userData!.user!.name}',
                    style: CDTextStyle.bold18blue03),
                TextSpan(text: '님!', style: CDTextStyle.bold18black01),
              ],
            ),
          ),
          SizedBox(height: 20),
          CDInputField(
            controller: _tecName,
            title: "이름:",
            hintText: "이름을 입력해주세요",
            warningMessage: "이름을 입력해주세요",
            onEditingComplete: () => node.nextFocus(),
          ),
          CDInputField(
            controller: _tecCompany,
            title: "회사명 (선택):",
            hintText: "회사명을 입력해주세요",
            onEditingComplete: () => node.nextFocus(),
          ),
          CDInputField(
            controller: _tecPhone,
            title: "연락처:",
            hintText: "거래처와의 연락 및 고객지원을 위해 사용됩니다.",
            warningMessage: "연락처를 입력해주세요",
            keyboardType: TextInputType.phone,
            inputFormatters: [TextInputFormatterPhone()],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: CDColors.nav_title),
      backgroundColor: Colors.white,
      elevation: 1,
      centerTitle: true,
      title: Text("계정관리", style: CDTextStyle.nav),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: _dismiss,
      ),
    );
  }

  Widget _decideImageView(File? imageFile) {
    if (imageFile == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "포트폴리오 생산품 및 업체 전경을 올려주세요",
              textAlign: TextAlign.center,
            ),
            Icon(Icons.photo),
          ],
        ),
      );
    } else {
      return Image.file(
        imageFile,
        width: 80,
        height: 80,
      );
    }
  }

  void _dismiss() {
    Navigator.of(context).pop();
  }

  void _updateUser() {
    logger.i("uploadPost");
    if (!_formKey.currentState!.validate()) {
      logger.i("1");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("빈칸을 채워주세요."),
        ),
      );
      return;
    }

    logger.i("parse quantity");
    logger.i("${_tecName.text}");
    // logger.i("title: ${tecTitle.text}\nquantity : $quantity");
    logger.i("${Singleton.shared.userData!.userId}");

    Singleton.shared.userData!.user = Singleton.shared.userData!.user!.copyWith(
      name: _tecName.text,
      companyNumber: _tecCompanyId.text,
      companyName: _tecCompany.text,
      introduce: _tecIntroduce.text,
      companyImages: _imageUrl,
      phoneNumber: _tecPhone.text,
      address: _tecAddress.text,
      mainProduct: _tecMainProduct.text,
    );

    context
        .read(userNotifier)
        .setUser(UserRequest(user: Singleton.shared.userData!.user!))
        .then((value) async {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("저장되었습니다."),
        ),
      );

      Navigator.pop(context);
    });
  }

  onIndexChanged(int index) {
    this.setState(() {
      _imageIndex = index;
    });
  }

  deleteImage() {
    var tempIndex = _imageIndex;
    if (_imageUrl!.length == 1) {
      removeImageAt(tempIndex);
    } else {
      _swiperController.previous().then((result) {
        Future.delayed(Duration(milliseconds: 200), () {
          removeImageAt(tempIndex);
        });
      });
    }
  }

  removeImageAt(int index) {
    _imageUrl!.removeAt(index);
    this.setState(() {
      _images.remove(_images[index]);
    });
  }

  buildPageIndicator() {
    return _images.length > 0
        ? PhotoPageIndicator("${_imageIndex + 1}/${_images.length}")
        : Container();
  }
}
