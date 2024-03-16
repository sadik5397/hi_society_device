import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hi_society_device/api/i18n.dart';
import 'package:hi_society_device/component/app_bar.dart';
import 'package:hi_society_device/component/button.dart';
import 'package:hi_society_device/component/card.dart';
import 'package:hi_society_device/component/page_navigation.dart';
import 'package:hi_society_device/theme/border_radius.dart';
import 'package:hi_society_device/theme/colors.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import 'package:hi_society_device/views/home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api.dart';
import '../../component/no_data.dart';
import '../../component/snack_bar.dart';

class VerifyGatePass extends StatefulWidget {
  const VerifyGatePass({Key? key, required this.gatePassCode}) : super(key: key);
  final String gatePassCode;

  @override
  State<VerifyGatePass> createState() => _VerifyGatePassState();
}

class _VerifyGatePassState extends State<VerifyGatePass> {
  //Variables
  String accessToken = "";
  dynamic apiResult;
  String? allowStatus; //should be "false" or "true"
  String? existStatus; //should be "false" or "true"
  bool isBN = false;
  bool expired = false;

  //APIs
  Future<void> verifyDigitalGatePass({required String accessToken, required String gatePassCode}) async {
    try {
      var response = await http.post(Uri.parse("$baseUrl/digital-gate-pass/guard/info?code=$gatePassCode"), headers: authHeader(accessToken));
      Map result = jsonDecode(response.body);
      print(result);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        if (kDebugMode) showSnackBar(context: context, label: result["message"]);
        setState(() => apiResult = result["data"]);
        setState(() => existStatus = (!result["data"]["expired"]).toString());
        setState(() => allowStatus = ((DateTime.parse(result["data"]['createdAt'])).isAfter(DateTime.now())) ? "true" : 'false');
        if (existStatus == "true" && allowStatus == "true") await useDigitalGatePass(accessToken: accessToken, gatePassCode: widget.gatePassCode);
      } else {
        if (DateTime.now().isBefore(DateTime.parse(result["data"]["createdAt"]).add(Duration(days: result["data"]["expiresAfter"])))) {
          showSnackBar(context: context, label: result["message"][0].toString().length == 1 ? result["message"].toString() : result["message"][0].toString());
          setState(() => existStatus = "false");
          setState(() => allowStatus = "false");
        } else {
          setState(() => expired = true);
          setState(() => existStatus = "true");
          setState(() => allowStatus = "false");
        }
      }
    } on Exception catch (e) {
      showSnackBar(context: context, label: e.toString());
    }
  }

  Future<void> useDigitalGatePass({required String accessToken, required String gatePassCode}) async {
    try {
      var response = await http.post(Uri.parse("$baseUrl/digital-gate-pass/guard/use?code=$gatePassCode"), headers: authHeader(accessToken));
      Map result = jsonDecode(response.body);
      print(result);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        if (kDebugMode) showSnackBar(context: context, label: result["message"]);
      } else {
        showSnackBar(context: context, label: result["message"][0].toString().length == 1 ? result["message"].toString() : result["message"][0].toString());
        setState(() => allowStatus = "false");
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
    await verifyDigitalGatePass(accessToken: accessToken, gatePassCode: widget.gatePassCode);
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
        appBar: primaryAppBar(context: context, title: i18n_digitalGatePass(isBN)),
        body: AnimatedContainer(
            duration: const Duration(seconds: 1),
            padding: EdgeInsets.symmetric(vertical: primaryPaddingValue * 4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: (existStatus == "true" && allowStatus == "true")
                  ? allowedColor
                  : (existStatus == "false" || allowStatus == "false")
                      ? rejectedColor
                      : Colors.transparent,
              image: const DecorationImage(image: AssetImage("assets/smart_background.png"), fit: BoxFit.cover, opacity: .2),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: (existStatus == "false" || allowStatus == "false")
                    ? <Widget>[
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.only(top: primaryPaddingValue * 2, bottom: primaryPaddingValue),
                          child: Icon(Icons.cancel_outlined, size: MediaQuery.of(context).size.height * .4),
                        )),
                        Text(i18n_sorry(isBN), style: Theme.of(context).textTheme.displayMedium?.copyWith(color: trueWhite, fontWeight: FontWeight.w300)),
                        Text(expired ? i18n_expiredGatePass(isBN) : i18n_invalidGatePass(isBN), style: Theme.of(context).textTheme.displayLarge?.copyWith(color: trueWhite, fontWeight: FontWeight.w600)),
                        SizedBox(height: primaryPaddingValue * 3),
                        SizedBox(width: MediaQuery.of(context).size.width * .75, child: primaryButton(context: context, title: i18n_tryAgain(isBN), onTap: () => routeBack(context))),
                        SizedBox(height: primaryPaddingValue),
                        SizedBox(width: MediaQuery.of(context).size.width * .75, child: primaryButton(context: context, title: i18n_goHome(isBN), onTap: () => route(context, const Home()))),
                        SizedBox(height: primaryPaddingValue * 4)
                      ]
                    : (existStatus == "true" && allowStatus == "true")
                        ? <Widget>[
                            Container(
                                margin: EdgeInsets.all(primaryPaddingValue * 2),
                                width: MediaQuery.of(context).size.height * .25,
                                height: MediaQuery.of(context).size.height * .25,
                                decoration: BoxDecoration(
                                  color: trueWhite,
                                  borderRadius: primaryBorderRadius * 2,
                                  border: Border.all(width: 2, color: trueWhite),
                                  image: apiResult["photo"] == null
                                      ? DecorationImage(fit: BoxFit.cover, image: AssetImage("assets/visitor_gate_pass.png"))
                                      : DecorationImage(fit: BoxFit.cover, image: CachedNetworkImageProvider('$baseUrl/photos/${apiResult["photo"]}')),
                                )),
                            Text(i18n_welcomeBack(isBN), style: Theme.of(context).textTheme.displayMedium?.copyWith(color: trueWhite, fontWeight: FontWeight.w300), textAlign: TextAlign.center),
                            Text(apiResult["visitorName"], style: Theme.of(context).textTheme.displayLarge?.copyWith(color: trueWhite, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: primaryPaddingValue * 2),
                                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  basic2LineInfoCard(key: i18n_flat(isBN), value: apiResult != null ? apiResult["flat"]["flatName"] : "...", context: context),
                                  basic2LineInfoCard(key: i18n_gatePass(isBN), value: apiResult != null ? apiResult["code"] : "...", context: context)
                                ])),
                            const Expanded(child: SizedBox()),
                            Padding(
                                padding: EdgeInsets.only(top: primaryPaddingValue * 4, left: primaryPaddingValue * 8, right: primaryPaddingValue * 8),
                                child: primaryButton(context: context, title: i18n_goHome(isBN), onTap: () => route(context, const Home())))
                          ]
                        : [noData()])));
  }
}
