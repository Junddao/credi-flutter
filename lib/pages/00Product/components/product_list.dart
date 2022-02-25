import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/models/product/product_response_model.dart';
import 'package:crediApp/global/providers/products.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:crediApp/global/util.dart';
import 'package:crediApp/pages/00Product/components/cell_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class ProductList extends ConsumerWidget {
  Function onProduct(ProductResponseData productResponseData);
  final _biggerFont = TextStyle(fontSize: 18.0, color: CDColors.primary);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _productListNotifier = watch(productListNotifier);
    return ListView.separated(
      padding: EdgeInsets.all(16.0),
      separatorBuilder: (context, index) => Divider(),
      itemCount: _productListNotifier.productList!.length,
      itemBuilder: (context, i) {
        ProductResponseData productResponseData =
            _productListNotifier.productList![i];

        // logger.i("doc : ${productList[i].data()}");
        // logger.i("here : ${product.toJson()}");
        return _buildRow(context, productResponseData);
      },
    );
  }

  Widget _buildRow(
      BuildContext context, ProductResponseData productResponseData) {
    Size size = MediaQuery.of(context).size;
    // final isFavorite = true; //favorites.contains(product.id);
    return CellProduct(
      id: productResponseData.productId,
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
        onProduct(productResponseData);
      },
    );
  }
}
