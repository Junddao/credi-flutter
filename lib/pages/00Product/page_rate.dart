import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crediApp/generated/locale_keys.g.dart';
import 'package:crediApp/global/components/cd_image_picker.dart';
import 'package:crediApp/global/components/common_dialog.dart';
import 'package:crediApp/global/components/view_state_container.dart';
import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/enums/view_state.dart';
import 'package:crediApp/global/models/bid/bid_response_model.dart';
import 'package:crediApp/global/models/product/product_response_model.dart';
import 'package:crediApp/global/models/rating/rating_model.dart';
import 'package:crediApp/global/providers/file_controller.dart';
import 'package:crediApp/global/providers/products.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:crediApp/global/singleton.dart';
import 'package:crediApp/global/style/cdtextstyle.dart';
import 'package:crediApp/global/theme.dart';
import 'package:crediApp/global/util.dart';
import 'package:crediApp/global/components/cdbutton.dart';
import 'package:crediApp/pages/99Others/error_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heic_to_jpg/heic_to_jpg.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PageRate extends StatefulWidget {
  final BidResponseData bidResponseData;
  final ProductResponseData productResponseData;

  const PageRate({
    Key? key,
    required this.bidResponseData,
    required this.productResponseData,
  }) : super(key: key);
  @override
  _PageRateState createState() => _PageRateState();
}

class _PageRateState extends State<PageRate> {
  final textStyleTitle = TextStyle(fontSize: 14, color: Color(0xFF9d9d9d));
  final textStyleBody = TextStyle(fontSize: 14, color: Color(0xFF1f1f1f));
  double score = 1;
  final TextEditingController reviewController = new TextEditingController();
  List<File> _images = [];
  List<String> imageUrls = [];
  List<AssetEntity> _selectedAssetList = [];

