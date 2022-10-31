import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hi_society_device/component/app_bar.dart';
import 'package:hi_society_device/component/button.dart';
import 'package:hi_society_device/component/card.dart';
import 'package:hi_society_device/component/page_navigation.dart';
import 'package:hi_society_device/theme/border_radius.dart';
import 'package:hi_society_device/theme/colors.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import 'package:hi_society_device/views/home.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../api/api.dart';
import '../../component/snack_bar.dart';
import '../../theme/placeholder.dart';

class AskPermissionToEnter extends StatefulWidget {
  const AskPermissionToEnter({Key? key, required this.visitorData, required this.flatID, required this.mobileNumber}) : super(key: key);
  final int flatID;
  final String mobileNumber;
  final dynamic visitorData;

  @override
  State<AskPermissionToEnter> createState() => _AskPermissionToEnterState();
}

class _AskPermissionToEnterState extends State<AskPermissionToEnter> {
  //Variables
  String accessToken = "";
  dynamic apiResult;
  dynamic permissionResult;
  String allowStatus = ""; //should be "false" or "true"
  TextEditingController mobileNumberController = TextEditingController();

  //APIs
  Future<void> askForPermissionToEnter({required String accessToken, required String phone, required int flatId}) async {
    try {
      var response = await http.post(Uri.parse("$baseUrl/visitor/guard/access?fid=$flatId&phone=$phone"), headers: authHeader(accessToken));
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
    await visitorPermissionStatus(accessToken: accessToken, visitorHistoryId: 26);
  }

  Future<void> visitorPermissionStatus({required String accessToken, required int visitorHistoryId}) async {
    for (int i = 0; i < 10; i++) {
      await Future.delayed(const Duration(seconds: 10));
      print("Attempt: ${i + 1}");
      try {
        var response = await http.post(Uri.parse("$baseUrl/visitor/status?vhid=$visitorHistoryId"), headers: authHeader(accessToken));
        Map result = jsonDecode(response.body);
        print(result);
        if (result["statusCode"] == 200 || result["statusCode"] == 201) {
          showSnackBar(context: context, label: result["message"]);
          setState(() => permissionResult = result["data"]);
          setState(() => allowStatus = result["data"]["allowed"].toString());
          setState(() => allowStatus = true.toString());
        } else {
          showSnackBar(context: context, label: result["message"][0].toString().length == 1 ? result["message"].toString() : result["message"][0].toString());
        }
      } on Exception catch (e) {
        showSnackBar(context: context, label: e.toString());
      }
    }
  }

//Functions
  defaultInit() async {
    final pref = await SharedPreferences.getInstance();
    setState(() => accessToken = pref.getString("accessToken").toString());
    await askForPermissionToEnter(accessToken: accessToken, phone: widget.mobileNumber, flatId: widget.flatID);
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
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                              widget.visitorData["photo"] != null ? "$baseUrl/photos/${widget.visitorData["photo"]}" : placeholderImage)))),
              if (allowStatus == "true") const Expanded(child: SizedBox()),
              if (allowStatus == "true")
                Text("Welcome Back", style: Theme.of(context).textTheme.displayMedium?.copyWith(color: trueWhite, fontWeight: FontWeight.w300)),
              Text(widget.visitorData["name"].toString(),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(color: trueWhite, fontWeight: FontWeight.w600)),
              if (allowStatus == "true") const Expanded(child: SizedBox()),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: primaryPaddingValue),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    basic2LineInfoCard(key: "Flat", value: apiResult != null ? apiResult["flat"]["flatName"] : "...", context: context),
                    basic2LineInfoCard(key: "Purpose", value: apiResult != null ? apiResult["visitor"]["relation"] : "...", context: context)
                  ])),
              if (allowStatus == "true")
                Padding(
                    padding: EdgeInsets.symmetric(vertical: primaryPaddingValue),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      basic2LineInfoCard(key: "Current Time", value: apiResult != null ? DateFormat.ABBR_STANDALONE_MONTH : "...", context: context),
                      basic2LineInfoCard(key: "Last Visited", value: apiResult != null ? DateFormat.ABBR_STANDALONE_MONTH : "...", context: context)
                    ])),
              if (allowStatus == "")
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
              if (allowStatus == "") Text("Please Wait...", textScaleFactor: .75, style: Theme.of(context).textTheme.displaySmall?.copyWith(color: trueWhite)),
              if (allowStatus == "false")
                Text("PERMISSION DECLINED", textScaleFactor: .75, style: Theme.of(context).textTheme.displaySmall?.copyWith(color: trueWhite)),
              Padding(
                  padding: EdgeInsets.only(top: primaryPaddingValue * 4, left: primaryPaddingValue * 8, right: primaryPaddingValue * 8),
                  child:
                      primaryButton(context: context, title: (allowStatus == "") ? "Cancel" : "Go to Main Screen", onTap: () => route(context, const Home())))
            ])));
  }
}
