import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoundFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? title;
  final String? placeholder;
  final String? warningMessage;
  final String Function(String? value)? validator;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  const RoundFormField({
    Key? key,
    this.controller,
    this.title,
    this.placeholder,
    this.warningMessage,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.onEditingComplete,
    this.keyboardType,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          labelText: title,
          hintText: placeholder,
        ),
        validator: warningMessage == null || validator != null
            ? validator
            : _validateText as String? Function(String?)?,
        onSaved: onSaved,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
      ),
    );
  }

  String? _validateText(String text) {
    if (text.isEmpty) {
      return warningMessage;
    } else {
      return null;
    }
  }
}
