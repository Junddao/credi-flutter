import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/models/user/user_response_model.dart';
import 'package:crediApp/global/models/user/user_type_model.dart';
import 'package:crediApp/global/singleton.dart';
import 'package:flutter/material.dart';

class PageUserProfile extends StatefulWidget {
  final List<String>? images;
  final UserResponseData? userReponseData;

  PageUserProfile({
    Key? key,
    this.images,
    this.userReponseData,
  }) : super(key: key);

  @override
  _PageUserProfileState createState() => _PageUserProfileState();
}

class _PageUserProfileState extends State<PageUserProfile> {
  @override
  Widget build(BuildContext context) {
    return _buildFactoryProfile(context);
  }

  Widget _buildFactoryProfile(BuildContext context) {
    final FocusScopeNode node = FocusScope.of(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${widget.userReponseData!.user!.name ?? ''}",
              textAlign: TextAlign.right, style: CDTextStyle.h2),
          Divider(color: CDColors.gray8),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Text(
                  "상호명 : ",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: CDColors.gray4,
                  ),
                ),
                Text(" ${widget.userReponseData!.user!.companyName ?? ''}",
                    style: CDTextStyle.p1),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Text(
                  "대표상품 : ",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: CDColors.gray4,
                  ),
                ),
                Text(" ${widget.userReponseData!.user!.mainProduct ?? ''}",
                    style: CDTextStyle.p1),
              ],
            ),
          ),
          Divider(color: CDColors.gray8),
          const SizedBox(
            height: 8,
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              widget.userReponseData!.user!.introduce ?? '',
              style: TextStyle(fontSize: 17, color: CDColors.gray8),
            ),
          ),
          const SizedBox(
            height: kDefaultPadding,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
