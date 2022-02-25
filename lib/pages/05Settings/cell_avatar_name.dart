import 'package:crediApp/global/singleton.dart';
import 'package:flutter/material.dart';
import 'package:crediApp/pages/05Settings/page_user_settings_detail.dart';
import 'package:crediApp/global/constants.dart';

class CellProfile extends StatelessWidget {
  const CellProfile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('PageUserSettingsDetail');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 15),
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
          const SizedBox(height: 13.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Singleton.shared.userData!.user!.email ?? "",
                style: CDTextStyle.regular13black03,
              ),
              Text(
                '계정관리',
                style: CDTextStyle.regular13black03,
              ),
            ],
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
