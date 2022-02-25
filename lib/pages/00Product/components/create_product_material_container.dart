import 'package:crediApp/global/components/circularcheckbox.dart';
import 'package:crediApp/global/models/product/product_material_type.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:crediApp/global/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateProductMaterialContainer extends StatefulWidget {
  final TextEditingController? materialController;

  final Function? setActivateState;

  const CreateProductMaterialContainer({
    Key? key,
    this.setActivateState,
    this.materialController,
  }) : super(key: key);

  @override
  _CreateProductMaterialContainerState createState() =>
      _CreateProductMaterialContainerState();
}

class _CreateProductMaterialContainerState
    extends State<CreateProductMaterialContainer> {
  ProductMaterialType productMaterialType = ProductMaterialType();

  @override
  Widget build(BuildContext context) {
    productMaterialType = context.read(productListNotifier).productMaterialType;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Column(
              children: [
                Text('소재를 알려주세요.', style: CDTextStyle.bold24black01),
                SizedBox(height: 6),
                Text('중복선택 가능.', style: CDTextStyle.regular17black04),
              ],
            ),
          ),
        ),
        SizedBox(height: 50),
        Column(
          children: productMaterialType.materials!.keys.map((key) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  CircularCheckBox(
                    onChanged: (bool? value) {
                      setState(() {
                        productMaterialType.materials![key] = value!;

                        if (productMaterialType.materials!
                            .containsValue(true)) {
                          // widget.setActivateState!(true);
                        } else {
                          // widget.setActivateState!(false);
                        }
                      });
                      context
                          .read(productListNotifier)
                          .setSelectedMaterial(productMaterialType);
                    },
                    value: productMaterialType.materials![key]!,
                    activeColor: CDColors.blue03,
                    inactiveColor: CDColors.black05,
                  ),
                  SizedBox(width: 4),
                  Text(key, style: CDTextStyle.regular17black01),
                ],
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 5),
        productMaterialType.materials!['기타'] == false
            ? SizedBox.shrink()
            : Container(
                height: 54,
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border: Border.all(color: CDColors.black05, width: 1)),
                child: TextFormField(
                  controller: widget.materialController,
                  decoration: InputDecoration(
                    hintText: "직접 입력",
                    hintStyle: CDTextStyle.regular17black04,
                    labelStyle: TextStyle(color: Colors.transparent),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (text) {
                    productMaterialType.etc = text;
                    context
                        .read(productListNotifier)
                        .setSelectedMaterial(productMaterialType);
                  },
                  validator: (text) {
                    return text == null ? '소재를 입력해주세요.' : null;
                  },
                ),
              ),
      ],
    );
  }
}
