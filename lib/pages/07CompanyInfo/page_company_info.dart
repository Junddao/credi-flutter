import 'package:cached_network_image/cached_network_image.dart';
import 'package:crediApp/generated/locale_keys.g.dart';
import 'package:crediApp/global/components/rating_bar_indicator.dart';
import 'package:crediApp/global/components/view_state_container.dart';
import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/enums/view_state.dart';
import 'package:crediApp/global/models/rating/rating_response_model.dart';

import 'package:crediApp/global/models/user/user_response_model.dart';
import 'package:crediApp/global/providers/parent_provider.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:crediApp/global/providers/rating.dart';
import 'package:crediApp/global/providers/user.dart';
import 'package:crediApp/global/components/photo_with_dot_indicator.dart';
import 'package:crediApp/pages/99Others/error_page.dart';
import 'package:crediApp/pages/details/product_poster.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

class PageCompanyInfo extends StatefulWidget {
  const PageCompanyInfo({this.otherUserId, Key? key}) : super(key: key);

  final int? otherUserId;
  @override
  _PageCompanyInfoState createState() => _PageCompanyInfoState();
}

class _PageCompanyInfoState extends State<PageCompanyInfo> {
  UserResponseData? companyInfo;
  bool isExpandIndroduce = false;
  @override
  void initState() {
    initViewState();
    Future.microtask(() {
      context.read(userNotifier).getUserById(widget.otherUserId!);
      context.read(ratingListNotifier).getRatingById(widget.otherUserId!);
    }).then((value) => uninitViewState());
    super.initState();
  }

  @override
  void dispose() {
    uninitViewState();
    super.dispose();
  }

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
      elevation: 1,
      centerTitle: true,
      title: Text('업체정보', style: CDTextStyle.nav),
    );
  }

  Widget _body() {
    Size size = MediaQuery.of(context).size;

    return Consumer(
      builder: (context, watch, _) {
        UserChangeNotifier _userProvider = watch(userNotifier);
        RatingChangeNotifier _ratingProvider = watch(ratingListNotifier);

        if (_userProvider.state == ViewState.Busy ||
            _ratingProvider.state == ViewState.Busy ||
            isInitLoading == true) {
          return ViewStateContainer.busyContainer();
        } else if (_userProvider.state == ViewState.Error ||
            _ratingProvider.state == ViewState.Error) {
          return ErrorPage();
        }

        final companyUser = _userProvider.otherUserData!.user!;
        final List<RatingResponseData>? ratings = _ratingProvider.ratingData;
        return SingleChildScrollView(
          child: Column(
            children: [
              ProductPoster(
                size: size,
                items: companyUser.companyImages ?? [],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: <Widget>[
                        (companyUser.profileImage == null ||
                                companyUser.profileImage == '')
                            ? CircleAvatar(
                                radius: 30.0,
                                child: Icon(Icons.person),
                                backgroundColor: CDColors.gray3,
                                foregroundColor: CDColors.gray1,
                              )
                            : CircleAvatar(
                                radius: 30.0,
                                backgroundColor: CDColors.gray3,
                                foregroundColor: CDColors.gray1,
                                backgroundImage: CachedNetworkImageProvider(
                                    companyUser.profileImage!),
                              ),
                        // child:
                        //     Image.network(companyUser.profileImage!)),
                        const SizedBox(width: 10.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                Text(
                                  companyUser.companyName ?? '회사명이 없습니다.',
                                  style: CDTextStyle.bold24black01,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '후기 (${ratings!.length} 개)',
                                  style: CDTextStyle.regular14black04,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  getRatingAverage(ratings).toStringAsFixed(1),
                                  style: CDTextStyle.regular16blue03,
                                ),
                                SizedBox(width: 8),
                                CDRatingBar().indicator(
                                    rating: getRatingAverage(ratings)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(companyUser.name ?? '이름이 업습니다.',
                        style: CDTextStyle.bold16black01),
                    SizedBox(height: 10),
                    Text(
                      companyUser.introduce ?? '소개글이 없습니다.',
                      style: CDTextStyle.regular14black03
                          .merge(TextStyle(height: 1.6)),
                      maxLines: isExpandIndroduce == false ? 4 : 2000,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            isExpandIndroduce = !isExpandIndroduce;
                            setState(() {});
                          },
                          child: Text(
                            isExpandIndroduce == false ? '더보기' : '접기',
                            style: CDTextStyle.bold14black03underline,
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 30),
                    _buildReviewList(ratings),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void getCompanyInfo() {
    companyInfo = context.read(userNotifier).otherUserData;
  }

  double getRatingAverage(List<RatingResponseData>? ratings) {
    if (ratings!.length == 0) {
      return 0.0;
    }
    double average = 0;
    for (RatingResponseData data in ratings) {
      average += data.rating!.score!;
    }
    average = average / ratings.length;
    return average;
  }

  Widget _buildReviewList(List<RatingResponseData>? ratings) {
    return ratings!.length == 0
        ? SizedBox.shrink()
        //emptyReview()
        : ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var ratingData = ratings[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ratingData.name!, style: CDTextStyle.regular13black01),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CDRatingBar().indicator(
                          rating: ratingData.rating!.score!, starSize: 12),
                      Text(
                        ratingData.createdAt!.substring(0, 10),
                        style: CDTextStyle.regular9black03,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    ratingData.rating!.review ?? '리뷰가 없는 후기입니다.',
                    style: CDTextStyle.regular13black01,
                  ),
                  SizedBox(height: 8),
                  PhotoWithDotIndicator(
                    imageUrls: ratings[index].rating!.imageUrl ?? [],
                  ),
                  SizedBox(height: 16),
                ],
              );
            },
            separatorBuilder: (context, index) => Divider(),
            itemCount: ratings.length);
  }

  Widget emptyReview() {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Image.asset('assets/icons/ic_smile.png'),
          SizedBox(height: 16),
          Text(LocaleKeys.review_new_customer_contents1.tr()),
          Text(LocaleKeys.review_new_customer_contents2.tr()),
        ],
      ),
    );
  }
}
