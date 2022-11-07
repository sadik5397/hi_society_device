import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hi_society_device/component/button.dart';
import 'package:hi_society_device/theme/colors.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import 'package:hi_society_device/theme/text_style.dart';

class SecurityAlertScreen extends StatefulWidget {
  const SecurityAlertScreen({Key? key, this.alert = "Fire"}) : super(key: key);
  final String alert;

  @override
  State<SecurityAlertScreen> createState() => _SecurityAlertScreenState();
}

class _SecurityAlertScreenState extends State<SecurityAlertScreen> {
  //variables
  int step = 0;
  bool madeResponse = false;

  //functions
  colorShifter() async {
    setState(() => step++);
    if (kDebugMode) print(step);
    await Future.delayed(const Duration(milliseconds: 250));
    if (!madeResponse) await colorShifter();
  }

  //initiate
  @override
  void initState() {
    super.initState();
    colorShifter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: (step % 2 == 0) ? const Color(0xffff0000) : const Color(0xff0000ff),
      child: Column(
        children: [
          SizedBox(height: primaryPaddingValue * 4),
          Expanded(child: AnimatedScale(duration: const Duration(milliseconds: 250), scale: (step % 3 == 0) ? .8 : 1, child: Image.asset("assets/alert/${widget.alert}.png", color: trueWhite))),
          SizedBox(height: primaryPaddingValue * 2),
          FittedBox(child: Text("Fire".toUpperCase(), style: bigOTP)),
          Text("From Flat A2".toUpperCase(), style: bigOTP, textScaleFactor: .3),
          SizedBox(height: primaryPaddingValue * 4),
          Padding(padding: EdgeInsets.symmetric(horizontal: primaryPaddingValue * 6), child: primaryButton(context: context, title: "Acknowledged", onTap: () => setState(() => madeResponse = true))),
          SizedBox(height: primaryPaddingValue * 4)
        ],
      ),
    ));
  }
}
