import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raashan_merchant/constants.dart';
// import 'package:raashan_merchant/models/cart.dart';
import 'package:raashan_merchant/models/product.dart';
import 'package:flutter/material.dart';
import 'package:raashan_merchant/models/product_asset.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, bool>> fetchLoginStrategy() async {
  Map<String, bool> res = Map();
  res['phoneAllowed'] = true;
  res['googleAllowed'] = true;
  DocumentSnapshot snapshot = await Firestore.instance
      .collection('strategies')
      .document('signin')
      .get();
  if (snapshot.exists) {
    try {
      Map<String, dynamic> data = snapshot.data;
      Map<dynamic, dynamic> ios = data['ios'][APP_VERSION];
      Map<dynamic, dynamic> android = data['android'][APP_VERSION];
      if (Platform.isIOS) {
        if (ios != null) {
          res['phoneAllowed'] = false;
          res['googleAllowed'] = ios['google'] ?? false;
        }
      } else if (Platform.isAndroid) {
        if (android != null) {
          res['phoneAllowed'] = android['phone'] ?? false;
          res['googleAllowed'] = android['google'] ?? false;
        }
      }
    } catch (e) {
      print(e);
    }
  }
  return res;
}

Future<Map<String, bool>> fetchPincodeAvailability(String pincode) async {
  String url =
      "https://us-central1-raashan_merchant-firebase.cloudfunctions.net/checkPincodeAvailability?pincode=" +
          pincode;

  var response = await http.get(url);
  Map<String, dynamic> res = json.decode(response.body);
  Map<String, String> info = Map<String, String>();
  bool cash = res['cash'] ?? false;
  bool prepaid = res['prepaid'] ?? false;
  bool invalidPincode = res['invalid_pincode'] ?? true;
  bool serviceable = cash || prepaid;
  Map<String, bool> availability = Map();
  availability['cash'] = cash;
  availability['prepaid'] = prepaid;
  availability['invalidPincode'] = invalidPincode;
  availability['serviceable'] = serviceable;
  return availability;
}

String monthIntToString(int m) {
  switch (m) {
    case 1:
      return 'January';
    case 2:
      return 'February';
    case 3:
      return 'March';
    case 4:
      return 'April';
    case 5:
      return 'May';
    case 6:
      return 'June';
    case 7:
      return 'July';
    case 8:
      return 'August';
    case 9:
      return 'September';
    case 10:
      return 'October';
    case 11:
      return 'November';
    case 12:
      return 'December';
    default:
      return '';
  }
}

String toDateString(DateTime date) {
  String d = "";
  d += date.day.toString() +
      ' ' +
      monthIntToString(date.month) +
      ' ' +
      date.year.toString();
  return d;
}

String toTimeString(DateTime date) {
  String minuteString = "";
  if (date.minute < 10) {
    minuteString += '0';
  }
  minuteString += date.minute.toString();
  return date.hour.toString() + ':' + minuteString + ", " + toDateString(date);
}

bool validdateEmail(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}

bool validateMobile(String mobile, String countryCode) {
  bool res = false;
  if (mobile.length == 0) {
    res = false;
  }
  String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = RegExp(patttern);
  if (countryCode == '+91') {
    res = mobile.length == 10 && regExp.hasMatch(mobile);
  } else {
    res = regExp.hasMatch(mobile);
  }
  return res;
}

String paiseToRupeeString(int paise) {
  if (paise % 100 == 0) {
    return '\u20B9' + (paise / 100).round().toString();
  } else {
    return '\u20B9' + (paise / 100).toString();
  }
}

// bool isCartEmpty(Cart cart) {
//   return cart == null || cart.products == null || cart.products.length == 0;
// }

int _calcDiscount(int listPrice, int discount) {
  return ((discount / listPrice) * 100).round().toInt();
}

int calcDiscount(Product product) {
  return _calcDiscount(product.listPrice, product.discount);
}

String discountString(Product product) {
  return calcDiscount(product).toString() + "% OFF";
}

