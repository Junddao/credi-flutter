import 'package:crediApp/global/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:crediApp/global/constants.dart';

class CellChatHeader extends StatelessWidget {
  const CellChatHeader({
    Key? key,
    this.name,
    this.onProfile,
    this.onRequestOrder,
  }) : super(key: key);

  final String? name;
  final Function? onProfile;
  final Function? onRequestOrder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildProfile(context),
          Spacer(),
          RoundedButton(
            text: "발주",
            height: 38,
            color: CDColors.blue5,
            textColor: Colors.white,
            press: onRequestOrder,
          ),
        ],
      ),
    );
  }

  Widget _buildProfile(BuildContext context) {
    return InkWell(
      onTap: onProfile as void Function()?,
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 20.0,
            child: Icon(Icons.person),
            backgroundColor: CDColors.gray3,
            foregroundColor: CDColors.gray1,
          ),
          const SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                name ?? "",
                style: TextStyle(
                  color: CDColors.gray7,
                  fontSize: 16.0,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              // InkWell(
              //   onTap: onProfile,
              //   child: Container(
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
                // height: 20,
                child: Text(
                  "프로필 보기 >",
                  style: TextStyle(
                    color: CDColors.gray6,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
