import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crediApp/global/components/cd_image_picker.dart';
import 'package:crediApp/global/components/circularcheckbox.dart';
import 'package:crediApp/global/components/view_state_container.dart';
import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/enums/view_state.dart';
import 'package:crediApp/global/providers/file_controller.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:crediApp/pages/99Others/error_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heic_to_jpg/heic_to_jpg.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class CreateProductDetailContainer extends StatefulWidget {
  final GlobalKey<FormState>? formKey;
  final TextEditingController? titleTextController;
  final TextEditingController? widthTextController;
  final TextEditingController? heightTextController;
  final TextEditingController? depthTextController;
  final TextEditingController? descriptionTextController;

  const CreateProductDetailContainer({
    Key? key,
    this.formKey,
    this.titleTextController,
    this.depthTextController,
    this.descriptionTextController,
    this.heightTextController,
    this.widthTextController,
  }) : super(key: key);

  @override
  _CreateProductDetailContainerState createState() =>
      _CreateProductDetailContainerState();
}

class _CreateProductDetailContainerState
    extends State<CreateProductDetailContainer> {
  List<File> _images = [];
  List<String> imageUrls = [];
  List<AssetEntity> _selectedAssetList = [];

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Column(
                children: [
                  Text('제품 정보를 알려주세요.', style: CDTextStyle.bold24black01),
                  SizedBox(height: 6),
                  Text('마지막 단계입니다.', style: CDTextStyle.regular17blue03),
                ],
              ),
            ),
          ),
          SizedBox(height: 15),
          Text('제품명'),
          SizedBox(height: 8),
          Container(
            height: 54,
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(color: CDColors.black05, width: 1)),
            child: TextFormField(
              controller: widget.titleTextController,
              decoration: InputDecoration(
                hintText: "ex) 플라스틱 텀블러",
                hintStyle: CDTextStyle.regular17black04,
                labelStyle: TextStyle(color: Colors.transparent),
                border: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 1,
              onEditingComplete: () => node.nextFocus(),
              onChanged: (text) {
                context.read(productListNotifier).myProduct.productName = text;
              },
              // validator: (text) {
              //   return (text == null || text.isEmpty) ? '제목을 입력해주세요.' : null;
              // },
            ),
          ),
          SizedBox(height: 18),
          Text('크기 (mm)'),
          SizedBox(height: 8),
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    height: 54,
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(color: CDColors.black05, width: 1)),
                    child: TextFormField(
                      enableInteractiveSelection: false,
                      controller: widget.widthTextController,
                      decoration: InputDecoration(
                        hintText: "가로",
                        hintStyle: CDTextStyle.regular17black04,
                        labelStyle: TextStyle(color: Colors.transparent),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      onEditingComplete: () => node.nextFocus(),
                      onChanged: (text) {
                        context.read(productListNotifier).myProduct.width =
                            int.parse(text);
                      },
                      // validator: (text) {
                      //   return (text == null || text.isEmpty)
                      //       ? '숫자를 입력하세요.'
                      //       : null;
                      // },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Text('X', style: CDTextStyle.regular14black04),
                ),
                Expanded(
                  child: Container(
                    height: 54,
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(color: CDColors.black05, width: 1)),
                    child: TextFormField(
                      enableInteractiveSelection: false,
                      controller: widget.heightTextController,
                      decoration: InputDecoration(
                        hintText: "세로",
                        hintStyle: CDTextStyle.regular17black04,
                        labelStyle: TextStyle(color: Colors.transparent),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      onEditingComplete: () => node.nextFocus(),
                      onChanged: (text) {
                        context.read(productListNotifier).myProduct.height =
                            int.parse(text);
                      },
                      // validator: (text) {
                      //   return (text == null || text.isEmpty)
                      //       ? '숫자를 입력하세요.'
                      //       : null;
                      // },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Text('X', style: CDTextStyle.regular14black04),
                ),
                Expanded(
                  child: Container(
                    height: 54,
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(color: CDColors.black05, width: 1)),
                    child: TextFormField(
                      enableInteractiveSelection: false,
                      controller: widget.depthTextController,
                      decoration: InputDecoration(
                        hintText: "높이",
                        hintStyle: CDTextStyle.regular17black04,
                        labelStyle: TextStyle(color: Colors.transparent),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      onEditingComplete: () => node.nextFocus(),
                      onChanged: (text) {
                        context.read(productListNotifier).myProduct.depth =
                            int.parse(text);
                      },
                      // validator: (text) {
                      //   return (text == null || text.isEmpty)
                      //       ? '숫자를 입력하세요.'
                      //       : null;
                      // },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 18),
          Text('제품설명'),
          SizedBox(height: 8),
          Container(
            height: 150,
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(color: CDColors.black05, width: 1)),
            child: TextFormField(
              maxLines: null,
              controller: widget.descriptionTextController,
              decoration: InputDecoration(
                hintText: '제품 설명이 상세할수록\n정확한 견적 가격이 산출됩니다.',
                hintStyle: CDTextStyle.regular17black04,
                labelStyle: TextStyle(color: Colors.transparent),
                border: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (text) {
                context.read(productListNotifier).myProduct.description = text;
              },
              // validator: (text) {
              //   return (text == null || text.isEmpty) ? '제품 설명을 입력해주세요.' : null;
              // },
            ),
          ),
          SizedBox(height: 18),
          Text('제품사진'),
          SizedBox(height: 8),
          Text('(도면, 사진, 스케치, 레퍼런스 등)', style: CDTextStyle.regular14black04),
          SizedBox(height: 8),
          Container(
            height: 80,
            width: double.infinity,
            child: Consumer(builder: (context, watch, _) {
              FileControllerChangeNotifier _fileControllerNotifier =
                  watch(fileControllerNotifier);
              if (_fileControllerNotifier.state == ViewState.Busy) {
                return ViewStateContainer.busyContainer();
                // return SizedBox.shrink();
              } else if (_fileControllerNotifier.state == ViewState.Error) {
                return ErrorPage();
              }
              return Row(
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
              );
            }),
          ),
          SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              children: [
                CircularCheckBox(
                  onChanged: (bool? value) {
                    setState(() {
                      context.read(productListNotifier).myProduct.hasDrawing =
                          value;
                    });
                  },
                  value:
                      context.read(productListNotifier).myProduct.hasDrawing ??
                          false,
                  activeColor: CDColors.blue03,
                  inactiveColor: CDColors.black05,
                ),
                SizedBox(width: 4),
                Text('도면을 보유하고 계신가요?', style: CDTextStyle.regular16black01),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              children: [
                CircularCheckBox(
                  onChanged: (bool? value) {
                    setState(() {
                      context
                          .read(productListNotifier)
                          .myProduct
                          .isConsultingNeeded = value;
                    });
                  },
                  value: context
                          .read(productListNotifier)
                          .myProduct
                          .isConsultingNeeded ??
                      false,
                  activeColor: CDColors.blue03,
                  inactiveColor: CDColors.black05,
                ),
                SizedBox(width: 4),
                Text('컨설팅이 가능한 공장을 찾고 계신가요?',
                    style: CDTextStyle.regular17black01),
              ],
            ),
          ),
          SizedBox(height: 10),
        ],
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
                '${imageUrls.length} / 5',
                style: CDTextStyle.medium10black05,
              ),
            ],
          ),
        ),
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
        context.read(productListNotifier).setMyProductImageUrls(imageUrls);
        // context.read(productListNotifier).myProduct.imageUrl = imageUrls;
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
