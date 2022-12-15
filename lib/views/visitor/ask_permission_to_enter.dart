import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hi_society_device/api/i18n.dart';
import 'package:hi_society_device/component/app_bar.dart';
import 'package:hi_society_device/component/button.dart';
import 'package:hi_society_device/component/card.dart';
import 'package:hi_society_device/component/page_navigation.dart';
import 'package:hi_society_device/theme/border_radius.dart';
import 'package:hi_society_device/theme/colors.dart';
import 'package:hi_society_device/theme/date_format.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import 'package:hi_society_device/views/home.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api.dart';
import '../../component/snack_bar.dart';

class AskPermissionToEnter extends StatefulWidget {
  const AskPermissionToEnter({Key? key, this.isNew = false, required this.visitorName, required this.visitorPhoto, required this.flatID, required this.mobileNumber}) : super(key: key);
  final int flatID;
  final String mobileNumber;
  final bool isNew;
  final String visitorPhoto;
  final String visitorName;

  @override
  State<AskPermissionToEnter> createState() => _AskPermissionToEnterState();
}

class _AskPermissionToEnterState extends State<AskPermissionToEnter> {
  //Variables
  String accessToken = "";
  dynamic apiResult;
  dynamic permissionResult;
  String? allowStatus; //should be "false" or "true"
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
        showSnackBar(context: context, label: result["message"]);
        setState(() => apiResult = result["data"]);
        setState(() => requestedVisitorHistoryID = result["data"]["visitorHistoryId"]);
      } else {
        showSnackBar(context: context, label: result["message"][0].toString().length == 1 ? result["message"].toString() : result["message"][0].toString());
      }
    } on Exception catch (e) {
      showSnackBar(context: context, label: e.toString());
    }
  }

  Future<void> visitorPermissionStatus({required String accessToken, required int visitorHistoryId}) async {
    print("visitorPermissionStatus $allowStatus");
    for (int i = 0; i < autoRejectAfterHowManyCount; i++) {
      print("for loop $allowStatus");
      print("Attempt: ${i + 1}");
      if (allowStatus == null) {
        print("allowStatus == null $allowStatus");
        await Future.delayed(Duration(seconds: checkStatusIntervalSec));
        print("Future.delayed $allowStatus");
        try {
          var response = await http.post(Uri.parse("$baseUrl/visitor/status?vhid=$visitorHistoryId"), headers: authHeader(accessToken));
          Map result = jsonDecode(response.body);
          print("http.post response recvd $allowStatus");
          if (result["statusCode"] == 200 || result["statusCode"] == 201) {
            print("statusCode = 200 $allowStatus");
            if (result["data"]["allowed"] != null) setState(() => allowStatus = result["data"]["allowed"].toString());
            print("allowStatus seted to $allowStatus");
          } else {
            showSnackBar(context: context, label: result["message"][0].toString().length == 1 ? result["message"].toString() : result["message"][0].toString());
          }
        } on Exception catch (e) {
          showSnackBar(context: context, label: e.toString());
        }
      }
      print("loop ${i + 1} Shesh $allowStatus");
    }
    print("for loop Shesh $allowStatus");
    print("loop Shesh howar por allowstatus $allowStatus");
    if (allowStatus == null) setState(() => allowStatus = "false");
    print("ekhno null thakle forcely change kore dilam allowstatus = $allowStatus");
  }

