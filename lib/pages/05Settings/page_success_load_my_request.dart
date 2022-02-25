import 'package:crediApp/global/components/cdbutton.dart';
import 'package:crediApp/global/enums/tab_type.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:crediApp/global/providers/tabstates.dart';
import 'package:crediApp/global/style/cdtextstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageSuccessLoadMyRequest extends ConsumerWidget {
  const PageSuccessLoadMyRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      bottomSheet: Container(
        padding: const EdgeInsets.all(24),
        color: Colors.transparent,
        child: CDButton(
          width: MediaQuery.of(context).size.width - 48,
          text: '견적함 확인',
          type: ButtonType.dark,
          press: () {
            goToProductPage(context, watch);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/icons/ic_check.png'),
            SizedBox(
              height: 24,
            ),
            Text('불러오기 완료', style: CDTextStyle.bold20black01),
            SizedBox(height: 24),
            Text(
              '요청하신 견적을 위한 공장을 찾고 있습니다.\n견적은 최대 24시간 이내 발송됩니다.',
              style: CDTextStyle.regular16black03.merge(TextStyle(height: 1.5)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void goToProductPage(context, watch) {
    TabStates provider = watch(tabProvider);
    provider.setSelectedIndex(TabType.PageHome.index);

    Navigator.of(context).popUntil(ModalRoute.withName('PageTabs'));

    // Navigator.of(context).pushNamedAndRemoveUntil('PageTabs', (route) => false,
    //     arguments: TabType.PageProductList.index);
  }
}
