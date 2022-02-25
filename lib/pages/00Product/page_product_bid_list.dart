import 'package:crediApp/global/components/view_state_container.dart';
import 'package:crediApp/global/enums/bid_state_type.dart';
import 'package:crediApp/global/enums/view_state.dart';
import 'package:crediApp/global/models/bid/bid_response_model.dart';
import 'package:crediApp/global/models/config_model.dart';
import 'package:crediApp/global/models/product/product_response_model.dart';
import 'package:crediApp/global/providers/bids.dart';
import 'package:crediApp/global/providers/parent_provider.dart';
import 'package:crediApp/global/providers/products.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:crediApp/global/singleton.dart';
import 'package:crediApp/pages/00Product/components/cell_bid.dart';
import 'package:crediApp/pages/00Product/components/progress_widget.dart';
import 'package:crediApp/pages/99Others/error_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../global/constants.dart';
import '../../global/enums/product_state_type.dart';
import '../../global/util.dart';
import '../../global/components/cdbutton.dart';
import 'components/cell_product_small.dart';

class PageProductBidList extends StatefulWidget {
  final int productId;

  PageProductBidList({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  _PageProductBidListState createState() => _PageProductBidListState();
}

class _PageProductBidListState extends State<PageProductBidList> {
  bool hasBid = true;

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
    uninitViewState();
    super.dispose();
  }

  refresh() async {
    print(widget.productId);

    // bid 정보 가져오기
    Future.wait([
      context.read(bidListNotifier).getBidByProductId(widget.productId),
      context.read(productListNotifier).getProductById(widget.productId),
      context.read(chatListNotifier).chatGetNewMessageCount(),
    ]).then((value) {
      uninitViewState();
    });

    logger.i("---get bid datas----------");
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer(builder: (context, watch, _) {
      BidChangeNotifier _bidProvider = watch(bidListNotifier);
      ProductChangeNotifier _productProvider = watch(productListNotifier);
      return Scaffold(
        appBar: _appBar(_productProvider),
        body: _body(_bidProvider, _productProvider),
      );
    });
  }

  AppBar _appBar(ProductChangeNotifier _productProvider) {
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
      title: _productProvider.state == ViewState.Idle && isInitLoading == false
          ? Text(
              _productProvider.selectedProductList!.first.product!.productName!,
              style: CDTextStyle.nav)
          : Text(''),
    );
  }

