import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:crediApp/global/service/number_textinputformatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateProductQuantityContainer extends StatefulWidget {
  final TextEditingController? quantityController;
  const CreateProductQuantityContainer({Key? key, this.quantityController})
      : super(key: key);

  @override
  _CreateProductQuantityContainerState createState() =>
      _CreateProductQuantityContainerState();
}

class _CreateProductQuantityContainerState
    extends State<CreateProductQuantityContainer> {
  int? productQuantity;
  @override
  Widget build(BuildContext context) {
    productQuantity = context.read(productListNotifier).productQuantity;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Column(
              children: [
                Text('예상수량을 알려주세요.', style: CDTextStyle.bold24black01),
                SizedBox(height: 6),
                Text('', style: CDTextStyle.regular17black04),
              ],
            ),
          ),
        ),
        SizedBox(height: 50),
        Container(
          height: 54,
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: CDColors.black05, width: 1)),
          child: TextFormField(
            enableInteractiveSelection: false,
            controller: widget.quantityController,
            decoration: InputDecoration(
              hintText: "직접 입력",
              hintStyle: CDTextStyle.regular17black04,
              labelStyle: TextStyle(color: Colors.transparent),
              border: UnderlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
              // NumberTextInputFormatter(),
            ],
            onChanged: (text) {
              if (text == '') {
                text = '0';
              }

              print(text);

              context
                  .read(productListNotifier)
                  .setProductQuantity(int.parse(text));
            },
          ),
        ),
      ],
    );
  }
}
