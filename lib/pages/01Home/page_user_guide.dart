import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/theme.dart';
import 'package:flutter/material.dart';

class PageUserGudie extends StatelessWidget {
  const PageUserGudie({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      iconTheme: IconThemeData(color: CDColors.nav_title),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Text('이용방법', style: CDTextStyle.nav),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Image.asset('assets/icons/user_guide_intro.png',
                fit: BoxFit.cover),
          ),
          stepWidget('STEP 1', '견적요청', 'assets/icons/ic_intro_product.png',
              '사진 한 장과 제작하려는 제품에 대한 간단한 정보면 제조 견적을 받아볼 수 있어요.'),
          Divider(thickness: 10),
          stepWidget('STEP 2', '견적 비교와 상담', 'assets/icons/ic_intro_chat.png',
              '다양한 업체의 견적서를 비교하고 제조 전 궁금한 점과 확인 해야할 점에 대해 꼼꼼하게 상담 받아보세요.'),
          Divider(thickness: 10),
          stepWidget('STEP 3', '발주', 'assets/icons/ic_intro_order.png',
              '상담 후 거래를 원하는 업체에 바로 발주까지! 이 모든걸 크레디 하나로.'),
        ],
      ),
    );
  }

  Widget stepWidget(
      String title, String subTitle, String image, String description) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: kDefaultHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          Text(title, style: CDTextStyle.bold18blue03),
          Text(subTitle, style: CDTextStyle.bold28black01),
          SizedBox(height: 42),
          Container(
            width: double.infinity,
            height: SizeConfig.screenWidth * 0.6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: CDColors.blue01,
            ),
            child: Container(
              width: SizeConfig.screenWidth * 0.6,
              child: Image.asset(image, fit: BoxFit.contain),
            ),
          ),
          SizedBox(height: 24),
          Text(description, style: CDTextStyle.regular16black02),
          SizedBox(height: 80),
        ],
      ),
    );
  }
}
