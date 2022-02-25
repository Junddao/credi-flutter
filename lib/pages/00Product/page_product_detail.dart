import 'package:crediApp/generated/locale_keys.g.dart';
import 'package:crediApp/global/components/view_state_container.dart';
import 'package:crediApp/global/enums/tab_type.dart';
import 'package:crediApp/global/enums/view_state.dart';
import 'package:crediApp/global/models/bid/bid_response_model.dart';
import 'package:crediApp/global/models/config_model.dart';
import 'package:crediApp/global/models/product/product_response_model.dart';
import 'package:crediApp/global/models/user/user_type_model.dart';
import 'package:crediApp/global/providers/parent_provider.dart';
import 'package:crediApp/global/providers/products.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:crediApp/global/service/service_string_utils.dart';
import 'package:crediApp/global/singleton.dart';
import 'package:crediApp/global/components/cdbutton.dart';
import 'package:crediApp/pages/99Others/error_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../global/constants.dart';
import '../../global/enums/product_state_type.dart';
import '../../global/util.dart';
import '../details/product_poster.dart';
import 'package:easy_localization/easy_localization.dart';

class PageProductDetail extends StatefulWidget {
  final ProductResponseData productResponseData;

  PageProductDetail({
    Key? key,
    required this.productResponseData,
  }) : super(key: key);

  @override
  _PageProductDetailState createState() => _PageProductDetailState();
}

class _PageProductDetailState extends State<PageProductDetail> {
  bool hasBid = true;

  ProductResponseData productResponseData = ProductResponseData();

  final textStyleTitle = TextStyle(fontSize: 14, color: Color(0xFF9d9d9d));
  final textStyleBody = TextStyle(fontSize: 14, color: Color(0xFF1f1f1f));

  @override
  void initState() {
    initViewState();

    Future.microtask(() => refresh());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  refresh() async {
    print(widget.productResponseData.productId);
    Future.wait([
      context
          .read(productListNotifier)
          .getProductById(widget.productResponseData.productId!),
      context
          .read(bidListNotifier)
          .getBidByProductId(widget.productResponseData.productId!),
    ]).then((value) {
      uninitViewState();
    });

    logger.i("------get bid list-------");
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Consumer(builder: (context, watch, _) {
      ProductChangeNotifier _productProvider = watch(productListNotifier);

      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(_productProvider),
        bottomSheet: Container(
          color: Colors.transparent,
          child: _bottomButton(_productProvider),
        ),
        body: _body(_productProvider),
      );
    });
  }

