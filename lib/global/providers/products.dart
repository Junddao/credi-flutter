import 'dart:io';

import 'package:crediApp/global/enums/file_type.dart';
import 'package:crediApp/global/models/file/file_response_model.dart';
import 'package:crediApp/global/models/product/product_budget_type.dart';
import 'package:crediApp/global/models/product/product_material_type.dart';
import 'package:crediApp/global/models/product/product_model.dart';
import 'package:crediApp/global/models/product/product_request_load_web_model.dart';
import 'package:crediApp/global/models/product/product_response_model.dart';
import 'package:crediApp/global/providers/parent_provider.dart';
import 'package:crediApp/global/service/api_service.dart';
import 'package:image_downloader/image_downloader.dart';

class ProductChangeNotifier extends ParentProvider {
  List<ProductResponseData>? productList = [];
  List<ProductResponseData>? selectedProductList = [];
  List<String>? productStateList = [];

  ProductMaterialType productMaterialType = ProductMaterialType();
  ProductBudgetType productBudgetType = ProductBudgetType();
  int? productQuantity = 0;

  Product myProduct = Product();

  void setSelectedMaterial(ProductMaterialType _productMaterialType) {
    productMaterialType = _productMaterialType;
    notifyListeners();
  }

  void setSelectedBudget(ProductBudgetType _productBudgetType) {
    productBudgetType = _productBudgetType;
    notifyListeners();
  }

  void setProductQuantity(int quantity) {
    productQuantity = quantity;
    notifyListeners();
  }

  void setMyProductImageUrls(List<String>? iamgeUrls) {
    myProduct.imageUrl = iamgeUrls;
    notifyListeners();
  }

  Future<void> setProductStateList(List<String> stateList) async {
    try {
      setStateBusy();

      productStateList = stateList;
      setStateIdle();
    } catch (error) {
      setStateError();
    }
  }

  Future<void> getMyProductList() async {
    try {
      setStateBusy();
      var api = ApiService();
      ProductResponse productResponse = ProductResponse();

      var response = await api.get('/product/get/me');
      productResponse = ProductResponse.fromMap(response);
      productList = productResponse.data;

      setStateIdle();
    } catch (error) {
      setStateError();
    }
  }

  Future<void> getOrderingList(int userId, int otherUserId) async {
    try {
      setStateBusy();
      var api = ApiService();
      ProductResponse productResponse = ProductResponse();

      Map map = {
        'userId': userId,
        'factoryId': otherUserId,
      };

      var response = await api.post('/product/get/ordering_list', map);
      productResponse = ProductResponse.fromMap(response);
      productList = productResponse.data;
      setStateIdle();
      // setStateIdle();
    } catch (error) {
      setStateError();
    }
  }

  Future<void> getProductById(int productId) async {
    try {
      setStateBusy();

      var api = ApiService();
      ProductResponse productResponse = ProductResponse();

      var response = await api.get('/product/get/index/$productId');
      productResponse = ProductResponse.fromMap(response);
      selectedProductList = productResponse.data;

      setStateIdle();
    } catch (error) {
      setStateError();
    }
  }

  Future<void> getAllProductList() async {
    try {
      setStateBusy();
      var api = ApiService();
      ProductResponse productResponse = ProductResponse();

      var response = await api.get('/product/get/all');
      productResponse = ProductResponse.fromMap(response);
      productList = productResponse.data;

      setStateIdle();
    } catch (error) {
      setStateError();
    }
  }

  Future<void> createProduct(Product product) async {
    try {
      setStateBusy();
      var api = ApiService();
      await api.post('/product/create', product.toMap());
      setStateIdle();
    } catch (error) {
      setStateError();
    }
  }

  Future<void> setProduct(ProductResponseData productResponseData) async {
    try {
      setStateBusy();

      var api = ApiService();
      await api.post('/product/set', productResponseData.toMap());
      setStateIdle();
    } catch (error) {
      setStateError();
    }
  }

  Future<void> deleteProduct(int productId) async {
    try {
      setStateBusy();

      var api = ApiService();
      await api.get('/product/delete/$productId');
      setStateIdle();
    } catch (error) {
      setStateError();
    }
  }

  Future<void> updateProductState(int? productId, String state) async {
    try {
      setStateBusy();
      var map = {
        'productId': productId,
        'state': state,
      };
      var api = ApiService();
      await api.post('/product/update/state', map);
      setStateIdle();
    } catch (error) {
      setStateError();
    }
  }

  Future<void> loadProductFromWeb(String phoneNumber, String code) async {
    try {
      setStateBusy();
      ProductReqeustLoadWebModel productReqeustLoadWebModel =
          ProductReqeustLoadWebModel(phoneNumber: phoneNumber, code: code);
      var api = ApiService();
      await api
          .post('/product/load/web', productReqeustLoadWebModel.toMap())
          .catchError((onError) {
        throw Exception();
      });
      setStateIdle();
    } catch (error) {
      throw Exception();
      // setStateError();
    }
  }

  Future<FileModel?> updateProductPicture(List<File> _images) async {
    FileResponse? productImageResponse;
    try {
      setStateBusy();
      var api = ApiService();
      var response =
          await api.postMultiPart('/file/upload', _images, FileType.image);
      productImageResponse = FileResponse.fromMap(response);
      setStateIdle();
    } catch (error) {
      setStateError();
    }

    return productImageResponse!.data;
  }

  Future<List<File>> downloadServerImage(List<String> imageUrl) async {
    List<File> files = [];
    try {
      setStateBusy();

      for (var url in imageUrl) {
        try {
          var imageId = await ImageDownloader.downloadImage(url);
          var path = await ImageDownloader.findPath(imageId!);
          files.add(File(path!));
        } catch (error) {
          print(error);
        }
      }

      setStateIdle();
    } catch (error) {
      setStateError();
    }

    return files;
  }
}
