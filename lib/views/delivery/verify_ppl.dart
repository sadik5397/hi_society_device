import 'dart:convert';

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
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api.dart';
import '../../component/snack_bar.dart';

class VerifyPPL extends StatefulWidget {
  const VerifyPPL({Key? key, required this.gatePassCode}) : super(key: key);
  final String gatePassCode;

  @override
  State<VerifyPPL> createState() => _VerifyPPLState();
}

class _VerifyPPLState extends State<VerifyPPL> {
  //Variables
  String accessToken = "";
  dynamic apiResult;
  bool isBN = false;
  String? allowStatus; //should be "false" or "true"

  //APIs
  Future<void> verifyPPL({required String accessToken, required String gatePassCode}) async {
    try {
      var response = await http.post(Uri.parse("$baseUrl/parcel-delivery/guard/find-by-otp?otp=$gatePassCode"), headers: authHeader(accessToken));
      Map result = jsonDecode(response.body);
      print(result);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        if (kDebugMode) showSnackBar(context: context, label: result["message"]);
        setState(() => apiResult = result["data"]);
        (apiResult["otpUsedAt"] == null) ? setState(() => allowStatus = "true") : setState(() => allowStatus = "false");
        if (allowStatus == "true") await usePPL(accessToken: accessToken, gatePassCode: widget.gatePassCode);
      } else {
        showSnackBar(context: context, label: result["message"][0].toString().length == 1 ? result["message"].toString() : result["message"][0].toString());
        setState(() => allowStatus = "false");
      }
    } on Exception catch (e) {
      showSnackBar(context: context, label: e.toString());
    }
  }

  Future<void> usePPL({required String accessToken, required String gatePassCode}) async {
    try {
      var response = await http.post(Uri.parse("$baseUrl/parcel-delivery/guard/approve-by-otp?otp=$gatePassCode"), headers: authHeader(accessToken));
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
    await verifyPPL(accessToken: accessToken, gatePassCode: widget.gatePassCode);
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
        appBar: primaryAppBar(context: context, title: i18n_dsbParcel(isBN)),
        body: AnimatedContainer(
            duration: const Duration(seconds: 1),
            padding: EdgeInsets.symmetric(vertical: primaryPaddingValue * 4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: allowStatus == "true"
                  ? allowedColor
                  : allowStatus == "false"
                      ? rejectedColor
                      : Colors.transparent,
              image: const DecorationImage(image: AssetImage("assets/smart_background.png"), fit: BoxFit.cover, opacity: .2),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: (allowStatus == "false")
                    ? <Widget>[
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.only(top: primaryPaddingValue * 2, bottom: primaryPaddingValue),
                          child: Icon(Icons.cancel_outlined, size: MediaQuery.of(context).size.height * .4),
                        )),
                        Text(i18n_weNoFound(isBN), style: Theme.of(context).textTheme.displayMedium?.copyWith(color: trueWhite, fontWeight: FontWeight.w300)),
                        Text(i18n_parcel(isBN), style: Theme.of(context).textTheme.displayLarge?.copyWith(color: trueWhite, fontWeight: FontWeight.w600)),
                        SizedBox(height: primaryPaddingValue * 3),
                        SizedBox(width: MediaQuery.of(context).size.width * .75, child: primaryButton(context: context, title: i18n_tryAgain(isBN), onTap: () => routeBack(context))),
                        SizedBox(height: primaryPaddingValue),
                        SizedBox(width: MediaQuery.of(context).size.width * .75, child: primaryButton(context: context, title: i18n_goHome(isBN), onTap: () => route(context, const Home()))),
                        SizedBox(height: primaryPaddingValue * 4)
                      ]
                    : (allowStatus == "true")
                        ? <Widget>[
                            Container(
                                margin: EdgeInsets.all(primaryPaddingValue * 2),
                                width: MediaQuery.of(context).size.height * .25,
                                height: MediaQuery.of(context).size.height * .25,
                                decoration: BoxDecoration(
                                    color: trueWhite,
                                    borderRadius: primaryBorderRadius * 2,
                                    border: Border.all(width: 2, color: trueWhite),
                                    image: const DecorationImage(fit: BoxFit.cover, image: AssetImage("assets/parcel.png")))),
                            Text(i18n_weFound(isBN), style: Theme.of(context).textTheme.displayMedium?.copyWith(color: trueWhite, fontWeight: FontWeight.w300)),
                            Text(i18n_parcel(isBN), style: Theme.of(context).textTheme.displayLarge?.copyWith(color: trueWhite, fontWeight: FontWeight.w600)),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: primaryPaddingValue * 2),
                                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  basic2LineInfoCard(is3: true, key: i18n_flat(isBN), value: apiResult != null ? apiResult["flat"]["flatName"] : "...", context: context),
                                  basic2LineInfoCard(is3: true, key: i18n_merchant(isBN), value: apiResult != null ? apiResult["vendor"] : "...", context: context),
                                  basic2LineInfoCard(is3: true, key: i18n_arrivedAt(isBN), value: apiResult != null ? DateFormat.jm().format(DateTime.parse(apiResult["createdAt"])) : "...", context: context)
                                ])),
                            const Expanded(child: SizedBox()),
                            Padding(
                                padding: EdgeInsets.only(top: primaryPaddingValue * 4, left: primaryPaddingValue * 8, right: primaryPaddingValue * 8),
                                child: primaryButton(context: context, title: i18n_goHome(isBN), onTap: () => route(context, const Home())))
                          ]
                        : [Center(child: CircularProgressIndicator(color: trueWhite))])));
  }
}
