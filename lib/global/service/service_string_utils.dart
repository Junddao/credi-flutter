import 'package:intl/intl.dart';

class ServiceStringUtils {
  static String numberWithComma(int number) {
    return NumberFormat('###,###,###,###').format(number).replaceAll(' ', '');
  }

  static String quantity(int number) {
    return NumberFormat('###,###,###,###').format(number).replaceAll(' ', '') +
        ' 개';
  }

  static String point(int number) {
    return NumberFormat('###,###,###,###').format(number).replaceAll(' ', '') +
        ' P';
  }

  static String won(int number) {
    return NumberFormat('###,###,###,###').format(number).replaceAll(' ', '') +
        ' ' +
        '원';
  }

  static String bindingPhoneNumber(String number) {
    var phoneNumber = '';
    // var numbers = List.generate(number.length, (index) {
    //   return number[index];
    // });

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
        // default:
        //   phoneNumber += number[i];
      }
    }
    return phoneNumber;
  }

  static List<String> jsonToStringList(dynamic parsedJson, String key) {
    var value;
    if (parsedJson[key] != null) {
      value = parsedJson[key].cast<String>();
    } else {
      value = <String>[];
    }
    return value;
  }
}
