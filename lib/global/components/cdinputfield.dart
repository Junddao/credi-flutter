import 'package:crediApp/global/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CDInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String? title;
  final String? hintText;
  final int? maxLines;
  final int? minLines;
  final String? warningMessage;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign? textAlign;
  const CDInputField({
    Key? key,
    this.controller,
    this.title,
    this.hintText,
    this.maxLines,
    this.minLines,
    this.warningMessage,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.onEditingComplete,
    this.keyboardType,
    this.inputFormatters,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: CDColors.black05),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: CDColors.black05),
        ),
        labelText: title,
        hintText: hintText,
        labelStyle: CDTextStyle.regular18black05,
        hintStyle: CDTextStyle.regular18black05,
      ),
      validator: warningMessage == null || validator != null
          ? validator
          : _validateText,
      onSaved: onSaved,
      onChanged: onChanged,
      minLines: minLines,
      maxLines: maxLines,
      onEditingComplete: onEditingComplete,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textAlign: textAlign ?? TextAlign.start,
    );
  }

  String? _validateText(String? text) {
    if (text == null || text.isEmpty) {
      return warningMessage;
    } else {
      return null;
    }
  }
}
