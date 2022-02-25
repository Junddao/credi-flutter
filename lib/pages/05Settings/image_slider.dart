import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class ImageSlider extends StatefulWidget {
  ImageSlider({Key? key, required this.imageUrl, this.swiperController})
      : super(key: key);
  final List<String> imageUrl;
  final SwiperController? swiperController;

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int imageIndex = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    logger.i('dispose');
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    logger.i("ImageSlider : ${widget.imageUrl}");
    return Container(
      margin: EdgeInsets.symmetric(vertical: kDefaultPadding),
      // height: widget.size.width * 0.8,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: size.width,
                height: size.width * 0.75 - 80,
                child: Swiper(
                    // options: CarouselOptions(
                    //   height: size.width - 80,
                    //   disableCenter: true,
                    //   enableInfiniteScroll: false,
                    // ),
                    // items: _images.map((imageFile) {
                    // key: Key("swiper"),
                    controller: widget.swiperController,
                    itemCount: widget.imageUrl.length,
                    onIndexChanged: onIndexChanged,
                    itemBuilder: (context, index) {
                      String image = widget.imageUrl[index];
                      logger.i("image : $image");
                      return CachedNetworkImage(
                        imageUrl: image,
                        fit: BoxFit.contain,
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            Container(color: CDColors.gray1),
                      );

                      // return Builder(
                      //   builder: (BuildContext context) {
                      //     return Container(
                      //       width: size.width,
                      //       margin:
                      //           EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                      //       decoration: BoxDecoration(
                      //           color: Colors.grey, borderRadius: Constants.boxBorder),
                      //       child: GestureDetector(
                      //         child: _decideImageView(imageFile),
                      //         onTap: () => {showChoiceDialog(context)},
                      //       ),
                      //     );
                      //     // Text(
                      //     //   'text $i',
                      //     //   style: TextStyle(fontSize: 16.0),
                      //     // ),
                      //   },
                      // );
                    }
                    // ).toList(),
                    ),
              )
            ],
          ),
          // PageIndicator(count: widget.items.length, index: _imageIndex),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.imageUrl.length,
                (index) => buildDot(index: index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: imageIndex == index ? 20 : 6,
      decoration: BoxDecoration(
        color: imageIndex == index ? CDColors.blue3 : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  onIndexChanged(int index) {
    this.setState(() {
      imageIndex = index;
    });
  }
}
