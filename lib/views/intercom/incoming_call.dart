import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api.dart';
import '../../component/page_navigation.dart';
import '../../component/snack_bar.dart';
import '../../theme/colors.dart';
import '../../theme/padding_margin.dart';
import '../../theme/text_style.dart';
import '../home.dart';
import 'call_new.dart';

class IncomingCall extends StatefulWidget {
  const IncomingCall({Key? key, required this.receiverImage, required this.receiverName, required this.callID, required this.receiverId, this.isReceiving = false, required this.intercomHistoryId})
      : super(key: key);
  final String receiverName, receiverImage, callID;
  final int receiverId, intercomHistoryId;
  final bool isReceiving;

  @override
  State<IncomingCall> createState() => _IncomingCallState();
}

class _IncomingCallState extends State<IncomingCall> {
  //variables
  String accessToken = "";
  String intercomResponse = "Incoming Call";
  int userId = 0;

  //API
  Future<void> sendCallResponse({required String accessToken, required int intercomHistoryId, required String callStatus}) async {
    print(jsonEncode({"intercomHistoryId": intercomHistoryId, "callStatus": callStatus}));
    try {
      var response = await http.post(Uri.parse("$baseUrl/intercom/respond"), headers: authHeader(accessToken), body: jsonEncode({"intercomHistoryId": intercomHistoryId, "callStatus": callStatus}));
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

  Future<void> getMyInfo({required String accessToken}) async {
    try {
      var response = await http.post(Uri.parse("$baseUrl/user/me"), headers: authHeader(accessToken));
      Map result = jsonDecode(response.body);
      if (kDebugMode) print(result);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        if (kDebugMode) showSnackBar(context: context, label: result["message"]);
        setState(() => userId = result["data"]["userId"]);
      } else {
        showError(context: context, label: result["message"][0].toString().length == 1 ? result["message"].toString() : result["message"][0].toString());
      }
    } on Exception catch (e) {
      showError(context: context, label: e.toString());
    }
  }

  //Other Side Response Notification Receiver
  initiateRealtimeStatusChecker() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // RemoteNotification? notification = message.notification;
      // AndroidNotification? android = message.notification?.android;

      print("Got a New Notification: ${message.data["title"]}\n${message.data["body"]}");
      if (message.data["topic"] == "intercom-response" && message.data["response"] == "call_ended") {
        setState(() => intercomResponse = "Call Ended");
        hangUpCall();
      }
    });
  }

  hangUpCall() {
    FlutterRingtonePlayer.stop();
    routeNoBack(context, const Home());
  }

  //Functions
  Future<void> defaultInit() async {
    initiateRealtimeStatusChecker();
    final pref = await SharedPreferences.getInstance();
    setState(() => accessToken = pref.getString("accessToken")!);
    FlutterRingtonePlayer.play(
      fromAsset: "assets/intercom.mp3", // will be the sound on Android
      ios: IosSounds.glass, // will be the sound on iOS
      looping: true,
    );
    await getMyInfo(accessToken: accessToken);
  }

  //Initiate
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    defaultInit();
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  //Part Widgets
  Padding callButton({required double size, required Color color, required IconData icon, required VoidCallback onTap}) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: primaryPaddingValue * 4),
        child: Material(
            borderRadius: BorderRadius.circular(200),
            color: color,
            child: InkWell(
                borderRadius: BorderRadius.circular(200),
                onTap: onTap,
                child: Container(
                    width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0x60FFFFFF), width: 8)), child: Icon(icon, color: trueWhite, size: 48)))));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
            backgroundColor: trueBlack,
            body: Stack(alignment: Alignment.bottomCenter, children: [
              Opacity(
                opacity: .75,
                child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: primaryColor, image: const DecorationImage(image: AssetImage("assets/call_frame.png"), fit: BoxFit.cover)),
                    child: Opacity(
                        opacity: .25,
                        child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(image: DecorationImage(image: CachedNetworkImageProvider(widget.receiverImage), fit: BoxFit.cover)),
                            child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), child: Container(decoration: const BoxDecoration(color: Colors.transparent)))))),
              ),
              Column(children: [
                Padding(padding: EdgeInsets.only(top: primaryPaddingValue * 4), child: Image.asset('assets/hi_society_call.png', width: 180, fit: BoxFit.contain)),
                Expanded(
                    child: Center(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: primaryPaddingValue * 2),
                      child: Text(widget.receiverName, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 36))),
                  SizedBox(height: MediaQuery.of(context).size.height * .4),
                  Padding(
                      padding: EdgeInsets.only(bottom: primaryPaddingValue * 8),
                      child: Text(intercomResponse, textAlign: TextAlign.center, style: semiBold16White.copyWith(fontSize: 22, fontWeight: FontWeight.normal)))
                ])))
              ]),
              Padding(
                padding: primaryPadding * 3,
                child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(
                      icon: Icon(Icons.call, color: trueWhite, size: 36),
                      style: IconButton.styleFrom(backgroundColor: const Color(0xFF1ABC9C), shape: const CircleBorder(), fixedSize: const Size.square(72)),
                      onPressed: () async {
                        setState(() => intercomResponse = "Call Accepted");
                        // routeBack(context);
                        FlutterRingtonePlayer.stop();
                        routeNoBack(
                            context,
                            CallNew(
                                userId: userId,
                                receiverImage: widget.receiverImage,
                                receiverName: widget.receiverName,
                                callID: widget.callID,
                                receiverId: widget.receiverId,
                                isReceiving: true,
                                intercomHistoryId: widget.intercomHistoryId));
                        await sendCallResponse(accessToken: accessToken, intercomHistoryId: widget.intercomHistoryId, callStatus: "call_accepted");
                      }),
                  SizedBox(width: primaryPaddingValue * 5),
                  IconButton(
                      icon: Icon(Icons.call_end_rounded, color: trueWhite, size: 36),
                      style: IconButton.styleFrom(backgroundColor: Colors.redAccent, shape: const CircleBorder(), fixedSize: const Size.square(72)),
                      onPressed: () async {
                        setState(() => intercomResponse = "Call Rejected");
                        FlutterRingtonePlayer.stop();
                        routeBack(context);
                        await sendCallResponse(accessToken: accessToken, intercomHistoryId: widget.intercomHistoryId, callStatus: "call_rejected");
                      }),
                ]),
              ),
              Center(
                  child: Container(
                      height: 135,
                      width: 135,
                      decoration: BoxDecoration(
                          border: Border.all(color: primaryColor.withOpacity(.5), width: 2),
                          color: trueWhite.withOpacity(.9),
                          shape: BoxShape.circle,
                          image: DecorationImage(image: CachedNetworkImageProvider(widget.receiverImage), fit: BoxFit.cover))))
            ])));
  }
}
