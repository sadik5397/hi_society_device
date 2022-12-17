import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hi_society_device/api/i18n.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api.dart';
import '../../component/app_bar.dart';
import '../../component/snack_bar.dart';
import '../../theme/colors.dart';
import '../../theme/padding_margin.dart';

class AssignFlatResident extends StatefulWidget {
  const AssignFlatResident({Key? key, required this.flatID, required this.flatNo}) : super(key: key);
  final String flatNo;
  final int flatID;

  @override
  State<AssignFlatResident> createState() => _AssignFlatResidentState();
}

class _AssignFlatResidentState extends State<AssignFlatResident> {
  String accessToken = "";
  Map apiResult = {};
  bool isBN = false;

//APIs
  Future<void> getQrCodeToAssignResidentHeadToFlat({required String accessToken, required int flatID}) async {
    try {
      var response = await http.post(Uri.parse("$baseUrl/building/assign/flat/code?fid=$flatID"), headers: authHeader(accessToken));
      Map result = jsonDecode(response.body);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        if (kDebugMode) showSnackBar(context: context, label: result["message"]);
        setState(() => apiResult = result["data"]);
      } else {
        showSnackBar(context: context, label: result["message"][0].toString().length == 1 ? result["message"].toString() : result["message"][0].toString());
      }
    } on Exception catch (e) {
      showSnackBar(context: context, label: e.toString());
    }
  }

//Functions
  defaultInit() async {
    final pref = await SharedPreferences.getInstance();
    setState(() => accessToken = pref.getString("accessToken")!);
    setState(() => isBN = pref.getBool("isBN") ?? false);
    getQrCodeToAssignResidentHeadToFlat(accessToken: accessToken, flatID: widget.flatID);
  }

//Initiate
  @override
  void initState() {
    super.initState();
    defaultInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: primaryAppBar(context: context, title: "${i18n_assigningResident(isBN)} ${widget.flatNo}"),
        body: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              flex: 2,
              child: Padding(
                  padding: EdgeInsets.only(top: primaryPaddingValue * 2),
                  child: Center(
                      child: apiResult.isEmpty
                          ? Image.asset("assets/icon/icon_only.png")
                          : QrImage(data: apiResult["code"]!, version: QrVersions.auto, size: 450, padding: EdgeInsets.all(primaryPaddingValue * 2), backgroundColor: trueWhite)))),
          Expanded(
              flex: 1,
              child: Container(
                  padding: EdgeInsets.only(bottom: primaryPaddingValue * 4),
                  alignment: Alignment.center,
                  color: primaryColor,
                  child: FittedBox(
                      child: SelectableText(apiResult["code"] ?? i18n_wait(isBN), style: Theme.of(context).textTheme.displayLarge?.copyWith(color: trueWhite, fontWeight: FontWeight.bold, fontSize: 150)))))
        ]));
  }
}
