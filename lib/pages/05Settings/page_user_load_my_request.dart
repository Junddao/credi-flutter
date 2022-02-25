import 'package:crediApp/generated/locale_keys.g.dart';
import 'package:crediApp/global/components/cdbutton.dart';
import 'package:crediApp/global/components/cdinputfield.dart';
import 'package:crediApp/global/components/plain_text_field.component.dart';
import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/models/config_model.dart';
import 'package:crediApp/global/providers/products.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:crediApp/global/singleton.dart';
import 'package:crediApp/global/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';

class PageUserLoadMyRequest extends StatefulWidget {
  const PageUserLoadMyRequest({Key? key}) : super(key: key);

  @override
  _PageUserLoadMyRequestState createState() => _PageUserLoadMyRequestState();
}

class _PageUserLoadMyRequestState extends State<PageUserLoadMyRequest> {
  final formKey = GlobalKey<FormState>();
  String? code = '';
  TextEditingController _tecPhone = TextEditingController();
  TextEditingController _tecCode = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _tecPhone.dispose();
    _tecCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        appBar: _appBar(),
        body: _body(),
        bottomSheet: _bottomButton(),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: FloatingActionButton(
            onPressed: () {
              onSupport();
            },
            child: Image.asset('assets/icons/ic_lg_support_agent.png'),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat);
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close, color: CDColors.black01),
        ),
      ],
    );
  }

  Widget _bottomButton() {
    return Consumer(
      builder: (_, watch, __) {
        ProductChangeNotifier _productProvider = watch(productListNotifier);
        return code!.length == 6
            ? Container(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
                  child: CDButton(
                    width: double.infinity,
                    text: "불러오기",
                    type: ButtonType.disabled,
                    press: () {},
                  ),
                ),
              )
            : Container(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
                  child: CDButton(
                    width: double.infinity,
                    text: "불러오기",
                    press: () {
                      if (this.formKey.currentState!.validate() == false) {
                        return;
                      }

                      _productProvider
                          .loadProductFromWeb(_tecPhone.text, _tecCode.text)
                          .then((value) {
                        print('my request success');
                        this.formKey.currentState!.save();
                        Navigator.of(context)
                            .pushNamed('PageSuccessLoadMyRequest');
                      }).catchError((onError) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: CDColors.red01,
                          content: Text('입력 정보가 잘못되었습니다. 확인 후 다시 시도하세요.',
                              style: CDTextStyle.bold14white02),
                        ));
                      });
                    },
                  ),
                ),
              );
      },
    );
  }

  Widget _body() {
    final node = FocusScope.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: kDefaultHorizontalPadding,
                vertical: kDefaultVerticalPadding),
            child: Form(
              key: this.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('견적 요청 내역', style: CDTextStyle.bold20black01),
                  Text('불러오기', style: CDTextStyle.bold20black01),
                  SizedBox(height: 16),
                  Text('발급 받으신 6자리 코드를 입력해주세요.',
                      style: CDTextStyle.regular14black03),
                  SizedBox(height: 56),
                  Text('휴대폰번호', style: CDTextStyle.regular14blue03),
                  CDInputField(
                    controller: _tecPhone,
                    keyboardType: TextInputType.phone,
                    // title: "연락처",
                    hintText: '휴대폰 번호를 입력하세요.',
                    validator: (value) {
                      return value == null || value.length < 1
                          ? "연락처를 확인해주세요"
                          : null;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text('요청코드', style: CDTextStyle.regular14blue03),
                  CDInputField(
                    controller: _tecCode,
                    // keyboardType: TextInputType.phone,
                    // title: "연락처",
                    hintText: '코드를 입력해주세요.',

                    validator: (val) {
                      if (val!.length < 1) {
                        return '코드를 입력하세요..';
                      }

                      if (val.length < 6) {
                        return '코드는 6개의 숫자와 문자의 조합입니다.';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  // 하단 버튼 사이즈 만큼 공백 추가.
                  const SizedBox(height: 90),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  onSupport() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: buildBottomSheet,
        backgroundColor: Colors.transparent);
  }

  Widget buildBottomSheet(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: CDColors.white02,
      ),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/icons/help_circle.png'),
            SizedBox(
              height: 30,
            ),
            Text(
              LocaleKeys.customer_center_help_title.tr(),
              style: CDTextStyle.regular24black01,
            ),
            SizedBox(height: 20),
            Text(LocaleKeys.customer_center_help_subtitle.tr(),
                style: CDTextStyle.regular13black03),
            SizedBox(height: 20),
            Text(LocaleKeys.customer_center_work_time.tr(),
                style: CDTextStyle.regular13black03),
            SizedBox(height: 20),
            CDButton(
              width: MediaQuery.of(context).size.width - 48,
              text: "채팅 상담",
              press: onChatPress,
            ),
            SizedBox(height: 20),
            CDButton(
              width: MediaQuery.of(context).size.width - 48,
              text: "전화 상담",
              press: onCallPress,
            ),
            SizedBox(height: 20),
            Center(
              child: TextButton(
                child: Text(
                  '닫기',
                  style: CDTextStyle.regular18black03,
                ),
                onPressed: onClosePress,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onChatPress() async {
    createChatRoomAndStartConversation(
      context: _scaffoldKey.currentContext,
      otherUserId: ConfigModel().crediId,
    );
  }

  void onCallPress() async {
    if (await canLaunch(
        'tel:' + context.read(systemNotifier).systemConfigData!.phoneNumber!)) {
      await launch(
          'tel:' + context.read(systemNotifier).systemConfigData!.phoneNumber!);
    } else {
      throw 'Could not launch ${'tel:' + context.read(systemNotifier).systemConfigData!.phoneNumber!}';
    }
  }

  void onClosePress() async {
    Navigator.of(context).pop();
  }

  createChatRoomAndStartConversation(
      {BuildContext? context, int? otherUserId}) async {
    if (otherUserId == Singleton.shared.userData!.userId) {
      return;
    }
    String chatRoomId =
        getChatRoomId(otherUserId!, Singleton.shared.userData!.userId!);
    List<int?> users = [otherUserId, Singleton.shared.userData!.userId!];
    Map<String, dynamic> chatRoomMap = {
      "user": users,
      "chat_room_id": chatRoomId
    };

    logger.i("chat with : $otherUserId");
    await Navigator.of(context!).pushNamed('PageChatDetail',
        arguments: [otherUserId, 0, 0]).then((value) async {
      context.read(chatListNotifier).chatGetNewMessageCount();
    });
  }
}
