import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:crediApp/global/constants.dart';

class RoundedTextField extends StatefulWidget {
  final Widget? child;
  final String? title;
  final String? hintText;
  final IconData icon;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onEditingComplete;
  final TextInputAction? textInputAction;
  final bool showSecure;
  final TextInputType? keyboardType;
  bool isSecure = false;
  RoundedTextField({
    Key? key,
    this.child,
    this.title,
    this.hintText,
    this.icon = Icons.person,
    this.isSecure = false,
    this.showSecure = false,
    this.onChanged,
    this.controller,
    this.validator,
    this.onEditingComplete,
    this.textInputAction,
    this.keyboardType,
  }) : super(key: key);

  @override
  _RoundedTextFieldState createState() => _RoundedTextFieldState();
}

class _RoundedTextFieldState extends State<RoundedTextField> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(children: [
      Container(
        // margin: EdgeInsets.symmetric(vertical: 5),
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        // width: size.width * 0.8,
        height: kCellHeight,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(29)),
      ),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.fromLTRB(20, 7, 20, 0),
        height: kCellHeight,
        child: TextFormField(
          controller: widget.controller,
          autocorrect: false,
          obscureText: widget.isSecure,
          onChanged: widget.onChanged,
          validator: widget.validator,
          onEditingComplete: widget.onEditingComplete,
          textInputAction: widget.textInputAction,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            isDense: true,
            labelText: widget.title,
            hintText: widget.hintText,
            fillColor: Colors.blue,
            icon: Icon(widget.icon, color: kPrimaryColor),
            suffixIcon: widget.showSecure
                ? IconButton(
                    icon: widget.isSecure
                        ? Icon(Icons.visibility, color: kPrimaryColor)
                        : Icon(Icons.visibility_off, color: kPrimaryColor),
                    onPressed: () {
                      setState(() {
                        widget.isSecure = !widget.isSecure;
                      });
                    },
                  )
                : null,
            border: InputBorder.none,
          ),
        ),
      ),
    ]);
  }
}
