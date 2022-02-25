import 'package:cached_network_image/cached_network_image.dart';
import 'package:crediApp/global/enums/product_state_type.dart';

import 'package:flutter/material.dart';
import 'package:crediApp/global/constants.dart';

class CellProductSmall extends StatelessWidget {
  const CellProductSmall({
    Key? key,
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

  final bool? isFavorite;
  final Function? press;

  final String? title, material, description, image, state;
  final int? id, quantity;
  final int? itemIndex;
  final bool? isConsultingNeeded;
  final bool isFactory = true;

  final textStyleTitle = CDTextStyle.bold13black03;
  final textStyleBody = CDTextStyle.bold16black01;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: CDColors.gray2, width: 0.5)),
      ),
      child: InkWell(
        onTap: press as void Function()?,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              child: Container(
                width: 52,
                height: 52,
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
              child: Container(
                height: 90,
                // constraints: BoxConstraints(maxWidth: size.width - 45 - 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacer(),
                    Container(
                      child: Text(
                        "견적번호",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                    Spacer(),
                  ],
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: CDColors.gray2,
            ),
          ],
        ),
      ),
    );
  }
}
