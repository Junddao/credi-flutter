import 'package:flutter/material.dart';
import 'package:crediApp/global/constants.dart';

class SelectUserType extends StatefulWidget {
  final int? selectedIndex;
  final Function(int index)? onPress;
  final List<String>? categories;

  const SelectUserType(
      {Key? key, this.selectedIndex, this.onPress, this.categories})
      : super(key: key);
  @override
  _SelectUserTypeState createState() => _SelectUserTypeState();
}

class _SelectUserTypeState extends State<SelectUserType> {
  List<bool> _selection = [true, false];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 30,
      color: CDColors.blue2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ToggleButtons(
              // constraints: BoxConstraints.expand({width: 100}),
              children: widget.categories!.map((title) {
                return Container(
                    width: size.width / widget.categories!.length - (43 * 0.5),
                    alignment: Alignment.center,
                    child: Text(title));
              }).toList(),
              isSelected: _selection,
              color: Colors.white,
              selectedColor: Colors.white,
              selectedBorderColor: Colors.blue,
              fillColor: CDColors.blue5,
              onPressed: (index) {
                widget.onPress!(index);
                setState(() {
                  _selection = index == 0 ? [true, false] : [false, true];
                });
              },
            ),
          ),
          // Container(
          //   width: size.width * 0.5 - 30,
          //   alignment: Alignment.center,
          //   margin: EdgeInsets.only(
          //     left: kDefaultPadding,
          //     right: 1 == categories.length - 1 ? kDefaultPadding : 0,
          //   ),
          //   padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          //   decoration: BoxDecoration(
          //       color: 1 == widget.selectedIndex
          //           ? Colors.white.withOpacity(0.4)
          //           : Colors.transparent,
          //       borderRadius: BorderRadius.circular(6)),
          //   child: Text(
          //     categories[1],
          //     style: TextStyle(color: Colors.white),
          //   ),
          // ),
        ],
      ),
    );
  }
}
