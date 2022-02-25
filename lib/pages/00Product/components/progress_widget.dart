import 'package:crediApp/global/constants.dart';
import 'package:crediApp/global/enums/product_state_type.dart';
import 'package:flutter/material.dart';

class ProgressWidget extends StatelessWidget {
  ProgressWidget({
    Key? key,
    @required String? productState,
  })  : _productState = productState,
        super(key: key);

  final List<String>? _titles = const ['견적비교', '발주중', '제작중', '제작완료'];
  final String? _productState;

  final Color? _activeColor = CDColors.blue03;
  final Color _inactiveColor = CDColors.black05;

  final double lineWidth = 3.0;
  int? _curStep = 0;

  Widget build(BuildContext context) {
    switch (_productState) {
      case ProductStateType.uploaded:
      case ProductStateType.comparing:
      case ProductStateType.chatting:
        _curStep = 0;
        break;

      case ProductStateType.ordering:
        _curStep = 1;
        break;
      case ProductStateType.making:
        _curStep = 2;
        break;
      case ProductStateType.done:

      case ProductStateType.rated:
        _curStep = 3;
        break;

      default:
    }
    return Container(
      width: SizeConfig.screenWidth,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      color: CDColors.blue04,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('진행 현황', style: CDTextStyle.bold14white02),
          SizedBox(height: 8),
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                color: CDColors.white02,
              ),
              padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 10),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Row(
                      children: _iconViews(),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _titleViews(),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  List<Widget> _iconViews() {
    var list = <Widget>[];
    _titles!.asMap().forEach((i, icon) {
      var circleColor = (_curStep! >= i) ? _activeColor : _inactiveColor;
      var lineColor = _curStep! > i ? _activeColor : _inactiveColor;

      var icon = (_curStep! >= i)
          ? Icon(
              Icons.check,
              color: CDColors.white01,
              size: 12.0,
            )
          : SizedBox.shrink();

      list.add(
        Container(
          width: 20.0,
          height: 20.0,
          padding: EdgeInsets.all(0),
          decoration: new BoxDecoration(
            /* color: circleColor,*/
            borderRadius: new BorderRadius.all(new Radius.circular(22.0)),
            color: circleColor,
            // border: new Border.all(
            //   color: circleColor!,
            //   width: 2.0,
            // ),
          ),
          child: icon,
        ),
      );

      //line between icons
      if (i != _titles!.length - 1) {
        list.add(Expanded(
            child: Container(
          height: lineWidth,
          color: lineColor,
        )));
      }
    });

    return list;
  }

  List<Widget> _titleViews() {
    var list = <Widget>[];
    _titles!.asMap().forEach((i, text) {
      var textstyle = (_curStep! >= i)
          ? CDTextStyle.regular12blue03
          : CDTextStyle.regular12black05;
      list.add(Text(text, style: textstyle));
    });
    return list;
  }
}
