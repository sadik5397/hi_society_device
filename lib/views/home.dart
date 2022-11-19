import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:hi_society_device/theme/placeholder.dart';
import 'package:hi_society_device/views/auth/sign_in.dart';
import 'package:hi_society_device/views/car_parking/car_parking.dart';
import 'package:hi_society_device/views/delivery/receive_or_distribute.dart';
import 'package:hi_society_device/views/gate_pass/visitor_gate_pas_code_entry.dart';
import 'package:hi_society_device/views/intercom/contactList.dart';
import 'package:hi_society_device/views/overstay/overstay.dart';
import 'package:hi_society_device/views/residents/building_residents.dart';
import 'package:hi_society_device/views/security_alert/security_alert_screen.dart';
import 'package:hi_society_device/views/utility/utility_contacts.dart';
import 'package:hi_society_device/views/visitor/visitor_mobile_no_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api.dart';
import '../component/app_bar.dart';
import '../component/dialogue_box.dart';
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
  String refreshToken = "";
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

  Future<void> verifyAccessToken({required String accessToken, required String refreshToken}) async {
    try {
      var response1 = await http.post(Uri.parse("$baseUrl/auth/jwt/verify"), headers: authHeader(accessToken));
      Map result1 = jsonDecode(response1.body);
      print(result1);
      if (result1["statusCode"] == 200 || result1["statusCode"] == 201) {
        showSnackBar(context: context, label: result1["message"]);
        print("-------Access Token Verified---------");
      } else {
        showSnackBar(context: context, label: result1["message"][0].toString().length == 1 ? result1["message"].toString() : result1["message"][0].toString());
        print("Access Token Invalid or Expired");
        var response2 = await http.post(Uri.parse("$baseUrl/auth/jwt/refresh"), headers: authHeader(refreshToken));
        print("Attempting to refresh the Access Token");
        Map result2 = jsonDecode(response2.body);
        print(result2);
        if (result2["statusCode"] == 200 || result2["statusCode"] == 201) {
          showSnackBar(context: context, label: result2["message"]);
          final pref = await SharedPreferences.getInstance();
          await pref.setString("accessToken", result2["data"]["accessToken"]);
          await pref.setString("refreshToken", result2["data"]["refreshToken"]);
        } else {
          showSnackBar(context: context, label: result2["message"][0].toString().length == 1 ? result2["message"].toString() : result2["message"][0].toString());
          print("Refresh Token Invalid or Expired");
          print("User will be signed out");
          var response3 = await http.post(Uri.parse("$baseUrl/auth/logout"), headers: authHeader(accessToken));
          var response4 = await http.post(Uri.parse("$baseUrl/auth/logout"), headers: authHeader(refreshToken));
          print("Attempting to Logging out");
          Map result3 = jsonDecode(response3.body);
          Map result4 = jsonDecode(response4.body);
          print(result3);
          print(result4);
          final pref = await SharedPreferences.getInstance();
          pref.remove("accessToken");
          routeNoBack(context, const SignIn());
        }
      }
    } on Exception catch (e) {
      showSnackBar(context: context, label: e.toString());
    }
  }

//Functions
  defaultInit() async {
    initiateNotificationReceiver();
    final pref = await SharedPreferences.getInstance();
    setState(() => accessToken = pref.getString("accessToken") ?? "");
    setState(() => refreshToken = pref.getString("refreshToken") ?? "");
    setState(() => buildingName = pref.getString("buildingName"));
    setState(() => buildingAddress = pref.getString("buildingAddress"));
    setState(() => buildingImg = pref.getString("buildingImg"));
    await verifyAccessToken(accessToken: accessToken, refreshToken: refreshToken);
    await readBuildingInfo(accessToken: accessToken);
    await sendFcmToken(accessToken: accessToken);
  }

  //todo: SplashScreen e dibo
  initiateNotificationReceiver() async {
    print("Notification Receiver Activated");
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        print("${message.data}-------------------->>");
        if (message.data["topic"] == "security-alert") route(context, SecurityAlertScreen(alert: message.data["alertTypeName"], flat: message.data["flatName"]));
        // showSnackBar(
        //     context: context,
        //     label: message.notification!.title ?? "Got a New Notification",
        //     seconds: 8,
        //     action: "VIEW",
        //     onTap: () {
        //       if (message.data["topic"] == "security-alert") route(context, SecurityAlertScreen(alert: "Fire"));
        //     });
      }
    }
        // );
        // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        //   print('A new onMessageOpenedApp event was published!');
        //   RemoteNotification? notification = message.notification;
        //   AndroidNotification? android = message.notification?.android;
        //   if (notification != null && android != null) {
        //     print(message.data);
        //     print(notification.body);
        //     if (message.data["topic"] == "security-alert") route(context, SecurityAlertScreen(alert: message.data["alertTypeName"], flat: message.data["flatName"]));
        //   }
        // }
        );
  }

//Initiate
  @override
  void initState() {
    super.initState();
    defaultInit();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
          top: false,
          child: Scaffold(
              appBar: primaryAppBar(
                context: context,
                prefix: IconButton(onPressed: () => Phoenix.rebirth(context), icon: const Icon(Icons.settings_backup_restore)),
                suffix: IconButton(onPressed: () => showDialog(context: context, builder: (BuildContext context) => switchGuardUser(context: context)), icon: const Icon(Icons.lock_outline_rounded)),
              ),
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
                      menuGridTile(title: "Delivery Management", assetImage: "delivery", context: context, toPage: const ReceiveOrDistribute())
                    ])),
                Expanded(
                    flex: 2,
                    child: Row(children: [
                      menuGridTile(title: "Gate Pass", assetImage: "gatePass", context: context, toPage: const VisitorGatePassCodeEntry()),
                      menuGridTile(title: "Intercom", assetImage: "intercom", context: context, toPage: const ContactList()),
                      menuGridTile(title: "Car Parking", assetImage: "parking", context: context, toPage: const CarParking())
                    ])),
                Expanded(
                    flex: 2,
                    child: Row(children: [
                      menuGridTile(title: "Overstay Alert", assetImage: "overstay", context: context, toPage: const OverstayAlerts()),
                      menuGridTile(title: "Utility Contacts", assetImage: "utility", context: context, toPage: const UtilityContacts()),
                      menuGridTile(title: "Residents", assetImage: "apartment", context: context, toPage: const BuildingFlatsAndResidents())
                    ]))
              ]))),
    );
  }
}