  int reviewLength = 0;

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      FileControllerChangeNotifier _fileControllerNotifier =
          watch(fileControllerNotifier);
      return Scaffold(
        appBar: _buildAppBar(),
        body: _body(_fileControllerNotifier),
      );
    });
  }

  AppBar _buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: CDColors.nav_title),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context, true);
        },
      ),
      title: Text("후기작성", style: CDTextStyle.nav),
      actions: [],
    );
  }

  Widget _body(FileControllerChangeNotifier _fileControllerNotifier) {
    if (_fileControllerNotifier.state == ViewState.Busy) {
      return ViewStateContainer.busyContainer();
    } else if (_fileControllerNotifier.state == ViewState.Error) {
      return ErrorPage();
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(LocaleKeys.rating_title.tr(),
                style: CDTextStyle.bold24black01),
            SizedBox(height: 48),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  // child: Image(image: NetworkImage(product.images[0]),
                  child: Container(
                    width: 52,
                    height: 52,
                    child: CachedNetworkImage(
                      imageUrl:
                          widget.productResponseData.product!.imageUrl![0],
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          Container(color: CDColors.gray1),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(LocaleKeys.bid_id.tr(),
                        style: CDTextStyle.bold13black03),
                    SizedBox(height: 8),
                    Text('${widget.bidResponseData.bidId}',
                        style: CDTextStyle.bold16black01),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  child: RatingBar.builder(
                    initialRating: score,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    unratedColor: CDColors.blue03.withAlpha(50),
                    itemCount: 5,
                    itemSize: (SizeConfig.screenWidth - 150) / 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: CDColors.blue03,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        score = rating;
                      });
                    },
                    updateOnDrag: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),
            // const SizedBox(height: 300),

            Stack(
              children: [
                Container(
                  width: SizeConfig.screenWidth - 48,
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(color: CDColors.black05, width: 1)),
                  child: TextFormField(
                    controller: reviewController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    maxLength: 500,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(500),
                    ],
                    decoration: InputDecoration(
                      hintText: "후기를 남겨주세요.",
                      hintStyle: CDTextStyle.regular14black05,
                      labelStyle: CDTextStyle.regular14black05,
                      counterText: '',
                      border: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (text) {
                      setState(() {
                        reviewLength = text.length;
                      });
                    },
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: Text(
                    '$reviewLength / 500',
                    style: CDTextStyle.medium10black05,
                  ),
                ),
              ],
            ),
            SizedBox(height: 18),
            Container(
              height: 80,
              width: double.infinity,
              child: Row(
                children: [
                  getAddPhotoBtn(),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedAssetList.length,
                      itemBuilder: (context, index) {
                        return getImages(index);
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            CDButton(
              width: double.infinity,
              text: "저장",
              press: _onSave,
            ),
          ],
        ),
      ),
    );
  }

  _onSave() async {
    logger.i("upload");
    Rating rating = Rating(
      fromUserId: Singleton.shared.userData!.userId,
      toUserId: widget.bidResponseData.bid!.factoryId,
      productId: widget.productResponseData.productId,
      productName: widget.productResponseData.product!.name,
      bidId: widget.bidResponseData.bidId,
      review: reviewController.text,
      score: score,
      imageUrl: imageUrls,
    );

    await context.read(ratingListNotifier).createRating(rating).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("저장되었습니다."),
        ),
      );
      widget.productResponseData.product!.state = 'rated';
      Navigator.pop(context, true);
    });

    logger.i(rating.toMap());
  }

  Widget getAddPhotoBtn() {
    return InkWell(
      onTap: () async {
        _selectedAssetList = (await CDImagePicker().cameraAndStay(
            context: context, assets: _selectedAssetList, maxAssetsCount: 5))!;
        await getFileList();
        await updateImageToServer();
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, right: 10),
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            border: Border.all(color: CDColors.black05, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                color: CDColors.black05,
              ),
              SizedBox(height: 4),
              Text(
                '${_selectedAssetList.length} / 5',
                style: CDTextStyle.medium10black05,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getImages(index) {
    return RawMaterialButton(
      onPressed: () async {
        // 클릭했을때 list 에 추가하고, 순서하고

        _selectedAssetList.removeAt(index);
        imageUrls.removeAt(index);
        _images.removeAt(index);
        setState(() {});
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: imageUrls[index],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: _getSelectedPhotoEraseCircle(),
          )
        ],
      ),
    );
  }

  Future<void> getFileList() async {
    _images.clear();

    for (final AssetEntity asset in _selectedAssetList) {
      // If the entity `isAll`, that's the "Recent" entity you want.
      File? file = await asset.originFile;
      if (file != null) {
        var filePath = file.absolute.path;
        print('original size = ${asset.width} / ${asset.height}');
        if (asset.width > 1080 && asset.height > 1080) {
          final int? shorterSide =
              asset.width < asset.height ? asset.width : asset.height;
          final int resizePercent = (1080.0 / shorterSide! * 100).toInt();

          File compressedFile = await FlutterNativeImage.compressImage(filePath,
              quality: 85, percentage: resizePercent);

          print('resize Percent = $resizePercent');
          print('compressed File = ${compressedFile.toString()}');

          filePath = compressedFile.path;
        }
        try {
          if (filePath.toLowerCase().endsWith(".heic") ||
              filePath.toLowerCase().endsWith(".heif")) {
            String? jpgPath = await HeicToJpg.convert(filePath);
            File file = File(jpgPath!);

            _images.add(file);
          } else {
            File file = File(filePath);

            _images.add(file);
          }
        } on Exception catch (e) {
          print(e.toString());
        }
      }
    }
  }

  Future<void> updateImageToServer() async {
    if (_images.isNotEmpty) {
      await context
          .read(fileControllerNotifier)
          .uploadImages(_images)
          .then((value) async {
        imageUrls = value!.images!;
      });
    }
  }

  Widget _getSelectedPhotoEraseCircle() {
    return Container(
      height: 20,
      width: 20,
      child: CircleAvatar(
        child: Icon(
          Icons.close,
          size: 16,
          color: Colors.white.withOpacity(0.8),
        ),
        backgroundColor: CDColors.black05.withOpacity(0.8),
      ),
    );
  }
}