  AppBar _buildAppBar(ProductChangeNotifier _productProvider) {
    return AppBar(
      iconTheme: IconThemeData(color: CDColors.nav_title),
      backgroundColor: Colors.white,
      elevation: 1,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context, true);
        },
      ),
      title: Text(
          _productProvider.state == ViewState.Idle && isInitLoading == false
              ? _productProvider
                  .selectedProductList!.first.product!.productName!
              : '',
          style: CDTextStyle.nav),
      actions: [],
    );
  }

  Widget _body(ProductChangeNotifier _productProvider) {
    if (isInitLoading == true) {
      return ViewStateContainer.busyContainer();
    } else if (_productProvider.state == ViewState.Error) {
      return ErrorPage();
    }
    productResponseData = _productProvider.selectedProductList!.first;
    return SafeArea(
      bottom: false,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Stack(
            children: [
              SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      // tag: '${widget.productResponseData!.productId}',
                      child: ProductPoster(
                          size: Size(
                              SizeConfig.screenWidth, SizeConfig.screenHeight),
                          items: productResponseData.product!.imageUrl ?? []),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: kDefaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${productResponseData.product!.productName}",
                              style: CDTextStyle.bold20black01),
                          SizedBox(height: 16),
                          productResponseData.product!.hasDrawing!
                              ? Row(
                                  children: [
                                    Image.asset("assets/icons/ic_drawing.png",
                                        color: CDColors.blue03,
                                        height: 20,
                                        width: 20),
                                    const SizedBox(width: 2),
                                    Container(
                                      child: Text(
                                        "도면 보유",
                                        style: CDTextStyle.regularFont(
                                          color: CDColors.blue03,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Image.asset("assets/icons/ic_drawing.png",
                                        color: CDColors.red01,
                                        height: 20,
                                        width: 20),
                                    const SizedBox(width: 2),
                                    Container(
                                      child: Text(
                                        "도면 미보유",
                                        style: CDTextStyle.regularFont(
                                          color: CDColors.red01,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          SizedBox(height: 8),
                          productResponseData.product!.isConsultingNeeded!
                              ? Row(
                                  children: [
                                    Image.asset("assets/icons/settings.png",
                                        color: CDColors.blue03,
                                        height: 20,
                                        width: 20),
                                    const SizedBox(width: 2),
                                    Container(
                                      child: Text(
                                        "컨설팅 필요",
                                        style: CDTextStyle.regularFont(
                                          color: CDColors.blue03,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Image.asset("assets/icons/settings.png",
                                        color: CDColors.red01,
                                        height: 20,
                                        width: 20),
                                    const SizedBox(width: 2),
                                    Container(
                                      child: Text(
                                        "컨설팅 불필요",
                                        style: CDTextStyle.regularFont(
                                          color: CDColors.red01,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          SizedBox(height: 12),
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
                                  "${productResponseData.product!.material}",
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
                                  "예       산",
                                  style: textStyleTitle,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "${productResponseData.product!.budget}",
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
                                  "희망수량",
                                  style: textStyleTitle,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  ServiceStringUtils.quantity(widget
                                      .productResponseData.product!.quantity!),
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
                                  "크       기",
                                  style: textStyleTitle,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "${productResponseData.product!.width} X ${productResponseData.product!.height} X ${productResponseData.product!.depth}",
                                  style: textStyleBody,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 66,
                                child: Text(
                                  "제품설명",
                                  style: textStyleTitle,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  productResponseData.product!.description!,
                                  style: textStyleBody,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: kDefaultPadding,
                          ),
                        ],
                      ),
                    ),
                    // 하단 버튼 사이즈 만큼 공백 추가.
                    const SizedBox(height: 90),
                  ],
                ),
              ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Padding(
              //     padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
              //     child: _buildBidButton(),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomButton(ProductChangeNotifier _productProvider) {
    if (_productProvider.state != ViewState.Idle || isInitLoading == true) {
      return SizedBox.shrink();
    }

    if ([ProductStateType.uploaded, ProductStateType.request].contains(
            _productProvider.selectedProductList!.first.product!.state) ==
        false) {
      return SizedBox.shrink();
    }

    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Expanded(
            //   child: CDButton(
            //     margin: EdgeInsets.only(right: 4),
            //     height: 48,
            //     type: ButtonType.dark,
            //     text: "요청서 수정",
            //     press: () {
            //       onModifyButton();
            //     },
            //   ),
            // ),
            Expanded(
              child: CDButton(
                margin: EdgeInsets.only(left: 4),
                height: 48,
                type: ButtonType.warning,
                text: "요청 취소",
                press: () {
                  // _onDelete();
                  onDeleteButton();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkHasBid() {
    logger.w('comment list success');
    if (Singleton.shared.userData!.userId != ConfigModel().crediId &&
        Singleton.shared.userData!.userId !=
            productResponseData.product!.userId) {
      hasBid = false;
      context.read(bidListNotifier).bidList!.forEach((element) {
        if (element.bid!.factoryId == Singleton.shared.userData!.userId) {
          hasBid = true;
        }
      });
    }
    logger.i(hasBid);
  }

  onPageRating(BidResponseData bidResponseData) async {
    logger.i("onPageRating : ${bidResponseData.bid}");
    if (ProductStateType.done != productResponseData.product!.state) {
      logger.e("Product not done : ${productResponseData.product!.state}");
      return;
    }
    await Navigator.of(context).pushNamed('PageRate',
        arguments: [bidResponseData, productResponseData]);
  }

  onPageChatDetailCustomer() {
    // if ([ProductStateType.uploaded, ProductStateType.comparing]
    //     .contains(widget.productResponseData.product!.state)) {
    //   ProductResponseData productResponseData = widget.productResponseData;
    //   productResponseData.product!.state = ProductStateType.chatting;
    // }
    Navigator.of(context).pushNamed('PageChatDetail', arguments: [
      productResponseData.product!.userId,
      0,
      0
    ]).then((value) async {
      context.read(chatListNotifier).chatGetNewMessageCount();
    });
  }

  onModifyButton() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return buildBottomSheet(
              context,
              LocaleKeys.modify_product_title.tr(),
              LocaleKeys.modify_product_subtitle1.tr(),
              LocaleKeys.modify_product_subtitle2.tr(),
              LocaleKeys.modify_product_button.tr(),
              ButtonType.dark,
              _onModify);
        },
        backgroundColor: Colors.transparent);
  }

  Future<void> onDeleteButton() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return buildBottomSheet(
              context,
              LocaleKeys.delete_product_title.tr(),
              LocaleKeys.delete_product_subtitle1.tr(),
              LocaleKeys.delete_product_subtitle2.tr(),
              LocaleKeys.delete_product_button.tr(),
              ButtonType.warning,
              _onDelete);
        },
        backgroundColor: Colors.transparent);
  }

  Widget buildBottomSheet(
      BuildContext context,
      String title,
      String subTitle1,
      String subTitle2,
      String buttonText,
      ButtonType buttonType,
      Function _press) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: CDColors.white02,
      ),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/icons/attention.png'),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                title,
                style: CDTextStyle.regular24black01,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              subTitle1,
              style: CDTextStyle.regular13black03,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              subTitle2,
              style: CDTextStyle.regular13black03,
            ),
            SizedBox(
              height: 90,
            ),
            CDButton(
              width: MediaQuery.of(context).size.width - 48,
              text: buttonText,
              type: buttonType,
              press: _press,
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: TextButton(
                child: Text(
                  LocaleKeys.close.tr(),
                  style: TextStyle(
                      fontSize: 18,
                      color: CDColors.black03,
                      fontWeight: FontWeight.w400),
                ),
                onPressed: onClosePress,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onModify() {
    Navigator.of(context)
        .popAndPushNamed('PageCreateProduct', arguments: productResponseData)
        .then((value) {
      refresh();
    });
  }

  void _onDelete() {
    context
        .read(productListNotifier)
        .deleteProduct(productResponseData.productId!)
        .then(
      (value) {
        Navigator.of(context).popUntil(ModalRoute.withName('PageTabs'));
        //   Navigator.of(context).pushNamedAndRemoveUntil(
        //       'PageTabs', (route) => false,
        //       arguments: TabType.PageProductList.index);
      },
    );
  }

  void onClosePress() async {
    Navigator.of(context).pop();
  }
}
