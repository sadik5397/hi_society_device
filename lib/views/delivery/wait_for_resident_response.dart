import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
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
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api.dart';
import '../../component/snack_bar.dart';
import '../visitor/visitor_mobile_no_entry.dart';

class WaitForResidentResponse extends StatefulWidget {
  const WaitForResidentResponse({Key? key, this.isNew = false, required this.vendor, required this.deliveryMethod, required this.flat, required this.item, required this.flatId, required this.note})
      : super(key: key);
  final int flatId;
  final String flat;
  final String item;
  final String note;
  final bool isNew;
  final String deliveryMethod;
  final String vendor;

  @override
  State<WaitForResidentResponse> createState() => _WaitForResidentResponseState();
}

class _WaitForResidentResponseState extends State<WaitForResidentResponse> {
  //Variables
  String accessToken = "";
  dynamic apiResult;
  String residentResponse = "";
  String? allowStatus; //should be "false" or "true"
  bool timeOut = false;
  bool needEntry = false;
  TextEditingController mobileNumberController = TextEditingController();
  int checkStatusIntervalSec = 60;
  int autoRejectAfterHowManyCount = 5;
  int requestedVisitorHistoryID = 0;
  bool isBN = false;

  //APIs
  Future<void> askForPermissionToEnter({required String accessToken, required String phone, required int flatId}) async {
    try {
      var response = await http.post(Uri.parse("$baseUrl/visitor/guard/access?fid=$flatId&phone=$phone"), headers: authHeader(accessToken));
      Map result = jsonDecode(response.body);
      print(result);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        if (kDebugMode) showSnackBar(context: context, label: result["message"]);
        setState(() => apiResult = result["data"]);
        setState(() => requestedVisitorHistoryID = result["data"]["visitorHistoryId"]);
      } else {
        showSnackBar(context: context, label: result["message"][0].toString().length == 1 ? result["message"].toString() : result["message"][0].toString());
      }
    } on Exception catch (e) {
      showSnackBar(context: context, label: e.toString());
    }
  }

  Future<void> createPPL({required String deliveryMethod, required String accessToken, required String itemType, required String merchant, required int flatId, required VoidCallback successRoute}) async {
    try {
      var response = await http.post(Uri.parse("$baseUrl/parcel-delivery/guard/create"),
          headers: authHeader(accessToken), body: jsonEncode({"flatId": flatId, "vendor": merchant, "deliveryMethod": deliveryMethod, "item": itemType}));
      Map result = jsonDecode(response.body);
      print(result);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        if (kDebugMode) showSnackBar(context: context, label: result["message"]);
        print(result);
        successRoute.call();
      } else {
        showSnackBar(context: context, label: result["message"][0].toString().length == 1 ? result["message"].toString() : result["message"][0].toString());
      }
    } on Exception catch (e) {
      showSnackBar(context: context, label: e.toString());
    }
  }

  Future<void> timer() async {
    for (int i = 0; i < autoRejectAfterHowManyCount; i++) {
      if (allowStatus == null) {
        await Future.delayed(Duration(seconds: checkStatusIntervalSec));
      }
    }
    if (allowStatus == null) setState(() => timeOut = true);
  }

  checkInPaid() {
    if (widget.deliveryMethod == "drop_at_guard") setState(() => allowStatus = "true");
  }

