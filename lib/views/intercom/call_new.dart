import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../api/api.dart';
import '../../component/page_navigation.dart';
import '../../component/snack_bar.dart';
import '../../theme/colors.dart';
import '../../theme/padding_margin.dart';
import '../../theme/placeholder.dart';
import '../../theme/text_style.dart';
import '../home.dart';

class CallNew extends StatefulWidget {
  const CallNew(
      {Key? key, required this.receiverImage, required this.receiverName, required this.callID, required this.receiverId, this.isReceiving = false, required this.intercomHistoryId, required this.userId})
      : super(key: key);
  final String receiverName, receiverImage, callID;
  final int receiverId, intercomHistoryId, userId;
  final bool isReceiving;

  @override
  State<CallNew> createState() => _CallState();
}

class _CallState extends State<CallNew> {
  //variables
  String accessToken = "";
  String userId = "";
  String buildingImg = "";
  int second = 0;
  int minute = 0;
  bool callEnded = false;
  bool callReceived = false;
  late int intercomHistoryId = widget.intercomHistoryId;
  late String callStatus = widget.isReceiving ? "Call Accepted" : "Connecting...";

  //API
  Future<void> createCallAndSendCallNotification({required String accessToken, required int calleeId, required String roomId}) async {
    print("---------------createCallAndSendCallNotification---------------");
    try {
      var response = await http.post(Uri.parse("$baseUrl/intercom/call"), headers: authHeader(accessToken), body: jsonEncode({"calleeId": calleeId, "roomId": roomId}));
      Map result = jsonDecode(response.body);
      print(result);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        if (kDebugMode) showSnackBar(context: context, label: result["message"]);
        setState(() => intercomHistoryId = result["data"]["intercomHistoryId"]);
      } else {
        showSnackBar(context: context, label: result["message"][0].toString().length == 1 ? result["message"].toString() : result["message"][0].toString());
      }
    } on Exception catch (e) {
      showSnackBar(context: context, label: e.toString());
    }
  }

  Future<void> sendCallResponse({required String accessToken, required int intercomHistoryId, required String callStatus}) async {
    print(jsonEncode({"intercomHistoryId": intercomHistoryId, "callStatus": callStatus}));
    try {
      var response = await http.post(Uri.parse("$baseUrl/intercom/respond"), headers: authHeader(accessToken), body: jsonEncode({"intercomHistoryId": intercomHistoryId, "callStatus": callStatus}));
      Map result = jsonDecode(response.body);
      print(result);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        if (kDebugMode) showSnackBar(context: context, label: result["message"]);
      } else {
        showSnackBar(context: context, label: result["message"][0].toString().length == 1 ? result["message"].toString() : result["message"][0].toString());
      }
    } on Exception catch (e) {
      showSnackBar(context: context, label: e.toString());
    }
  }

  //Other Side Response Notification Receiver
  initiateRealtimeStatusChecker() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // RemoteNotification? notification = message.notification;
      // AndroidNotification? android = message.notification?.android;

      print("Got a New Notification: ${message.data["title"]}\n${message.data["body"]}");
      if (message.data["topic"] == "intercom-response" && message.data["response"] == "call_rejected") {
        setState(() => callEnded = true);
        setState(() => callStatus = "Call Rejected");
      }
      if (message.data["topic"] == "intercom-response" && message.data["response"] == "call_ended") {
        setState(() => callEnded = true);
      }
      if (message.data["topic"] == "intercom-response" && message.data["response"] == "call_accepted") {
        setState(() => callReceived = true);
        startClock();
      }
    });
  }

  //autoHangUpAfter30SecIfNotConnected
  Future autoHangUpAfter30SecIfNotConnected() async {
    await Future.delayed(const Duration(seconds: 30));
    if (callStatus == "Connecting...") await hangUpCall();
  }

  hangUpCall() async {
    if (callStatus == "Connecting...") setState(() => callStatus = "Call Ended");
    routeNoBack(context, const Home());
    if (callStatus != "Call Rejected") await sendCallResponse(accessToken: accessToken, intercomHistoryId: intercomHistoryId, callStatus: "call_ended");
  }

  //Functions
  Future<void> defaultInit() async {
    initiateRealtimeStatusChecker();
    autoHangUpAfter30SecIfNotConnected();
    final pref = await SharedPreferences.getInstance();
    setState(() => accessToken = pref.getString("accessToken")!);
    setState(() => buildingImg = pref.getString("buildingImg") ?? placeholderImage);
    setState(() => userId = widget.userId.toString());
    if (!widget.isReceiving) if (kDebugMode) print("---------------Notify other user with API---------------");
    if (!widget.isReceiving) await createCallAndSendCallNotification(accessToken: accessToken, calleeId: widget.receiverId, roomId: widget.callID);
    if (kDebugMode) print("---------------Start Timer if received---------------");
    // if (widget.isReceiving) startClock();
  }

  //Call Timer
  Future startClock() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() => second++);
    if (second == 60) {
      setState(() {
        minute++;
        second = 0;
      });
    }
    setState(() => callStatus = '${(minute < 10) ? "0$minute" : minute}:${(second < 10) ? "0$second" : second}');
    if (!callEnded) startClock();
  }

  //Initiate
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    defaultInit();
  }

  //Dispose
  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: ZegoUIKitPrebuiltCall(
        appID: 2048479123,
        appSign: "c3de3b988cb6e37cd6f58c3382e12a8f99d7a076dbff74c5b3df3898797850f6",
        userID: widget.receiverId.toString(),
        userName: 'hiSociety@${widget.receiverId}',
        callID: widget.callID,
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
          ..avatarBuilder = (BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo) {
            return Container(
                decoration: BoxDecoration(
                    border: Border.all(color: primaryColor.withOpacity(.5), width: 2),
                    color: trueWhite.withOpacity(.9),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(!callReceived
                            ? widget.receiverImage
                            : (user?.id == userId)
                                ? widget.receiverImage
                                : buildingImg),
                        fit: BoxFit.cover)));
          }
          ..layout = ZegoLayout.pictureInPicture(smallViewSize: Size.zero, isSmallViewDraggable: false, switchLargeOrSmallViewByClick: false)
          ..onOnlySelfInRoom = (context) {
            Navigator.of(context).pop();
          }
          ..audioVideoViewConfig = ZegoPrebuiltAudioVideoViewConfig(
              showAvatarInAudioMode: true,
              showMicrophoneStateOnView: true,
              showCameraStateOnView: false,
              showUserNameOnView: false,
              showSoundWavesInAudioMode: true,
              useVideoViewAspectFill: false,
              backgroundBuilder: (context, size, user, extraInfo) => Opacity(
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
              foregroundBuilder: (context, size, user, extraInfo) => !callReceived
                  ? Column(children: [
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
                            child: Text(callEnded ? "Call Ended" : callStatus, textAlign: TextAlign.center, style: semiBold16White.copyWith(fontSize: 42, fontWeight: FontWeight.bold)))
                      ])))
                    ])
                  : user?.id == userId
                      ? Column(children: [
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
                                child: Text(callEnded ? "Call Ended" : callStatus, textAlign: TextAlign.center, style: semiBold16White.copyWith(fontSize: 42, fontWeight: FontWeight.bold)))
                          ])))
                        ])
                      : const SizedBox())
          ..bottomMenuBarConfig = ZegoBottomMenuBarConfig(
              style: ZegoMenuBarStyle.light,
              hideAutomatically: false,
              hideByClick: false,
              maxCount: 3,
              buttons: [ZegoMenuBarButtonName.toggleMicrophoneButton, ZegoMenuBarButtonName.hangUpButton, ZegoMenuBarButtonName.switchAudioOutputButton])
          // ..onHangUp = () {
          //   if (kDebugMode) print("Tata ByBY");
          // }
          ..durationConfig = ZegoCallDurationConfig(isVisible: false)
          ..turnOnCameraWhenJoining = false
          ..turnOnMicrophoneWhenJoining = true
          ..useSpeakerWhenJoining = true
          ..onHangUp = () async => await hangUpCall(),
      ),
    );
  }
}
