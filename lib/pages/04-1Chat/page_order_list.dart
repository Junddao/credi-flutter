import 'package:crediApp/global/components/view_state_container.dart';
import 'package:crediApp/global/enums/product_state_type.dart';
import 'package:crediApp/global/enums/view_state.dart';
import 'package:crediApp/global/models/product/product_response_model.dart';
import 'package:crediApp/global/models/user/user_response_model.dart';
import 'package:crediApp/global/providers/parent_provider.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:crediApp/global/singleton.dart';
import 'package:crediApp/global/theme.dart';
import 'package:crediApp/global/util.dart';
import 'package:crediApp/pages/00Product/components/cell_product.dart';
import 'package:crediApp/pages/99Others/error_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageOrderList extends StatefulWidget {
  final UserResponseData? otherUserData;
  final Function sendDoneRequest;
  final Function onRequestOrder;

  PageOrderList({
    required this.otherUserData,
    required this.sendDoneRequest,
    required this.onRequestOrder,
  });

  @override
  _PageOrderListState createState() => _PageOrderListState();
}

class _PageOrderListState extends State<PageOrderList> {
  @override
  void initState() {
    initViewState();
    if (widget.otherUserData!.userId == Singleton.shared.userData!.userId) {
      Navigator.of(context).pop(true);
      return;
    }

    Future.microtask(
      () => context
          .read(productListNotifier)
          .getOrderingList(
              Singleton.shared.userData!.userId!, widget.otherUserData!.userId!)
          .then((value) => uninitViewState()),
      // () => context.read(productListNotifier).getMyProductList(),
    );
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
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: CDColors.nav_title),
      backgroundColor: Colors.white,
      elevation: 1,
      centerTitle: true,
    );
  }

  Widget _buildBody() {
    return Consumer(builder: (context, watch, child) {
      final _productNotifier = watch(productListNotifier);
      if (_productNotifier.state == ViewState.Busy || isInitLoading == true) {
        return ViewStateContainer.busyContainer();
      } else if (_productNotifier.state == ViewState.Error) {
        return ErrorPage();
      } else {
        List<dynamic> makingList = _productNotifier.productList!;
        // List<dynamic> makingList = _productNotifier.productList!.where((value) {
        //   ProductResponseData productResponseData = value;

        //   return [
        //     ProductStateType.uploaded,
        //     ProductStateType.comparing,
        //     ProductStateType.chatting,
        //   ].contains(productResponseData.product!.state);
        //   // && product.userId == otherUser.id;
        // }).toList();
        return makingList.length == 0
            ? _buildNoData()
            : _buildListOrder(makingList);
      }
    });
  }

  Widget _buildNoData() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      child: Text(
        "발주 가능한 제품이 없습니다.\n의뢰를 먼저 작성해 주세요.",
        textAlign: TextAlign.center,
        style: TextStyle(color: CDColors.gray9, fontSize: 18),
      ),
    );
  }

  Widget _buildListOrder(List productList) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 15, left: 24, right: 24, bottom: 30),
          child: Row(
            children: [
              Text("발주하실\n제품을 선택해 주세요",
                  style: CDTextStyle.regularFont(fontSize: 20.0))
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 24),
            shrinkWrap: true,
            // padding: EdgeInsets.all(16.0),
            separatorBuilder: (context, index) => Divider(),
            itemCount: productList.length,
            itemBuilder: (context, i) {
              ProductResponseData productResponseData = productList[i];
              // logger.i("doc : ${productList[i].data()}");
              logger.i("\n : ${productResponseData.toJson()}\n");

              Size size = MediaQuery.of(context).size;
              // final isFavorite = true; //favorites.contains(product.id);
              final _biggerFont =
                  TextStyle(fontSize: 18.0, color: CDColors.primary);
              return CellProduct(
                id: productResponseData.productId,
                title: productResponseData.product!.productName,
                description: productResponseData.product!.description,
                material: productResponseData.product!.material,
                image: firstOrNull(productResponseData.product!.imageUrl),
                quantity: productResponseData.product!.quantity,
                state: productResponseData.product!.state,
                isConsultingNeeded:
                    productResponseData.product!.isConsultingNeeded,
                size: size,
                biggerFont: _biggerFont,
                // isFavorite: isFavorite,
                // product: product,
                press: () {
                  // onProduct(context, product);
                  widget.onRequestOrder(
                      context, productResponseData, widget.otherUserData);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
