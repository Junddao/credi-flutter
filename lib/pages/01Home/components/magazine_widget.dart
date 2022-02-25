import 'package:cached_network_image/cached_network_image.dart';
import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/models/info/magazine_response_model.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:crediApp/pages/99Others/error_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/provider.dart';

class MagazineWidget extends StatefulWidget {
  const MagazineWidget({Key? key, this.openMagazine}) : super(key: key);

  final Function? openMagazine;
  @override
  _MagazineWidgetState createState() => _MagazineWidgetState();
}

class _MagazineWidgetState extends State<MagazineWidget> {
  @override
  Widget build(BuildContext context) {
    List<MagazineResponseData>? magazineResponseData =
        context.read(infoChangeNotifier).magazineResponseDatas;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('매거진', style: CDTextStyle.bold16black01),
        SizedBox(height: 22),
        Container(
          height: SizeConfig.screenWidth * 0.5,
          width: double.infinity,
          child: ListView.builder(
            itemCount: magazineResponseData!.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return _listTile(magazineResponseData, index);
            },
          ),
        ),
      ],
    );
  }

  _listTile(List<MagazineResponseData>? magazineResponseData, int index) {
    String? url = magazineResponseData![index].magazine!.url!;
    return Padding(
      padding: const EdgeInsets.only(right: 22),
      child: InkWell(
        onTap: () {
          widget.openMagazine!(url);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22.0),
          child: CachedNetworkImage(
            imageUrl: magazineResponseData[index].magazine!.image!,
            fit: BoxFit.cover,
            height: SizeConfig.screenWidth * 0.5,
            width: SizeConfig.screenWidth * 0.5,
          ),
        ),
      ),
    );
  }
}
