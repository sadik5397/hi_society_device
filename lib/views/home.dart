import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hi_society_device/theme/placeholder.dart';
import 'package:hi_society_device/views/gate_pass/visitor_gate_pas_code_entry.dart';
import 'package:hi_society_device/views/residents/building_residents.dart';
import 'package:hi_society_device/views/visitor/visitor_mobile_no_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api.dart';
import '../component/app_bar.dart';
import '../component/header_building_image.dart';
import '../component/menu_grid_tile.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../component/page_navigation.dart';
import '../component/snack_bar.dart';
import 'dart:io' show Platform;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
//Variables
  String accessToken = "";
  String? buildingName, buildingAddress, buildingImg;
  dynamic apiResult;

// APIs
  Future<void> readBuildingInfo({required String accessToken}) async {
    try {
      var response = await http.get(Uri.parse("$baseUrl/building/info/by-guard"), headers: authHeader(accessToken));
      Map result = jsonDecode(response.body);
      if (result["code"] == 200) showSnackBar(context: context, label: result["response"]); //success
      if (result["code"] != 200) showSnackBar(context: context, label: result["message"]); //error
      setState(() => apiResult = result["data"]);
      setState(() => buildingName = apiResult["buildingName"]);
      setState(() => buildingAddress = apiResult["address"]);
      setState(() => buildingImg = "https://source.unsplash.com/random/?building");
      final pref = await SharedPreferences.getInstance();
      await pref.setString("buildingName", apiResult["buildingName"]);
      await pref.setString("buildingAddress", apiResult["address"]);
      await pref.setInt("buildingID", apiResult["buildingId"]);
      await pref.setString("buildingUniqueID", apiResult["uniqueId"]);
      await pref.setString("buildingImg", "https://source.unsplash.com/random/?building");
    } on Exception catch (e) {
      showSnackBar(context: context, label: e.toString());
    }
  }

  Future<void> sendFcmToken({required String accessToken}) async {
    var fcmToken = await FirebaseMessaging.instance.getToken();
    String platform = (Platform.isAndroid) ? "android" : "ios";
    if (kDebugMode) print('$platform Token: $fcmToken');
    try {
      var response = await http.post(Uri.parse("$baseUrl/push/token/update"), headers: authHeader(accessToken), body: jsonEncode({"token": fcmToken, "device": platform}));
      Map result = jsonDecode(response.body);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        showSnackBar(context: context, label: result["message"]);
      } else {
        showSnackBar(context: context, label: result["message"][0].toString().length == 1 ? result["message"].toString() : result["message"][0].toString());
      }
    } on Exception catch (e) {
      showSnackBar(context: context, label: e.toString());
    }
  }

//Functions
  defaultInit() async {
    // initiateNotificationReceiver();
    final pref = await SharedPreferences.getInstance();
    setState(() => accessToken = pref.getString("accessToken") ?? "");
    setState(() => buildingName = pref.getString("buildingName"));
    setState(() => buildingAddress = pref.getString("buildingAddress"));
    setState(() => buildingImg = pref.getString("buildingImg"));
    await readBuildingInfo(accessToken: accessToken);
    await sendFcmToken(accessToken: accessToken);
  }

  //todo: SplashScreen e dibo
  // initiateNotificationReceiver() async {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     RemoteNotification? notification = message.notification;
  //     AndroidNotification? android = message.notification?.android;
  //     if (notification != null && android != null) {
  //       print("Got a New Notification: ${notification.title}\n${message.data}");
  //     }
  //   });
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     print('A new onMessageOpenedApp event was published!');
  //     RemoteNotification? notification = message.notification;
  //     AndroidNotification? android = message.notification?.android;
  //     if (notification != null && android != null) {
  //       print(message.data);
  //       print("Got a New Notification: ${notification.title}\n${message.data}");
  //       // if (message.data["topic"] == "visitor") route(context, PerformVisitorPermission(historyId: "${message.data["historyId"]}"));
  //     }
  //   });
  // }

//Initiate
  @override
  void initState() {
    super.initState();
    defaultInit();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Scaffold(
            appBar: primaryAppBar(context: context),
            body: Column(children: [
              HeaderBuildingImage(flex: 3, buildingAddress: buildingAddress ?? "Getting Location...", buildingImage: buildingImg ?? placeholderImage, buildingName: buildingName ?? "LOADING!"),
              Expanded(
                  flex: 2,
                  child: Row(children: [
                    menuGridTile(
                        title: "Visitor Management",
                        assetImage: "visitor",
                        context: context,
                        toPage: VisitorMobileNoEntry(buildingAddress: buildingAddress ?? "Getting Location...", buildingImg: buildingImg ?? placeholderImage, buildingName: buildingName ?? "LOADING!")),
                    menuGridTile(title: "Delivery Management", assetImage: "delivery", context: context)
                  ])),
              Expanded(
                  flex: 2,
                  child: Row(children: [
                    menuGridTile(
                        title: "Gate Pass",
                        assetImage: "gatePass",
                        context: context,
                        toPage: VisitorGatePassCodeEntry(buildingAddress: buildingAddress ?? "Getting Location...", buildingImg: buildingImg ?? placeholderImage, buildingName: buildingName ?? "LOADING!")),
                    menuGridTile(title: "Intercom", assetImage: "intercom", context: context),
                    menuGridTile(title: "Car Parking", assetImage: "parking", context: context)
                  ])),
              Expanded(
                  flex: 2,
                  child: Row(children: [
                    menuGridTile(title: "Overstay Alert", assetImage: "overstay", context: context),
                    menuGridTile(title: "Utility Contacts", assetImage: "utility", context: context),
                    menuGridTile(title: "Residents", assetImage: "apartment", context: context, toPage: const BuildingFlatsAndResidents())
                  ]))
            ])));
  }
}