//Functions
  defaultInit() async {
    final pref = await SharedPreferences.getInstance();
    setState(() => accessToken = pref.getString("accessToken").toString());
    setState(() => isBN = pref.getBool("isBN") ?? false);
    checkInPaid();
    initiateRealtimeStatusChecker();
    await timer();
  }

  initiateRealtimeStatusChecker() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // RemoteNotification? notification = message.notification;
      // AndroidNotification? android = message.notification?.android;

      print("Got a New Notification: ${message.data["title"]}\n${message.data["body"]}");
      if (message.data["topic"] == "parcel-delivery") setState(() => residentResponse = message.data["response"]);
      if (message.data["response"] == "drop at guard" || message.data["response"] == "come to door" || message.data["response"] == "coming to receive") {
        setState(() => allowStatus = "true");
      }
      if (message.data["response"] == "cant receive now") setState(() => allowStatus = "false");
      if (message.data["response"] == "come to door") setState(() => needEntry = true);
    });
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
        appBar: primaryAppBar(context: context),
        body: AnimatedContainer(
            duration: const Duration(seconds: 1),
            padding: EdgeInsets.symmetric(vertical: primaryPaddingValue * 4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: allowStatus == "true"
                  ? allowedColor
                  : allowStatus == "false" || timeOut == true
                      ? rejectedColor
                      : Colors.transparent,
              image: const DecorationImage(image: AssetImage("assets/smart_background.png"), fit: BoxFit.cover, opacity: .4),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Container(
                  padding: primaryPadding * 2,
                  margin: EdgeInsets.only(bottom: primaryPaddingValue),
                  width: (allowStatus == "true") ? MediaQuery.of(context).size.height * .25 : MediaQuery.of(context).size.height * .15,
                  height: (allowStatus == "true") ? MediaQuery.of(context).size.height * .25 : MediaQuery.of(context).size.height * .15,
                  decoration: BoxDecoration(color: trueWhite, borderRadius: primaryBorderRadius * 2, border: Border.all(width: 2, color: trueWhite)),
                  child: Image.asset("assets/parcel.png", fit: BoxFit.cover)),
              if (allowStatus == "true") const Expanded(child: SizedBox()),
              if (allowStatus == "true" && widget.deliveryMethod != "drop_at_guard") Text(i18n_residentsResponse(isBN), style: TextStyle(fontSize: 22)),
              if (allowStatus == "true" && widget.deliveryMethod != "drop_at_guard")
                Text(residentResponse.toUpperCase(), style: Theme.of(context).textTheme.displayMedium?.copyWith(color: trueWhite, fontWeight: FontWeight.w300)),
              if (widget.deliveryMethod == "drop_at_guard") Text(i18n_parcelRcvd(isBN), style: Theme.of(context).textTheme.displayMedium?.copyWith(color: trueWhite, fontWeight: FontWeight.w300)),
              Text(widget.item.toString(), style: Theme.of(context).textTheme.displayLarge?.copyWith(color: trueWhite, fontWeight: FontWeight.w600)),
              if (allowStatus == "true") const Expanded(child: SizedBox()),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: primaryPaddingValue),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [basic2LineInfoCard(key: i18n_flat(isBN), value: widget.flat, context: context), basic2LineInfoCard(key: i18n_merchant(isBN), value: widget.vendor, context: context)])),
              if (allowStatus == null && !timeOut)
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(top: primaryPaddingValue * 2, bottom: primaryPaddingValue),
                        decoration: BoxDecoration(color: trueWhite, borderRadius: primaryBorderRadius),
                        child: Lottie.network("https://assets1.lottiefiles.com/packages/lf20_ntbhn8nr.json"))),
              if (timeOut) Expanded(child: Center(child: Text(i18n_timeOut(isBN), style: Theme.of(context).textTheme.displayLarge?.copyWith(color: trueWhite)))),
              if (allowStatus == "false")
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(top: primaryPaddingValue * 2, bottom: primaryPaddingValue),
                  child: Icon(Icons.cancel_outlined, size: MediaQuery.of(context).size.height * .25),
                )),
              if (allowStatus == null && !timeOut) Text("${i18n_pleaseWait(isBN)}...", textScaleFactor: .75, style: Theme.of(context).textTheme.displaySmall?.copyWith(color: trueWhite)),
              if (allowStatus == "false") Text(i18n_cantRcv(isBN), textScaleFactor: .75, style: Theme.of(context).textTheme.displaySmall?.copyWith(color: trueWhite)),
              needEntry
                  ? Padding(
                      padding: EdgeInsets.only(top: primaryPaddingValue * 4, left: primaryPaddingValue * 8, right: primaryPaddingValue * 8),
                      child: primaryButton(context: context, title: i18n_takeInfo(isBN), onTap: () => route(context, VisitorMobileNoEntry())))
                  : Padding(
                      padding: EdgeInsets.only(top: primaryPaddingValue * 4, left: primaryPaddingValue * 8, right: primaryPaddingValue * 8),
                      child: primaryButton(context: context, title: (allowStatus == null && !timeOut) ? i18n_cancel(isBN) : i18n_goHome(isBN), onTap: () => route(context, const Home()))),
              if (allowStatus == "true" && widget.deliveryMethod != "drop_at_guard")
                Padding(
                    padding: EdgeInsets.only(top: primaryPaddingValue, left: primaryPaddingValue * 8, right: primaryPaddingValue * 8),
                    child: primaryButton(
                        primary: false,
                        context: context,
                        title: i18n_receiveNGenerate(isBN),
                        onTap: () async => await createPPL(
                            deliveryMethod: "drop_at_guard",
                            accessToken: accessToken,
                            itemType: '${widget.item} || ${widget.note}',
                            merchant: widget.vendor,
                            flatId: widget.flatId,
                            successRoute: () => route(
                                context,
                                WaitForResidentResponse(
                                    note: widget.note, flatId: widget.flatId, vendor: widget.vendor, deliveryMethod: "drop_at_guard", flat: widget.flat, item: widget.item)))))
            ])));
  }
}
