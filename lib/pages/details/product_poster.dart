import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:crediApp/global/constants.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

import 'components/page_indicator.dart';

class ProductPoster extends StatefulWidget {
  const ProductPoster({
    Key? key,
    required this.size,
    this.items,
  }) : super(key: key);

  final Size size;
  final List<String>? items;

  @override
  _ProductPosterState createState() => _ProductPosterState();
}

class _ProductPosterState extends State<ProductPoster> {
  int _imageIndex = 0;
  SwiperController? _swiperController;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(vertical: kDefaultPadding),
      // height: widget.size.width * 0.8,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              widget.items!.length == 0
                  ? Container(
                      color: CDColors.white01,
                      width: widget.size.width,
                      height: widget.size.width * 0.75,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ImageIcon(AssetImage("assets/icons/ic_sad.png"),
                              size: 36),
                          SizedBox(height: 16),
                          Text('등록된 사진이 없습니다'),
                        ],
                      ),
                    )
                  : Container(
                      color: CDColors.white01,
                      width: widget.size.width,
                      height: widget.size.width * 0.75,
                      child: Swiper(
                        loop: false,
                        controller: _swiperController,
                        itemCount: widget.items!.length,
                        onIndexChanged: onIndexChanged,
                        itemBuilder: (context, index) {
                          String image = widget.items![index];
                          return CachedNetworkImage(
                            imageUrl: image,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Container(color: CDColors.gray1),
                          );
                        },
                        onTap: (index) {
                          Navigator.of(context).pushNamed('PhotoViewer',
                              arguments: widget.items![index]);
                        },
                        //   );
                        // }).toList(),
                      ),
                      // Image.asset(
                      //   image,
                      //   height: size.width * 0.75,
                      //   width: size.width * 0.75,
                      //   fit: BoxFit.cover,
                      // )
                    ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    child: Center(
                      widthFactor: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "${_imageIndex + 1}/${widget.items!.length}",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    // padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Color(0xFF636363),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // PageIndicator(count: widget.items.length, index: _imageIndex),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: List.generate(
          //       widget.items.length,
          //       (index) => buildDot(index: index),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  // AnimatedContainer buildDot({int index}) {
  //   return AnimatedContainer(
  //     duration: Duration(milliseconds: 300),
  //     margin: EdgeInsets.only(right: 5),
  //     height: 6,
  //     width: _imageIndex == index ? 20 : 6,
  //     decoration: BoxDecoration(
  //       color: _imageIndex == index ? CDColors.blue3 : Color(0xFFD8D8D8),
  //       borderRadius: BorderRadius.circular(3),
  //     ),
  //   );
  // }

  onIndexChanged(value) {
    setState(() {
      _imageIndex = value;
    });
  }
}
