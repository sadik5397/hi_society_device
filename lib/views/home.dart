import 'dart:convert';
import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:hi_society_device/api/i18n.dart';
import 'package:hi_society_device/theme/colors.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import 'package:hi_society_device/theme/placeholder.dart';
import 'package:hi_society_device/views/auth/sign_in.dart';
import 'package:hi_society_device/views/car_parking/amenity_car_parking.dart';
import 'package:hi_society_device/views/delivery/receive_or_distribute.dart';
import 'package:hi_society_device/views/intercom/contactList.dart';
import 'package:hi_society_device/views/overstay/overstay.dart';
import 'package:hi_society_device/views/residents/building_residents.dart';
import 'package:hi_society_device/views/security_alert/security_alert_screen.dart';
import 'package:hi_society_device/views/utility/utility_contacts.dart';
import 'package:hi_society_device/views/visitor/visitor_mobile_no_entry.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api.dart';
import '../component/app_bar.dart';
import '../component/dialogue_box.dart';
import '../component/header_building_image.dart';
import '../component/menu_grid_tile.dart';
import '../component/page_navigation.dart';
import '../component/snack_bar.dart';

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
  bool validToken = false;
  bool isBN = false;
  List<String> selectedGuardsAvatars = [];

// APIs
  Future<void> readBuildingInfo({required String accessToken}) async {
    try {
      var response = await http.get(Uri.parse("$baseUrl/building/info/by-guard"), headers: authHeader(accessToken));
      Map result = jsonDecode(response.body);
      print(result);
      if (result["code"] == 200) showSnackBar(context: context, label: result["response"]); //success
      if (result["code"] != 200) if (kDebugMode) showSnackBar(context: context, label: result["message"]); //error
      setState(() => apiResult = result["data"]);
      setState(() => buildingName = apiResult["buildingName"]);
      setState(() => buildingAddress = apiResult["address"]);
      setState(() => buildingImg = apiResult["photo"] == null ? "https://picsum.photos/2000/2000?random=1" : '$baseUrl/photos/${apiResult["photo"]}');
      final pref = await SharedPreferences.getInstance();
      await pref.setString("buildingName", apiResult["buildingName"]);
      await pref.setString("buildingAddress", apiResult["address"]);
      await pref.setInt("buildingID", apiResult["buildingId"]);
      await pref.setString("buildingUniqueID", apiResult["uniqueId"]);
      await pref.setString("buildingImg", buildingImg.toString());
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
        if (kDebugMode) showSnackBar(context: context, label: result["message"]);
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
        setState(() => validToken = true);
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

  Future<void> doSignOutFromSystem({required String accessToken, required String refreshToken}) async {
    var response1 = await http.post(Uri.parse("$baseUrl/auth/logout"), headers: authHeader(accessToken));
    Map result1 = jsonDecode(response1.body);
    print(result1);
    if (result1["statusCode"] == 200 || result1["statusCode"] == 201) {
      showSnackBar(context: context, label: result1["message"]);
      final pref = await SharedPreferences.getInstance();
      await pref.clear();
    }
    var response2 = await http.post(Uri.parse("$baseUrl/auth/logout"), headers: authHeader(refreshToken));
    Map result2 = jsonDecode(response2.body);
    print(result2);
    if (result2["statusCode"] == 200 || result2["statusCode"] == 201) {
      showSnackBar(context: context, label: result2["message"]);
    }
  }

  Future<void> handlePermissions() async => Permission.camera.request().then((value) async => Permission.microphone.request().then((value) async => print(value.toString())));

//Functions
  defaultInit() async {
    initiateNotificationReceiver();
    final pref = await SharedPreferences.getInstance();
    setState(() => isBN = pref.getBool("isBN") ?? true);
    setState(() => accessToken = pref.getString("accessToken") ?? "");
    setState(() => refreshToken = pref.getString("refreshToken") ?? "");
    setState(() => buildingName = pref.getString("buildingName"));
    setState(() => buildingAddress = pref.getString("buildingAddress"));
    setState(() => buildingImg = pref.getString("buildingImg"));
    setState(() => selectedGuardsAvatars = pref.getStringList("selectedGuardsAvatars") ?? []);
    await verifyAccessToken(accessToken: accessToken, refreshToken: refreshToken);
    if (validToken) await readBuildingInfo(accessToken: accessToken);
    if (validToken) await sendFcmToken(accessToken: accessToken);
    await handlePermissions();
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
                    isBN: isBN,
                    context: context,
                    prefix: IconButton(onPressed: () => Phoenix.rebirth(context), icon: const Icon(Icons.settings_backup_restore)),
                    suffix: IconButton(
                        onPressed: () => showDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (BuildContext context) => SwitchGuardUser(onSignOut: () async {
                                  route(context, const SignIn());
                                  final pref = await SharedPreferences.getInstance();
                                  await pref.clear();
                                  await doSignOutFromSystem(accessToken: accessToken, refreshToken: refreshToken);
                                })),
                        icon: selectedGuardsAvatars.isEmpty
                            ? Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: Icon(Icons.lock_clock_rounded, color: trueWhite))
                            : Stack(
                                alignment: Alignment.centerRight,
                                children: List.generate(
                                    selectedGuardsAvatars.length,
                                    (index) => Container(
                                        margin: EdgeInsets.only(right: primaryPaddingValue * index * 2.5),
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            border: Border.all(color: trueWhite, width: 2),
                                            borderRadius: BorderRadius.circular(100),
                                            image: DecorationImage(
                                                image: NetworkImage(placeholderImage),
                                                // MemoryImage(base64Decode(selectedGuardsAvatars[index])),
                                                fit: BoxFit.cover))))))),
                body: Column(children: [
                  HeaderBuildingImage(flex: 1, buildingAddress: buildingAddress ?? "...", buildingImage: buildingImg ?? placeholderImage, buildingName: buildingName ?? "..."),
                  Expanded(
                      flex: 2,
                      child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Column(children: [
                            Expanded(
                                flex: 2,
                                child: Row(children: [
                                  menuGridTile(
                                      title: i18n_visitorManagement(isBN),
                                      assetImage: "visitors",
                                      context: context,
                                      toPage: VisitorMobileNoEntry(buildingAddress: buildingAddress ?? "...", buildingImg: buildingImg ?? placeholderImage, buildingName: buildingName ?? "...")),
                                  menuGridTile(title: i18n_deliveryManagement(isBN), assetImage: "delivery", context: context, toPage: const ReceiveOrDistribute())
                                ])),
                            Expanded(
                                flex: 2,
                                child: Row(children: [
                                  // menuGridTile(title: i18n_digitalGatePass(isBN), assetImage: "gatePass", context: context, toPage: const VisitorGatePassCodeEntry()),
                                  menuGridTile(title: i18n_securityAlert(isBN), assetImage: "alert", context: context, toPage: const Home()),
                                  menuGridTile(title: i18n_intercom(isBN), assetImage: "intercom", context: context, toPage: const ContactList()),
                                  menuGridTile(title: i18n_requiredCarParking(isBN), assetImage: "parking", context: context, toPage: const AmenityCarParking())
                                ])),
                            Expanded(
                                flex: 2,
                                child: Row(children: [
                                  menuGridTile(title: i18n_overstayAlert(isBN), assetImage: "overstay", context: context, toPage: const OverstayAlerts()),
                                  menuGridTile(title: i18n_utilityContacts(isBN), assetImage: "utility", context: context, toPage: const UtilityContacts()),
                                  menuGridTile(title: i18n_residents(isBN), assetImage: "apartment", context: context, toPage: const BuildingFlatsAndResidents())
                                ]))
                          ])))
                ]))));
  }
}
