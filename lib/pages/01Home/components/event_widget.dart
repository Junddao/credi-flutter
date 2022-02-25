import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/models/info/event_response_model.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventWidget extends StatefulWidget {
  const EventWidget({Key? key, this.openEvent}) : super(key: key);

  final Function? openEvent;
  @override
  _EventWidgetState createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  double currentBannerIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<EventResponseData> eventResponseData =
        context.read(infoChangeNotifier).eventResponseDatas!;
    SizeConfig().init(context);
    double? screenHeight =
        (SizeConfig.screenWidth - kDefaultHorizontalPadding * 2) * 150 / 327;

    return eventResponseData.length == 0
        ? SizedBox.shrink()
        : Container(
            width: SizeConfig.screenWidth,
            height: screenHeight,
            child: Stack(
              children: <Widget>[
                CarouselSlider.builder(
                  itemCount: eventResponseData.length,
                  itemBuilder:
                      (BuildContext context, int itemIndex, int pageViewIndex) {
                    return InkWell(
                      onTap: () {
                        widget.openEvent!(
                            eventResponseData[itemIndex].event!.url);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          imageUrl: eventResponseData[itemIndex].event!.image!,
                          fit: BoxFit.cover,
                          errorWidget: (BuildContext, String, dynamic) {
                            return Container(child: Text('이미지를 불러오지 못했습니다.'));
                          },
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                      autoPlay: eventResponseData.length > 1 ? true : false,
                      enlargeCenterPage: true,
                      viewportFraction: 1,
                      aspectRatio: 327 / 150,
                      initialPage: 0,
                      onPageChanged: (page, _) {
                        setState(() {
                          currentBannerIndex = page.toDouble();
                        });
                      }),
                ),
                Positioned(
                  bottom: 8,
                  right: 10,
                  left: 10,
                  child: DotsIndicator(
                    dotsCount: eventResponseData.length,
                    position: currentBannerIndex,
                    decorator: DotsDecorator(
                      size: Size(8, 8),
                      activeSize: Size(8, 8),
                      color: Colors.white,
                      activeColor: CDColors.blue03,
                      spacing: EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
