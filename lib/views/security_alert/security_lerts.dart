import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hi_society_device/api/i18n.dart';
import 'package:hi_society_device/component/app_bar.dart';
import 'package:hi_society_device/component/page_navigation.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/api.dart';
import '../../component/alert_grid_tile.dart';
import '../../component/snack_bar.dart';
import 'security_alert_screen.dart';

class SecurityAlertList extends StatefulWidget {
  const SecurityAlertList({Key? key}) : super(key: key);

  @override
  State<SecurityAlertList> createState() => _SecurityAlertListState();
}

class _SecurityAlertListState extends State<SecurityAlertList> {
  //variable
  TextEditingController searchController = TextEditingController();
  String accessToken = "";
  bool isBN = false;
  List alerts = [];

  //API
  Future<void> readAlertTypes({required String accessToken}) async {
    try {
      var response = await http.post(Uri.parse("$baseUrl/security-alert/alert-type/list"), headers: authHeader(accessToken));
      Map result = jsonDecode(response.body);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        if (kDebugMode) showSnackBar(context: context, label: result["message"]);
        setState(() => alerts = result["data"]);
      } else {
        showError(context: context, label: result["message"][0].toString().length == 1 ? result["message"].toString() : result["message"][0].toString());
      }
    } on Exception catch (e) {
      showError(context: context, label: e.toString());
    }
  }

  Future<void> createSecurityAlert({required String accessToken, required String alert, required int alertId}) async {
    try {
      print("$baseUrl/security-alert/guard/alert/create");
      print(jsonEncode({"alertId": alertId}));
      var response = await http.post(Uri.parse("$baseUrl/security-alert/guard/alert/create"), headers: authHeader(accessToken), body: jsonEncode({"alertId": alertId}));
      Map result = jsonDecode(response.body);
      print(result);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        if (kDebugMode) showSnackBar(context: context, label: result["message"]);
      } else {
        showError(context: context, label: result["message"][0].toString().length == 1 ? result["message"].toString() : result["message"][0].toString());
      }
    } on Exception catch (e) {
      showError(context: context, label: e.toString());
    }
  }

  //Functions
  defaultInit() async {
    final pref = await SharedPreferences.getInstance();
    setState(() => accessToken = pref.getString("accessToken").toString());
    setState(() => isBN = pref.getBool("isBN") ?? false);
    await readAlertTypes(accessToken: accessToken);
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
        appBar: primaryAppBar(context: context, title: i18n_securityAlert(isBN)),
        body: GridView.builder(
            padding: primaryPadding * 2,
            itemCount: alerts.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: primaryPaddingValue * 2, crossAxisSpacing: primaryPaddingValue * 2),
            itemBuilder: (context, index) => alertGridTile(
                context: context,
                onTap: () => showPrompt(
                    context: context,
                    label: "All Manager and residents Will get notified!",
                    onTap: () async {
                      routeBack(context);
                      showSnackBar(context: context, label: "Alert Pushed to Hi Society Server");
                      route(context, SecurityAlertScreen(alert: alerts[index]["alertName"]));
                      await createSecurityAlert(accessToken: accessToken, alert: alerts[index]["alertName"], alertId: alerts[index]["securityAlertId"]);
                    }),
                label: alerts[index]["alertName"])));
  }
}
