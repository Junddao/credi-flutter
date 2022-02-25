import 'dart:io';

import 'package:crediApp/global/components/view_state_container.dart';
import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/enums/product_state_type.dart';
import 'package:crediApp/global/enums/view_state.dart';
import 'package:crediApp/global/models/product/product_budget_type.dart';
import 'package:crediApp/global/models/product/product_material_type.dart';
import 'package:crediApp/global/models/product/product_model.dart';
import 'package:crediApp/global/models/product/product_response_model.dart';
import 'package:crediApp/global/providers/products.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:crediApp/global/singleton.dart';
import 'package:crediApp/global/util.dart';
import 'package:crediApp/pages/00Product/components/create_product_budget_container.dart';
import 'package:crediApp/pages/00Product/components/create_product_detail_container.dart';
import 'package:crediApp/pages/00Product/components/create_product_material_container.dart';
import 'package:crediApp/pages/00Product/components/create_product_quantity_container.dart';
import 'package:crediApp/pages/99Others/error_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageCreateProduct extends StatefulWidget {
  final ProductResponseData? productResponsedata;
  const PageCreateProduct({Key? key, this.productResponsedata})
      : super(key: key);

  @override
  _PageCreateProductState createState() => _PageCreateProductState();
}

class _PageCreateProductState extends State<PageCreateProduct> {
  bool _isActive = false;
  int step = 0;
  TextEditingController materialController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  TextEditingController titleTextController = new TextEditingController();
  TextEditingController widthTextController = new TextEditingController();
  TextEditingController heightTextController = new TextEditingController();
  TextEditingController depthTextController = new TextEditingController();
  TextEditingController descriptionTextController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String myMaterial = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      ProductChangeNotifier productProvider = watch(productListNotifier);
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _appBar(),
        body: _body(productProvider),
        bottomSheet: _bottomSheet(productProvider),
      );
    });
  }

  AppBar _appBar() {
    return AppBar(
      iconTheme: IconThemeData(color: CDColors.nav_title),
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text('견적요청하기', style: CDTextStyle.nav),
      centerTitle: true,
      leading: step == 0
          ? SizedBox.shrink()
          : IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                step = step - 1;
                setState(() {});
              },
            ),
      actions: [
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  _bottomSheet(ProductChangeNotifier productProvider) {
    if (productProvider.state == ViewState.Busy) {
      return SizedBox.shrink();
    } else if (productProvider.state == ViewState.Error) {
      logger.e('server connect error');
      return ErrorPage();
    }
    setActivateState();

    return _isActive
        ? InkWell(
            onTap: () {
              toNext();
            },
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: CDColors.blue03,
              ),
              child: Center(
                child: step == 3
                    ? Text('견적요청', style: CDTextStyle.bold17white02)
                    : Text('다음', style: CDTextStyle.bold17white02),
              ),
            ),
          )
        : Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: CDColors.black04,
            ),
            child: Center(
              child: step == 3
                  ? Text('견적요청', style: CDTextStyle.bold17white02)
                  : Text('다음', style: CDTextStyle.bold17white02),
            ),
          );
  }

  Widget _body(ProductChangeNotifier productProvider) {
    if (productProvider.state == ViewState.Busy) {
      return ViewStateContainer.busyContainer();
    } else if (productProvider.state == ViewState.Error) {
      logger.e('server connect error');
      return ErrorPage();
    }
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        children: [
          getProgressBar(),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // progress bar (공통 화면)

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultHorizontalPadding),
                      child: Column(
                        children: [
                          SizedBox(height: 100),
                          getCurrentStepContainer(),
                        ],
                        // 각 step 별 container (개별 화면)
                      ),
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getProgressBar() {
    double percent = 0.0;
    if (step == 0) percent = 0.0;
    if (step == 1) percent = 0.5;
    if (step == 2) percent = 0.75;
    if (step == 3) percent = 0.9;

    return Container(
      width: MediaQuery.of(context).size.width - kDefaultHorizontalPadding * 2,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: LinearProgressIndicator(
                value: percent,
                backgroundColor: Colors.grey,
              ),
            ),
          ),
          SizedBox(width: 8),
          Text('${(percent * 100).round()}%',
              style: CDTextStyle.regular17blue03),
        ],
      ),
    );
  }

  Widget getCurrentStepContainer() {
    Widget? currentWidget;
    switch (step) {
      case 0:
        currentWidget = CreateProductMaterialContainer(
            setActivateState: setActivateState,
            materialController: materialController);
        break;
      case 1:
        currentWidget = CreateProductBudgetContainer(
          setActivateState: setActivateState,
        );
        break;
      case 2:
        {
          currentWidget = CreateProductQuantityContainer(
            quantityController: quantityController,
          );
        }
        break;
      case 3:
        {
          currentWidget = CreateProductDetailContainer(
            formKey: _formKey,
            titleTextController: titleTextController,
            widthTextController: widthTextController,
            heightTextController: heightTextController,
            depthTextController: depthTextController,
            descriptionTextController: descriptionTextController,
          );
        }
        break;
    }

    return currentWidget!;
  }

  // void setActivateState(bool isActivate) {
  //   setState(() {
  //     _isActive = isActivate;
  //   });
  // }

  void setActivateState() {
    switch (step) {
      case 0:
        {
          // 1. true 가 있는지 확인
          context
                  .read(productListNotifier)
                  .productMaterialType
                  .materials!
                  .containsValue(true)
              ? _isActive = true
              : _isActive = false;

          // 2. true 가 있고, '기타'도 포함인데 기타의 textfield 가 비어있으면
          context
              .read(productListNotifier)
              .productMaterialType
              .materials!
              .forEach((key, value) {
            if (key == '기타' && value == true) {
              context
                      .read(productListNotifier)
                      .productMaterialType
                      .etc
                      .isNotEmpty
                  ? _isActive = true
                  : _isActive = false;
            }
          });
        }
        break;

      case 1:
        {
          context
                  .read(productListNotifier)
                  .productBudgetType
                  .budgetTypes!
                  .containsValue(true)
              ? _isActive = true
              : _isActive = false;
        }
        break;
      case 2:
        {
          context.read(productListNotifier).productQuantity! > 0
              ? _isActive = true
              : _isActive = false;
        }
        break;
      case 3:
        {
          if (titleTextController.text.isNotEmpty &&
              widthTextController.text.isNotEmpty &&
              heightTextController.text.isNotEmpty &&
              depthTextController.text.isNotEmpty &&
              descriptionTextController.text.isNotEmpty &&
              context.read(productListNotifier).myProduct.imageUrl != null &&
              context
                  .read(productListNotifier)
                  .myProduct
                  .imageUrl!
                  .isNotEmpty) {
            _isActive = true;
          } else {
            _isActive = false;
          }
        }
        break;
    }
  }

  void toNext() {
    setState(() {
      if (step == 2) {
        if (int.parse(quantityController.text) > 100000000) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("1억개 이하로만 입력 가능합니다."),
              backgroundColor: Colors.red,
            ),
          );

          return;
        }
      }
      if (step == 3) {
        _onSave();
        return;
      }
      step++;
      _isActive = false;
    });
  }

  void _onSave() async {
    logger.i("uploadPost");

    logger.i("parse quantity");

    int quantity = int.parse(quantityController.text);

    logger.i("upload");

    var productProvider = context.read(productListNotifier);

    ProductMaterialType productMaterialType =
        context.read(productListNotifier).productMaterialType;
    String materials = '';
    productMaterialType.materials!.forEach((key, value) {
      if (value == true) {
        if (key == '기타') {
          materials += productMaterialType.etc + ',';
        } else {
          materials += key + ',';
        }
      }
    });
    if (materials[materials.length - 1] == ',') {
      materials = materials.substring(0, materials.length - 1);
    }

    ProductBudgetType productBudgetType =
        context.read(productListNotifier).productBudgetType;
    String budget = '';
    productBudgetType.budgetTypes!.forEach((key, value) {
      if (value == true) {
        budget = key;
      }
    });

    Product productMap = Product(
      userId: Singleton.shared.userData!.userId,
      name: Singleton.shared.userData!.user!.name,
      material: materials,
      productName: productProvider.myProduct.productName,
      description: productProvider.myProduct.description,
      quantity: quantity,
      state: ProductStateType.uploaded,
      imageUrl: productProvider.myProduct.imageUrl,
      width: productProvider.myProduct.width,
      height: productProvider.myProduct.height,
      depth: productProvider.myProduct.depth,
      hasDrawing: productProvider.myProduct.hasDrawing ?? false,
      isConsultingNeeded: productProvider.myProduct.isConsultingNeeded ?? false,
      budget: budget,
    );

    print(productMap);
    await context
        .read(productListNotifier)
        .createProduct(productMap)
        .then((result) {
      context.read(firebaseAnalyticsNotifier).sendAnalyticsEvent('BidComplete');
      Navigator.pushReplacementNamed(context, 'SuccessCreateProductPage');
    });
  }
}
