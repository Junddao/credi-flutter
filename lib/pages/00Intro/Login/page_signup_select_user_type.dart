import 'package:flutter/material.dart';

class PageSignUpSelectUserType extends StatefulWidget {
  @override
  _PageSignUpSelectUserTypeState createState() =>
      _PageSignUpSelectUserTypeState();
}

class _PageSignUpSelectUserTypeState extends State<PageSignUpSelectUserType> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("어떤 서비스를 사용하시고 싶으신가요?"),
          Row(
            children: [
              FlatButton(onPressed: null, child: Text("생산 의뢰를 하고 싶습니다.")),
              FlatButton(onPressed: null, child: Text("의뢰를 받고싶은 공장입니다."))
            ],
          )
        ],
      ),
    );
  }
}
