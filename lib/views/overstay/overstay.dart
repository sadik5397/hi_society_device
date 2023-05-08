import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hi_society_device/api/i18n.dart';
import 'package:hi_society_device/component/app_bar.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import 'package:hi_society_device/theme/placeholder.dart';
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
  List allResult = [];
  List apiResultToday = [];
  List apiResultTomorrow = [];
  List apiResultNextDayOfTomorrow = [];

//APIs
  Future<void> getOverstayList({required String accessToken}) async {
    try {
      var response = await http.post(Uri.parse("$baseUrl/over-stay-alert/guard/list"), headers: authHeader(accessToken));
      Map result = jsonDecode(response.body);
      print(result);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        if (kDebugMode) showSnackBar(context: context, label: result["message"]);
        setState(() => allResult = result["data"].reversed.toList());
        for (int i = 0; i < allResult.length; i++) {
          if (allResult[i]["expectedArrival"].toString().split("T")[0] == apiDate(DateTime.now().toString())) setState(() => apiResultToday.add(allResult[i]));
          if (allResult[i]["expectedArrival"].toString().split("T")[0] == apiDate((DateTime.now().add(Duration(days: 1))).toString())) setState(() => apiResultTomorrow.add(allResult[i]));
          if (allResult[i]["expectedArrival"].toString().split("T")[0] == apiDate((DateTime.now().add(Duration(days: 2))).toString())) setState(() => apiResultNextDayOfTomorrow.add(allResult[i]));
        }
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
        appBar: primaryAppBar(context: context, title: i18n_overstayAlert(isBN)),
        body: (allResult.isEmpty)
            ? noData()
            : ListView(children: [
                if (apiResultToday.isNotEmpty)
                  Padding(
                      padding: (primaryPadding * 2).copyWith(bottom: 0),
                      child: Text("${i18n_today(isBN)} (${primaryDate((DateTime.now().add(Duration(days: 0))).toString())})", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
                ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    padding: (primaryPadding * 2).copyWith(top: primaryPaddingValue, bottom: 0),
                    itemCount: apiResultToday.length,
                    itemBuilder: (context, index) => overstayRequestListTile(
                          isBN: isBN,
                          context: context,
                          photo: apiResultToday[index]["user"]["photo"] == null ? placeholderImage : '$baseUrl/photos/${apiResultToday[index]["user"]["photo"]}',
                          title: apiResultToday[index]["user"]["name"],
                          eta: primaryTime(apiResultToday[index]["expectedArrival"]),
                          flat: apiResultToday[index]["flat"]["flatName"],
                        )),
                if (apiResultTomorrow.isNotEmpty)
                  Padding(
                      padding: (primaryPadding * 2).copyWith(bottom: 0),
                      child: Text("${i18n_tomorrow(isBN)} (${primaryDate((DateTime.now().add(Duration(days: 1))).toString())})", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
                ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    padding: (primaryPadding * 2).copyWith(top: primaryPaddingValue, bottom: 0),
                    itemCount: apiResultTomorrow.length,
                    itemBuilder: (context, index) => overstayRequestListTile(
                          isBN: isBN,
                          context: context,
                          photo: apiResultTomorrow[index]["user"]["photo"] == null ? placeholderImage : '$baseUrl/photos/${apiResultTomorrow[index]["user"]["photo"]}',
                          title: apiResultTomorrow[index]["user"]["name"],
                          eta: primaryTime(apiResultTomorrow[index]["expectedArrival"]),
                          flat: apiResultTomorrow[index]["flat"]["flatName"],
                        )),
                if (apiResultNextDayOfTomorrow.isNotEmpty)
                  Padding(
                      padding: (primaryPadding * 2).copyWith(bottom: 0),
                      child: Text("${i18n_nextDay(isBN)} (${primaryDate((DateTime.now().add(Duration(days: 2))).toString())})", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
                ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    padding: (primaryPadding * 2).copyWith(top: primaryPaddingValue, bottom: 0),
                    itemCount: apiResultNextDayOfTomorrow.length,
                    itemBuilder: (context, index) => overstayRequestListTile(
                          isBN: isBN,
                          context: context,
                          photo: apiResultNextDayOfTomorrow[index]["user"]["photo"] == null ? placeholderImage : '$baseUrl/photos/${apiResultNextDayOfTomorrow[index]["user"]["photo"]}',
                          title: apiResultNextDayOfTomorrow[index]["user"]["name"],
                          eta: primaryTime(apiResultNextDayOfTomorrow[index]["expectedArrival"]),
                          flat: apiResultNextDayOfTomorrow[index]["flat"]["flatName"],
                        ))
              ]));
  }
}
