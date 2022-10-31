import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../component/app_bar.dart';
import '../../theme/colors.dart';
import '../../theme/padding_margin.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api.dart';
import '../../component/snack_bar.dart';

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

//APIs
  Future<void> getQrCodeToAssignResidentHeadToFlat({required String accessToken, required int flatID}) async {
    try {
      var response = await http.post(Uri.parse("$baseUrl/building/assign/flat/code?fid=$flatID"), headers: authHeader(accessToken));
      Map result = jsonDecode(response.body);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        showSnackBar(context: context, label: result["message"]);
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
        appBar: primaryAppBar(context: context, title: "Assigning Resident to Flat ${widget.flatNo}"),
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
                  child: SelectableText(apiResult["code"] ?? "WAIT", style: Theme.of(context).textTheme.displayLarge?.copyWith(color: trueWhite, fontWeight: FontWeight.bold, fontSize: 150))))
        ]));
  }
}
