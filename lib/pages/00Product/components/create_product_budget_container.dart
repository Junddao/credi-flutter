import 'package:crediApp/global/components/circularcheckbox.dart';
import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/models/product/product_budget_type.dart';
import 'package:crediApp/global/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateProductBudgetContainer extends StatefulWidget {
  final Function? setActivateState;
  const CreateProductBudgetContainer({Key? key, this.setActivateState})
      : super(key: key);

  @override
  _CreateProductBudgetContainerState createState() =>
      _CreateProductBudgetContainerState();
}

class _CreateProductBudgetContainerState
    extends State<CreateProductBudgetContainer> {
  ProductBudgetType productBudgetType = ProductBudgetType();

  @override
  Widget build(BuildContext context) {
    productBudgetType = context.read(productListNotifier).productBudgetType;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Column(
              children: [
                Text('예산을 알려주세요.', style: CDTextStyle.bold24black01),
                SizedBox(height: 6),
                Text('', style: CDTextStyle.regular17black04),
              ],
            ),
          ),
        ),
        SizedBox(height: 50),
        Column(
          children: productBudgetType.budgetTypes!.keys.map((key) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  CircularCheckBox(
                    onChanged: (bool? value) {
                      setState(() {
                        //false로 초기화 후 set
                        productBudgetType.budgetTypes!.forEach((key, value) {
                          productBudgetType.budgetTypes![key] = false;
                        });
                        productBudgetType.budgetTypes![key] = value!;

                        context
                            .read(productListNotifier)
                            .setSelectedBudget(productBudgetType);
                      });
                    },
                    value: productBudgetType.budgetTypes![key]!,
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
      ],
    );
  }
}
