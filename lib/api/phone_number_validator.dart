import 'package:flutter/foundation.dart';
import 'package:phone_number/phone_number.dart';

Future<bool> validatePhoneNumber(String phoneNumber) async {
  RegionInfo region = const RegionInfo(name: "Bangladesh", code: "BD", prefix: 880);
  try {
    bool isValid = await PhoneNumberUtil().validate(phoneNumber, regionCode: region.code);
    return isValid;
  } on Exception catch (e) {
    if (kDebugMode) print(e.toString());
    return false;
  }
}