String discountStringGeneric(int listPrice, int discount) {
  return _calcDiscount(listPrice, discount).toString() + "% OFF";
}

int _getColorFromHex(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  return int.parse(hexColor, radix: 16);
}

String beautifyString(String str) {
  if (str.length == 0) return str;
  if (str.length == 1) return str[0].toUpperCase();
  return str[0].toUpperCase() + str.substring(1);
}

String beautifyName(String str) {
  if (str == null || str.length == 0) return "";
  List<String> n = str.split(' ');
  for (int i = 0; i < n.length; i++) {
    if (n[i] == null || n[i].length == 0) continue;
    n[i] = n[i][0].toUpperCase() + n[i].substring(1);
  }
  String nn = "";
  for (int i = 0; i < n.length; i++) {
    nn += n[i] + ' ';
  }
  return nn;
}

String getRupee() {
  return '\u20B9';
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

MaterialColor hexToMaterialColor(final String hexColor) {
  try {
    Map<int, Color> color = {
      50: HexColor(hexColor).withOpacity(0.1),
      100: HexColor(hexColor).withOpacity(0.2),
      200: HexColor(hexColor).withOpacity(0.3),
      300: HexColor(hexColor).withOpacity(0.4),
      400: HexColor(hexColor).withOpacity(0.5),
      500: HexColor(hexColor).withOpacity(0.6),
      600: HexColor(hexColor).withOpacity(0.7),
      700: HexColor(hexColor).withOpacity(0.8),
      800: HexColor(hexColor).withOpacity(0.9),
      900: HexColor(hexColor).withOpacity(1),
    };

    return MaterialColor(_getColorFromHex(hexColor), color);
  } catch (e) {
    return Colors.grey;
  }
}

MaterialColor getPrimaryColor() {
  return hexToMaterialColor('#0DAC8E');
}

MaterialColor getAccentColor() {
  return hexToMaterialColor('#2952FF');
}

String getThumbnailSizedURL(ProductAssetCombination productAssetCombination) {
  if (productAssetCombination == null) return '';
  return getAssetDownloadUrl(
      firstPreference: productAssetCombination.thumbnail,
      secondPreference: productAssetCombination.preview,
      thirdPreference: productAssetCombination.original);
}

String getPreviewSizedURL(ProductAssetCombination productAssetCombination) {
  return getAssetDownloadUrl(
      firstPreference: productAssetCombination.preview,
      secondPreference: productAssetCombination.original,
      thirdPreference: productAssetCombination.thumbnail);
}

String getOriginalSizedURL(ProductAssetCombination productAssetCombination) {
  return getAssetDownloadUrl(
      firstPreference: productAssetCombination.original,
      secondPreference: productAssetCombination.preview,
      thirdPreference: productAssetCombination.thumbnail);
}

String getAssetDownloadUrl(
    {@required ProductAsset firstPreference,
    @required ProductAsset secondPreference,
    @required ProductAsset thirdPreference}) {
  if (firstPreference != null && firstPreference.downloadURL != null) {
    return firstPreference.downloadURL;
  } else if (secondPreference != null && secondPreference.downloadURL != null) {
    return secondPreference.downloadURL;
  } else if (thirdPreference != null && thirdPreference.downloadURL != null) {
    return thirdPreference.downloadURL;
  } else
    return '';
}

void removeFocus(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);

  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

int getSingleDigitIntegerInString(String s) {
  if (s.contains('0')) return 0;
  if (s.contains('1')) return 1;
  if (s.contains('2')) return 2;
  if (s.contains('3')) return 3;
  if (s.contains('4')) return 4;
  if (s.contains('5')) return 5;
  if (s.contains('6')) return 6;
  if (s.contains('7')) return 7;
  if (s.contains('8')) return 8;
  if (s.contains('9')) return 9;
  return 0;
}

// MaterialColor getAccentColor() {
//   return hexToMaterialColor('#5AE6FF');
// }
