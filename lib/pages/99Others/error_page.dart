import 'package:crediApp/generated/locale_keys.g.dart';
import 'package:crediApp/global/enums/tab_type.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:crediApp/global/providers/tabstates.dart';
import 'package:crediApp/global/theme.dart';
import 'package:crediApp/global/components/cdbutton.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Consumer(builder: (_, watch, __) {
        TabStates _tabProvider = watch(tabProvider);
        return Padding(
          padding: const EdgeInsets.all(24),
          child: CDButton(
            width: MediaQuery.of(context).size.width - 48,
            text: LocaleKeys.confirm.tr(),
            type: ButtonType.dark,
            press: () {
              _tabProvider.setSelectedIndex(TabType.PageHome.index);
              Navigator.of(context).popUntil(ModalRoute.withName('PageTabs'));
              // Navigator.of(context)
              //     .pushNamedAndRemoveUntil('PageTabs', (route) => false);
            },
          ),
        );
      }),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/icons/attention.png'),
            SizedBox(
              height: 24,
            ),
            Text(LocaleKeys.new_version_title.tr(),
                style: CDTextStyle.bold20black01),
            SizedBox(height: 24),
            Text(
              LocaleKeys.new_version_contents.tr(),
              style: CDTextStyle.regular16black03.merge(TextStyle(height: 1.5)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
