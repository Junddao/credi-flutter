import 'package:crediApp/generated/locale_keys.g.dart';
import 'package:crediApp/global/components/cdbutton.dart';
import 'package:crediApp/global/components/view_state_container.dart';
import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/enums/view_state.dart';
import 'package:crediApp/global/models/product/product_response_model.dart';
import 'package:crediApp/global/providers/parent_provider.dart';
import 'package:crediApp/global/providers/products.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:crediApp/global/singleton.dart';
import 'package:crediApp/global/theme.dart';
import 'package:crediApp/global/util.dart';
import 'package:crediApp/pages/00Product/components/cell_product.dart';
import 'package:crediApp/pages/99Others/error_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class PageProductList extends StatefulWidget {
  @override
  _PageProductListState createState() => _PageProductListState();
}

class _PageProductListState extends State<PageProductList> {
  final _biggerFont = TextStyle(fontSize: 18.0, color: CDColors.primary);

  @override
  void initState() {
    initViewState();

    Future.microtask(() async {
      context
          .read(firebaseAnalyticsNotifier)
          .sendAnalyticsEvent('PageProductList');
      await refresh();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> refresh() async {
    context.read(productListNotifier).getMyProductList().then((value) {
      if (context.read(productListNotifier).productList!.isEmpty) {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: buildBottomSheet,
            backgroundColor: Colors.transparent);
      }
      uninitViewState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        ProductChangeNotifier _productListNotifier = watch(productListNotifier);

        return Scaffold(
          appBar: _buildAppBar(context),
          body: _body(_productListNotifier),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: CDColors.nav_title),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Text('견적함', style: CDTextStyle.nav),
      actions: [
        // IconButton(
        //   onPressed: () => onCreateProduct(context),
        //   padding: EdgeInsets.zero,
        //   icon: ImageIcon(
        //     AssetImage("assets/icons/bt_add_product.png"),
        //     color: CDColors.blue5,
        //   ),
        //   iconSize: 24,
        // ),
      ],
    );
  }

  Widget _body(ProductChangeNotifier _productListNotifier) {
    if (_productListNotifier.state == ViewState.Busy || isInitLoading == true) {
      return ViewStateContainer.busyContainer();
    } else if (_productListNotifier.state == ViewState.Error) {
      logger.e('server connect error');
      return ErrorPage();
    }
    List<ProductResponseData>? _productList = _productListNotifier.productList;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ChoiceChipWidget(),
          // Divider(thickness: 10),
          InkWell(
            onTap: () {
              String url = context
                  .read(infoChangeNotifier)
                  .magazineResponseDatas!
                  .first
                  .magazine!
                  .url!;
              openCheckList(url);
            },
            child: Container(
              color: CDColors.blue04,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: kDefaultVerticalPadding,
                    horizontal: kDefaultHorizontalPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('견적요청', style: CDTextStyle.regular14white02),
                        SizedBox(height: 10),
                        Text('체크리스트', style: CDTextStyle.bold24white02),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_rounded,
                        color: CDColors.white02),
                  ],
                ),
              ),
            ),
          ),
          _productList!.isEmpty
              ? Padding(
                  padding: EdgeInsets.only(top: SizeConfig.screenHeight * 0.3),
                  child: Center(
                    child: Text('견적 내역이 없습니다.'),
                  ),
                )
              : _buildList(_productList),
        ],
      ),
    );
  }

  ListView _buildList(productList) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(16.0),
      separatorBuilder: (context, index) => Divider(),
      itemCount: productList.length,
      itemBuilder: (context, i) {
        var productResponseData = productList![i];

        return _buildRow(context, productResponseData);
      },
    );
  }

  Widget _buildRow(
      BuildContext context, ProductResponseData? productResponseData) {
    Size size = MediaQuery.of(context).size;
    // final isFavorite = true; //favorites.contains(product.id);
    return CellProduct(
      id: productResponseData!.productId,
      title: productResponseData.product!.productName,
      description: productResponseData.product!.description,
      material: productResponseData.product!.material,
      image: firstOrNull(productResponseData.product!.imageUrl),
      quantity: productResponseData.product!.quantity,
      state: productResponseData.product!.state,
      isConsultingNeeded: productResponseData.product!.isConsultingNeeded,
      size: size,
      biggerFont: _biggerFont,
      // isFavorite: isFavorite,
      // product: product,
      press: () {
        onProduct(context, productResponseData);
      },
    );
  }

  Future<void> onCreateProduct(BuildContext context) async {
    await Navigator.of(context).pushNamed('PageCreateProduct').then((result) {
      refresh();
    });
  }

  Future<void> onProduct(
      BuildContext context, ProductResponseData productResponseData) async {
    await Navigator.of(context)
        .pushNamed('PageProductBidList',
            arguments: productResponseData.productId)
        .then((value) {
      refresh();
    });
  }

  Widget buildBottomSheet(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: CDColors.white02,
      ),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              // overflow: TextOverflow,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: LocaleKeys.hello.tr() + '  ',
                    style: CDTextStyle.bold32Black01,
                  ),
                  TextSpan(
                    text: Singleton.shared.userData!.user!.name ?? '의뢰인',
                    style: CDTextStyle.bold32Blue03,
                  ),
                  TextSpan(
                    text: LocaleKeys.dear.tr() + '!',
                    style: CDTextStyle.bold32Black01,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              LocaleKeys.product_list_bottom_sheet_sub_title.tr(),
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 50,
            ),
            CDButton(
              width: MediaQuery.of(context).size.width - 48,
              text: LocaleKeys.request_order.tr(),
              press: () async {
                await onCreateProduct(context);
              },
            ),
            SizedBox(height: 10),
            CDButton(
              width: MediaQuery.of(context).size.width - 48,
              text: LocaleKeys.close.tr(),
              type: ButtonType.transparent,
              press: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void openCheckList(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