  Widget _body(
      BidChangeNotifier _bidProvider, ProductChangeNotifier _productProvider) {
    if (isInitLoading == true) {
      return ViewStateContainer.busyContainer();
    } else if (_bidProvider.state == ViewState.Error ||
        _productProvider.state == ViewState.Error) {
      return ErrorPage();
    }
    List<BidResponseData>? _bidResponseData = _bidProvider.bidList ?? [];
    ProductResponseData _productResponseData =
        _productProvider.selectedProductList!.first;

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ProgressWidget(productState: _productResponseData.product!.state),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CellProductSmall(
                    id: _productResponseData.productId,
                    title: _productResponseData.product!.productName,
                    description: _productResponseData.product!.description,
                    material: _productResponseData.product!.material,
                    image: firstOrNull(_productResponseData.product!.imageUrl),
                    quantity: _productResponseData.product!.quantity,
                    state: _productResponseData.product!.state,
                    isConsultingNeeded:
                        _productResponseData.product!.isConsultingNeeded,

                    // isFavorite: isFavorite,
                    // product: product,
                    press: () {
                      _onProduct(context, _productResponseData);
                    },
                  ),
                  const SizedBox(height: 20),
                  _bidProvider.bidList!.isEmpty
                      ? _emptyBidListWidget()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ..._buildBidList(
                                _bidResponseData, _productResponseData),
                            const SizedBox(height: 20),
                          ],
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBidList(List<BidResponseData> _bidResponseData,
      ProductResponseData _productResponseData) {
    logger.w('comment list success');

    if (Singleton.shared.userData!.userId != ConfigModel().crediId &&
        Singleton.shared.userData!.userId !=
            _productResponseData.product!.userId) {
      hasBid = false;
      _bidResponseData.forEach((element) {
        if (element.bid!.factoryId == Singleton.shared.userData!.userId) {
          hasBid = true;
        }
      });
    }

    logger.i("commentLength : $_bidResponseData");
    List<Widget> doneOrMakingWidget = [];
    List<Widget> widgetArray = [];
    for (var bidResponseData in _bidResponseData) {
      if (_productResponseData.product!.userId !=
          Singleton.shared.userData!.userId) {
        widgetArray.add(Container());
      }
      if ([
        ProductStateType.uploaded,
        ProductStateType.comparing,
        ProductStateType.chatting,
        ProductStateType.ordering,
      ].contains(_productResponseData.product!.state)) {
        // 상담하기
        widgetArray.add(CellBid(
          bidResponseData: bidResponseData,
          state: BidStateType.chatting,
          onPageRating: () =>
              onPageRating(bidResponseData, _productResponseData),
          onPageChatDetail: () =>
              onPageChatDetail(bidResponseData, _productResponseData),
          onShowBidDetail: () => onPageShowBidDetail(
              bidResponseData, _productResponseData, onPageChatDetail),
        ));
      } else if (_productResponseData.product!.state ==
              ProductStateType.making &&
          _productResponseData.product!.makerId ==
              bidResponseData.bid!.factoryId) {
        // 제작중 상담하기
        doneOrMakingWidget.add(
          Container(
            child: Text(
              "제작중인 견적서",
              style: CDTextStyle.bold14blue03,
            ),
          ),
        );
        doneOrMakingWidget.add(CellBid(
          bidResponseData: bidResponseData,
          state: BidStateType.making,
          onPageRating: () =>
              onPageRating(bidResponseData, _productResponseData),
          onPageChatDetail: () =>
              onPageChatDetail(bidResponseData, _productResponseData),
          onShowBidDetail: () => onPageShowBidDetail(
              bidResponseData, _productResponseData, onPageChatDetail),
        ));
      } else if (_productResponseData.product!.state == ProductStateType.done &&
          _productResponseData.product!.makerId ==
              bidResponseData.bid!.factoryId) {
        // 후기작성
        doneOrMakingWidget.add(
          Container(
            child: Text(
              "제작 완료된 견적서",
              style: CDTextStyle.bold14blue04,
            ),
          ),
        );
        doneOrMakingWidget.add(CellBid(
          bidResponseData: bidResponseData,
          state: BidStateType.done,
          onPageRating: () =>
              onPageRating(bidResponseData, _productResponseData),
          onPageChatDetail: () =>
              onPageChatDetail(bidResponseData, _productResponseData),
          onShowBidDetail: () => onPageShowBidDetail(
              bidResponseData, _productResponseData, onPageChatDetail),
        ));
      } else {
        widgetArray.add(
          CellBid(
            bidResponseData: bidResponseData,
            onPageRating: () =>
                onPageRating(bidResponseData, _productResponseData),
            onPageChatDetail: () =>
                onPageChatDetail(bidResponseData, _productResponseData),
            onShowBidDetail: () => onPageShowBidDetail(
                bidResponseData, _productResponseData, onPageChatDetail),
          ),
        );
      }
    }

    if (widgetArray.length > 0) {
      if (doneOrMakingWidget.isEmpty) {
        widgetArray.insert(
            0, Container(child: Text("받은 견적서", style: textStyleTitle)));
      } else {
        doneOrMakingWidget.add(const SizedBox(height: 30));
        widgetArray.insert(
            0, Container(child: Text("기타 견적서", style: textStyleTitle)));
      }
    }
    return doneOrMakingWidget + widgetArray;
  }

  onPageRating(BidResponseData bidResponseData,
      ProductResponseData _productResponseData) async {
    logger.i("onPageRating : $bidResponseData.bid");
    if (ProductStateType.done != _productResponseData.product!.state) {
      logger.e("Product not done : ${_productResponseData.product!.state}");
      return;
    }

    await Navigator.of(context).pushNamed('PageRate',
        arguments: [bidResponseData, _productResponseData]);

    setState(() {}); // reload without API call
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

  onPageShowBidDetail(BidResponseData _bidResponseData,
      ProductResponseData _productResponseData, Function onPageChatDetail) {
    Navigator.of(context).pushNamed('PageProductBidDetail',
        arguments: [_bidResponseData, _productResponseData]).then((result) {
      refresh();
    });
  }

  Future<void> _onProduct(
      BuildContext context, ProductResponseData productResponseData) async {
    await Navigator.of(context)
        .pushNamed('PageProductDetail', arguments: productResponseData)
        .then((result) {
      refresh();
    });
  }

  Widget _emptyBidListWidget() {
    return Container(
      height: SizeConfig.screenHeight / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ImageIcon(AssetImage("assets/icons/ic_sad.png"), size: 36),
          const SizedBox(height: 16),
          Text(
            "공장을 찾는 중입니다.\n견적은 최대 24시간 이내에 발송됩니다.",
            textAlign: TextAlign.center,
            style: CDTextStyle.regular16black03,
          ),
        ],
      ),
    );
  }
}
