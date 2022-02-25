import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:crediApp/global/constants.dart';

class ProductsCard extends StatelessWidget {
  const ProductsCard({
    Key? key,
    this.id,
    this.title,
    this.description,
    this.image,
    this.quantity,
    this.itemIndex,
    this.press,
  }) : super(key: key);

  final String? id, title, description, image;
  final int? quantity;
  final int? itemIndex;
  final Function? press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      bottom: false,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: kDefaultPadding,
          vertical: 10,
        ),
        // color: Colors.blueAccent,
        height: 160,
        child: InkWell(
          onTap: press as void Function()?,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 136,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: itemIndex!.isEven ? CDColors.primary : kSecondaryColor,
                  boxShadow: [kDefaultShadow],
                ),
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
              ),

              /// product Image
              Positioned(
                top: 0,
                right: 0,
                child: Hero(
                  tag: id!,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    height: 160,
                    width: 200, // 20 padding horizontal
                    child: CachedNetworkImage(
                      imageUrl: image!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          Container(color: CDColors.gray1),
                    ),
                  ), //.asset(image, fit: BoxFit.cover)),
                ),
              ),

              /// product title and price
              Positioned(
                bottom: 0,
                left: 0,
                child: SizedBox(
                  height: 136,
                  width: size.width - 200, // our image takes width 200
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding),
                        child: Text(
                          title!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: kSecondaryColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(22),
                              topRight: Radius.circular(22)),
                        ),
                        child: Text(
                          "수량 : $quantity",
                          style: Theme.of(context).textTheme.button,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// void showMessage(String msg) {
//     const msg =
//         "This is a ver very long message. This is a ver very long message. This is a ver very long message. This is a ver very long message. This is a ver very long message. ";
//     final snack = SnackBar(
//       content: Text(
//         msg,
//         style: TextStyle(fontSize: 20),
//       ),
//       backgroundColor: CDColors.primary,
//     );
//
//     Scaffold.of(context)
//       ..removeCurrentSnackBar()
//       ..showSnackBar(snack);
//   }
// }
}