//Functions
  defaultInit() async {
    initiateRealtimeStatusChecker();
    final pref = await SharedPreferences.getInstance();
    setState(() => accessToken = pref.getString("accessToken").toString());
    setState(() => isBN = pref.getBool("isBN") ?? false);
    await askForPermissionToEnter(accessToken: accessToken, phone: widget.mobileNumber, flatId: widget.flatID);
    await Future.delayed(const Duration(seconds: 5));
    await visitorPermissionStatus(accessToken: accessToken, visitorHistoryId: requestedVisitorHistoryID);
  }

  initiateRealtimeStatusChecker() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        print("Got a New Notification: ${notification.title}\n${message.data}");
        if (message.data["topic"] == "visitor" && message.data["visitorId"] == apiResult["visitor"]["visitorId"].toString() && notification.title == "Visitor approved") setState(() => allowStatus = "true");
        if (message.data["topic"] == "visitor" && message.data["visitorId"] == apiResult["visitor"]["visitorId"].toString() && notification.title == "Visitor denied") setState(() => allowStatus = "false");
      }
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
                  : allowStatus == "false"
                      ? rejectedColor
                      : Colors.transparent,
              image: const DecorationImage(image: AssetImage("assets/smart_background.png"), fit: BoxFit.cover, opacity: .4),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Container(
                  margin: EdgeInsets.only(bottom: primaryPaddingValue),
                  width: (allowStatus == "true") ? MediaQuery.of(context).size.height * .25 : MediaQuery.of(context).size.height * .15,
                  height: (allowStatus == "true") ? MediaQuery.of(context).size.height * .25 : MediaQuery.of(context).size.height * .15,
                  decoration: BoxDecoration(
                      borderRadius: primaryBorderRadius * 2,
                      border: Border.all(width: 2, color: trueWhite),
                      image: DecorationImage(
                          fit: BoxFit.cover, image: widget.isNew ? Image.memory(base64Decode(widget.visitorPhoto)).image : CachedNetworkImageProvider("$baseUrl/photos/${widget.visitorPhoto}")))),
              if (allowStatus == "true") const Expanded(child: SizedBox()),
              if (allowStatus == "true") Text(i18n_welcomeBack(isBN), style: Theme.of(context).textTheme.displayMedium?.copyWith(color: trueWhite, fontWeight: FontWeight.w300), textAlign: TextAlign.center),
              Text(widget.visitorName.toString(), style: Theme.of(context).textTheme.displayLarge?.copyWith(color: trueWhite, fontWeight: FontWeight.w600)),
              if (allowStatus == "true") const Expanded(child: SizedBox()),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: primaryPaddingValue),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    basic2LineInfoCard(key: i18n_flat(isBN), value: apiResult != null ? apiResult["flat"]["flatName"] : "...", context: context),
                    basic2LineInfoCard(key: i18n_purpose(isBN), value: apiResult != null ? apiResult["visitor"]["relation"] : "...", context: context)
                  ])),
              if (allowStatus == "true")
                Padding(
                    padding: EdgeInsets.symmetric(vertical: primaryPaddingValue),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      basic2LineInfoCard(key: i18n_date(isBN), value: apiResult != null ? primaryDate(DateTime.now().toString()) : "...", context: context),
                      basic2LineInfoCard(key: i18n_time(isBN), value: apiResult != null ? primaryTime(DateTime.now().toString()) : "...", context: context)
                    ])),
              if (allowStatus == null)
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(top: primaryPaddingValue * 2, bottom: primaryPaddingValue),
                        decoration: BoxDecoration(color: trueWhite, borderRadius: primaryBorderRadius),
                        child: Lottie.network("https://assets1.lottiefiles.com/packages/lf20_ntbhn8nr.json"))),
              if (allowStatus == "false")
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(top: primaryPaddingValue * 2, bottom: primaryPaddingValue),
                  child: Icon(Icons.cancel_outlined, size: MediaQuery.of(context).size.height * .25),
                )),
              if (allowStatus == null) Text("${i18n_pleaseWait(isBN)}...", textScaleFactor: .75, style: Theme.of(context).textTheme.displaySmall?.copyWith(color: trueWhite)),
              if (allowStatus == "false") Text(i18n_permissionDeclined(isBN), textScaleFactor: .75, style: Theme.of(context).textTheme.displaySmall?.copyWith(color: trueWhite)),
              Padding(
                  padding: EdgeInsets.only(top: primaryPaddingValue * 4, left: primaryPaddingValue * 8, right: primaryPaddingValue * 8),
                  child: primaryButton(context: context, title: (allowStatus == null) ? i18n_cancel(isBN) : i18n_goHome(isBN), onTap: () => route(context, const Home())))
            ])));
  }
}
