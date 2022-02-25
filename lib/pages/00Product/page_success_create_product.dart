import 'package:crediApp/generated/locale_keys.g.dart';
import 'package:crediApp/global/components/cdbutton.dart';
import 'package:crediApp/global/enums/tab_type.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:crediApp/global/providers/tabstates.dart';
import 'package:crediApp/global/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SuccessCreateProductPage extends StatefulWidget {
  const SuccessCreateProductPage({Key? key}) : super(key: key);

  @override
  _SuccessCreateProductPageState createState() =>
      _SuccessCreateProductPageState();
}

class _SuccessCreateProductPageState extends State<SuccessCreateProductPage> {
  @override
  void initState() {
    Future.microtask(() {
      context.read(productListNotifier).getMyProductList().then((value) {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Consumer(builder: (_, watch, __) {
        TabStates _tabProvider = watch(tabProvider);
        return Container(
          padding: const EdgeInsets.all(24),
          color: Colors.transparent,
          child: CDButton(
            width: MediaQuery.of(context).size.width - 48,
            text: LocaleKeys.success_create_product_button_text.tr(),
            type: ButtonType.dark,
            press: () {
              goToProductPage(context, _tabProvider);
            },
          ),
        );
      }),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/icons/ic_check.png'),
            SizedBox(
              height: 24,
            ),
            Text(LocaleKeys.success_create_product_title.tr(),
                style: CDTextStyle.bold20black01),
            SizedBox(height: 24),
            Text(
              LocaleKeys.success_create_product_subtitle.tr(),
              style: CDTextStyle.regular16black03.merge(TextStyle(height: 1.5)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void goToProductPage(context, TabStates _tabProvider) {
    _tabProvider.setSelectedIndex(TabType.PageProductList.index);
    Navigator.of(context).popUntil(ModalRoute.withName('PageTabs'));

    // Navigator.of(context).pushNamedAndRemoveUntil('PageTabs', (route) => false,
    //     arguments: TabType.PageProductList.index);
  }
}
