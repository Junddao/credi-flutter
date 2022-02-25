import 'package:cached_network_image/cached_network_image.dart';
import 'package:crediApp/global/components/cdbutton.dart';
import 'package:crediApp/global/components/view_state_container.dart';
import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/enums/view_state.dart';
import 'package:crediApp/global/models/bid/bid_response_model.dart';
import 'package:crediApp/global/models/product/product_response_model.dart';
import 'package:crediApp/global/providers/parent_provider.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:crediApp/global/providers/user.dart';
import 'package:crediApp/global/service/service_string_utils.dart';
import 'package:crediApp/global/singleton.dart';
import 'package:crediApp/global/theme.dart';
import 'package:crediApp/global/util.dart';
import 'package:crediApp/pages/99Others/error_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageProductBidDetail extends StatefulWidget {
  final BidResponseData bidResponseData;
  final ProductResponseData productResponseData;

  const PageProductBidDetail({
    Key? key,
    required this.bidResponseData,
    required this.productResponseData,
  }) : super(key: key);

  @override
  _PageProductBidDetailState createState() => _PageProductBidDetailState();
}

class _PageProductBidDetailState extends State<PageProductBidDetail> {
  final textStyleTitle = TextStyle(fontSize: 14, color: Color(0xFF9d9d9d));
  final textStyleBody = TextStyle(fontSize: 14, color: Color(0xFF1f1f1f));

  @override
  void initState() {
    initViewState();
    Future.microtask(() => refresh());
    super.initState();
  }

  refresh() async {
    Future.wait([
      context
          .read(userNotifier)
          .getUserById(widget.bidResponseData.bid!.factoryId!),
      context.read(chatListNotifier).chatGetNewMessageCount(),
    ]).then((value) {
      uninitViewState();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      bottomSheet: _bottomButton(),
      body: _body(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      iconTheme: IconThemeData(color: CDColors.nav_title),
      backgroundColor: Colors.white,
      elevation: 1,
      centerTitle: true,
      title: Text('견적서', style: CDTextStyle.nav),
      leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          }),
    );
  }

  Widget _bottomButton() {
    return Consumer(builder: (_, watch, __) {
      UserChangeNotifier _userNotifier = watch(userNotifier);
      if (_userNotifier.state == ViewState.Error || isInitLoading == true) {
        return SizedBox.shrink();
      }
      return Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
          child: CDButton(
            width: double.infinity,
            text: "상담하기",
            press: () {
              onPageChatDetail(
                  widget.bidResponseData, widget.productResponseData);
            },
          ),
        ),
      );
    });
  }

  Widget _body() {
    return Consumer(builder: (_, watch, __) {
      UserChangeNotifier _userNotifier = watch(userNotifier);
      if (isInitLoading == true) {
        return ViewStateContainer.busyContainer();
      } else if (_userNotifier.state == ViewState.Error) {
        return ErrorPage();
      }
      return SingleChildScrollView(
        child: Column(
          children: [
            _buildFactoryProfile(_userNotifier),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.productResponseData.product!.material}",
                    style: CDTextStyle.bold20black01,
                  ),
                  SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 66,
                        child: Text(
                          "소       재",
                          style: textStyleTitle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${widget.bidResponseData.bid!.material}",
                          style: textStyleBody,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 66,
                        child: Text(
                          "최소수량",
                          style: textStyleTitle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          ServiceStringUtils.quantity(
                              widget.bidResponseData.bid!.quantityMin ?? 0),
                          style: textStyleBody,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 66,
                        child: Text(
                          "개당금액",
                          style: textStyleTitle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${widget.bidResponseData.bid!.cost}",
                          style: textStyleBody,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 66,
                        child: Text(
                          "견적설명",
                          style: textStyleTitle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${widget.bidResponseData.bid!.description}",
                          style: textStyleBody,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  _buildFactoryProfile(UserChangeNotifier _userNotifier) {
    String name = _userNotifier.otherUserData!.user!.name ?? '';
    String address = _userNotifier.otherUserData!.user!.address ?? '';
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('PageCompanyInfo',
            arguments: widget.bidResponseData.bid!.factoryId);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: <Widget>[
                (_userNotifier.otherUserData!.user!.profileImage == null ||
                        _userNotifier.otherUserData!.user!.profileImage == '')
                    ? CircleAvatar(
                        radius: 30.0,
                        child: Icon(Icons.person),
                        backgroundColor: CDColors.gray3,
                        foregroundColor: CDColors.gray1,
                      )
                    : CircleAvatar(
                        radius: 20.0,
                        backgroundColor: CDColors.gray3,
                        foregroundColor: CDColors.gray1,
                        backgroundImage: CachedNetworkImageProvider(
                          _userNotifier.otherUserData!.user!.profileImage!,
                        ),
                      ),
                // CircleAvatar(
                //   radius: 20.0,
                //   child: (_userNotifier.otherUserData!.user!.profileImage ==
                //               null ||
                //           _userNotifier.otherUserData!.user!.profileImage == '')
                //       ? Icon(Icons.person)
                //       : CachedNetworkImage(
                //           imageUrl:
                //               _userNotifier.otherUserData!.user!.profileImage!,
                //           fit: BoxFit.cover,
                //           errorWidget: (BuildContext, String, dynamic) {
                //             return Container(child: Text('이미지를 불러오지 못했습니다.'));
                //           },
                //         ),
                // ),
                const SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      name,
                      style: CDTextStyle.regular16black01,
                    ),
                    // InkWell(
                    //   onTap: onProfile,
                    //   child: Container(
                    Text(
                      address,
                      style: CDTextStyle.regular13black03,
                    ),
                    // ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Text('업체정보', style: CDTextStyle.regular14black04),
                Icon(
                  Icons.chevron_right,
                  color: CDColors.black04,
                  size: 15.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  onPageChatDetail(BidResponseData bidResponseData,
      ProductResponseData _productResponseData) async {
    // if ([ProductStateType.uploaded, ProductStateType.comparing]
    //     .contains(_productResponseData.product!.state)) {
    //   setState(() {
    //     _productResponseData.product!.state = ProductStateType.chatting;
    //   });
    // }
    logger.i("navigate to : ${bidResponseData.bid!.factoryId}");
    await context
        .read(chatListNotifier)
        .chatGetId(
            Singleton.shared.userData!.userId!, bidResponseData.bid!.factoryId!)
        .then((chatRoomId) {
      Navigator.of(context).pushNamed('PageChatDetail', arguments: [
        bidResponseData.bid!.factoryId,
        chatRoomId,
        bidResponseData.bidId,
      ]).then((result) {
        refresh();
      });
    });
  }
}
