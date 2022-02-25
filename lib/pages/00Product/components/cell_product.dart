import 'package:cached_network_image/cached_network_image.dart';
import 'package:crediApp/global/enums/product_state_type.dart';
import 'package:crediApp/global/models/user/user_type_model.dart';
import 'package:crediApp/global/service/service_string_utils.dart';
import 'package:crediApp/global/singleton.dart';

import 'package:flutter/material.dart';
import 'package:crediApp/global/constants.dart';

class CellProduct extends StatelessWidget {
  const CellProduct({
    Key? key,
    required this.size,
    required TextStyle biggerFont,
    this.isFavorite,
    this.press,
    this.id,
    required this.title,
    required this.material,
    required this.description,
    this.image,
    this.quantity,
    this.itemIndex,
    this.state,
    this.isConsultingNeeded,
  }) : super(key: key);

  final Size size;
  final bool? isFavorite;
  final Function? press;

  final String? title, material, description, image, state;
  final int? id, quantity;
  final int? itemIndex;
  final bool? isConsultingNeeded;
  final bool isFactory = true;

  final textStyleTitle = CDTextStyle.regular13black03;
  final textStyleBody = CDTextStyle.regular13black01;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0),
      child: InkWell(
        onTap: press as void Function()?,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              // child: Image(image: NetworkImage(product.images[0]),
              child: Container(
                width: 105,
                height: 105,
                child: image == null
                    ? Container(color: CDColors.gray1)
                    : CachedNetworkImage(
                        imageUrl: image!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            Container(color: CDColors.gray1),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          title ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: CDTextStyle.bold16black01,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 60,
                                child: Text(
                                  "견적번호",
                                  style: textStyleTitle,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "$id",
                                  overflow: TextOverflow.ellipsis,
                                  style: textStyleBody,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 60,
                                child: Text(
                                  "소재",
                                  style: textStyleTitle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  material ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textStyleBody,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 60,
                                child: Text(
                                  "수량",
                                  maxLines: 1,
                                  style: textStyleTitle,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  ServiceStringUtils.quantity(quantity ?? 0),
                                  overflow: TextOverflow.ellipsis,
                                  style: textStyleBody,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
}
