import 'package:flutter/services.dart';

class TextInputFormatterPhone extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (oldValue.text.length > newValue.text.length) {
      return new TextEditingValue(
        text: newValue.text,
        selection: new TextSelection.collapsed(offset: newValue.text.length),
      );
    }
    if (newValue.text.length > 13) {
      return new TextEditingValue(
        text: oldValue.text,
        selection: new TextSelection.collapsed(offset: oldValue.text.length),
      );
    }
    var phoneNumber = '';
    var number = newValue.text.replaceAll('-', '');
    for (var i = 0; i < number.length; i++) {
      phoneNumber += number[i];
      switch (i) {
        case 2:
          phoneNumber += '-';
          break;
        case 5:
          phoneNumber += '-';
          break;
        case 10:
          phoneNumber = phoneNumber.replaceRange(7, 8, '');
          phoneNumber = phoneNumber.substring(0, 8) +
              '-' +
              phoneNumber.substring(8, phoneNumber.length);

          break;
      }
    }

    return new TextEditingValue(
      text: phoneNumber,
      selection: new TextSelection.collapsed(offset: phoneNumber.length),
    );
  }
}
