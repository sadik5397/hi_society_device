import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:hi_society_device/api/i18n.dart';
import 'package:hi_society_device/component/button.dart';
import 'package:hi_society_device/component/page_navigation.dart';
import 'package:hi_society_device/theme/colors.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import 'package:hi_society_device/theme/text_style.dart';
import 'package:hi_society_device/views/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityAlertScreen extends StatefulWidget {
  const SecurityAlertScreen({Key? key, this.alert = "Other", required this.flat}) : super(key: key);
  final String alert;
  final String flat;

  @override
  State<SecurityAlertScreen> createState() => _SecurityAlertScreenState();
}

class _SecurityAlertScreenState extends State<SecurityAlertScreen> {
  //variables
  int step = 0;
  bool madeResponse = false;
  bool isBN = false;

  //functions
  colorShifter() async {
    if (!madeResponse) {
      setState(() => step++);
      await Future.delayed(const Duration(milliseconds: 250));
      FlutterBeep.beep();
      await colorShifter();
    }
  }

  //Functions
  defaultInit() async {
    final pref = await SharedPreferences.getInstance();
    setState(() => isBN = pref.getBool("isBN") ?? false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  //initiate
  @override
  void initState() {
    super.initState();
    defaultInit();
    colorShifter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: (step % 2 == 0) ? const Color(0xffff0000) : const Color(0xff0000ff),
            child: Column(children: [
              SizedBox(height: primaryPaddingValue * 4),
              Expanded(child: AnimatedScale(duration: const Duration(milliseconds: 250), scale: (step % 3 == 0) ? .8 : 1, child: Image.asset("assets/alert/${widget.alert}.png", color: trueWhite))),
              SizedBox(height: primaryPaddingValue * 2),
              FittedBox(child: Text(widget.alert.toUpperCase(), style: bigOTP)),
              Text("${i18n_fromFlat(isBN)} ${widget.flat}".toUpperCase(), style: bigOTP, textScaleFactor: .3),
              SizedBox(height: primaryPaddingValue * 4),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: primaryPaddingValue * 6),
                  child: primaryButton(
                      context: context,
                      title: i18n_acknowledged(isBN),
                      onTap: () async {
                        setState(() => madeResponse = true);
                        await Future.delayed(const Duration(seconds: 1));
                        // ignore: use_build_context_synchronously
                        route(context, const Home());
                      })),
              SizedBox(height: primaryPaddingValue * 4)
            ])));
  }
}
