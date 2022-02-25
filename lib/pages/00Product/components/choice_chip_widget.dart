import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/enums/product_state_type.dart';
import 'package:crediApp/global/providers/parent_provider.dart';
import 'package:crediApp/global/providers/products.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:crediApp/global/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChoiceChipWidget extends StatefulWidget {
  const ChoiceChipWidget({
    Key? key,
  }) : super(key: key);

  @override
  _ChoiceChipWidgetState createState() => new _ChoiceChipWidgetState();
}

class _ChoiceChipWidgetState extends State<ChoiceChipWidget> {
  @override
  void initState() {
    initViewState();
    Future.microtask(() {
      context
          .read(productListNotifier)
          .setProductStateList(ProductStateType.productStateMap.keys.toList());
    });

    super.initState();
  }

  @override
  void dispose() {
    uninitViewState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, watch, __) {
      ProductChangeNotifier _productNotifier = watch(productListNotifier);
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
            child: Row(
              children: _buildChoiceList(_productNotifier),
            ),
          ),
        ),
      );
    });
  }

  List<String> iconPaths = [
    'assets/icons/writing.png',
    'assets/icons/comparing.png',
    'assets/icons/chatting.png',
    'assets/icons/ordering.png',
    'assets/icons/making.png',
    'assets/icons/done.png',
    'assets/icons/rating.png',
  ];

  _buildChoiceList(ProductChangeNotifier _productNotifier) {
    List<String> selectedItems = _productNotifier.productStateList!;
    List<Widget> chips = [];
    int i = 0;
    ProductStateType.productStateMap.forEach((key, value) {
      chips.add(
        InkWell(
          onTap: () {
            selectedItems.contains(key)
                ? selectedItems.remove(key)
                : selectedItems.add(key);
            _productNotifier.setProductStateList(selectedItems);
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: selectedItems.contains(key)
                ? Column(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: CDColors.blue03,
                        child: Image.asset(
                          iconPaths[i],
                          color: CDColors.white02,
                          height: 20,
                          width: 20,
                          // scale: 0.3,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(value, style: CDTextStyle.regular13black01),
                    ],
                  )
                : Column(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: CDColors.black05,
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: CDColors.white02,
                          child: Image.asset(
                            iconPaths[i],
                            color: CDColors.black05,
                            height: 20,
                            width: 20,
                            // scale: 0.3,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(value, style: CDTextStyle.bold12black05),
                    ],
                  ),
          ),
        ),
      );
      i++;
    });

    return chips;
  }
}
