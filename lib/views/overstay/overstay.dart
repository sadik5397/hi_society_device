import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hi_society_device/api/i18n.dart';
import 'package:hi_society_device/component/app_bar.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api.dart';
import '../../component/no_data.dart';
import '../../component/overstay_list_tile.dart';
import '../../component/snack_bar.dart';
import '../../theme/date_format.dart';

class OverstayAlerts extends StatefulWidget {
  const OverstayAlerts({Key? key}) : super(key: key);

  @override
  State<OverstayAlerts> createState() => _OverstayAlertsState();
}

class _OverstayAlertsState extends State<OverstayAlerts> {
  //Variables
  String accessToken = "";
  bool isBN = false;
  List apiResult = [];

//APIs
  Future<void> getOverstayList({required String accessToken}) async {
    try {
      var response = await http.post(Uri.parse("$baseUrl/over-stay-alert/guard/list"), headers: authHeader(accessToken));
      Map result = jsonDecode(response.body);
      print(result);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        showSnackBar(context: context, label: result["message"]);
        setState(() => apiResult = result["data"].reversed.toList());
        print(apiResult);
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
    setState(() => accessToken = pref.getString("accessToken").toString());
    setState(() => isBN = pref.getBool("isBN") ?? false);
    await getOverstayList(accessToken: accessToken);
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
        appBar: primaryAppBar(context: context, title: "${i18n_overstayAlert(isBN)}: ${primaryDate(DateTime.now().toString())}"),
        body: (apiResult.isEmpty)
            ? noData()
            : ListView.builder(
                shrinkWrap: true,
                padding: primaryPadding * 2,
                itemCount: apiResult.length,
                itemBuilder: (context, index) => overstayRequestListTile(
                      // guestOf: (index % 2 == 0) ? "S.a. Sadik" : null,
                      context: context,
                      title: apiResult[index]["user"]["name"],
                      eta: primaryTime(apiResult[index]["expectedArrival"]),
                      flat: apiResult[index]["flat"]["flatName"],
                    )));
  }
}
