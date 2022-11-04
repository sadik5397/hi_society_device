import 'package:flutter/material.dart';
import 'package:hi_society_device/component/page_navigation.dart';
import '../../theme/colors.dart';
import '../../theme/padding_margin.dart';
import '../home.dart';

class Call extends StatefulWidget {
  const Call({Key? key}) : super(key: key);

  @override
  State<Call> createState() => _CallState();
}

class _CallState extends State<Call> {
  //variable
  int minute = 0;
  bool callEnded = false;

  //function
  Future startClock() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() => minute++);
    if (!callEnded) startClock();
  }

  //initiate
  @override
  void initState() {
    super.initState();
    startClock();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        body: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/call_frame.png"), fit: BoxFit.cover)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
              Padding(padding: EdgeInsetsDirectional.only(top: primaryPaddingValue * 4, bottom: primaryPaddingValue * 3), child: Image.asset('assets/hi_society_call.png', width: 180, fit: BoxFit.contain)),
              Expanded(
                  child: Container(
                margin: EdgeInsets.symmetric(horizontal: primaryPaddingValue * 3),
                alignment: Alignment.center,
                decoration: BoxDecoration(border: Border.all(color: primaryColor.withOpacity(.5), width: 10), color: trueWhite.withOpacity(.9), shape: BoxShape.circle),
                child: Text('12A',
                    textAlign: TextAlign.center, style: Theme.of(context).textTheme.displayLarge?.copyWith(color: primaryColor, fontSize: MediaQuery.of(context).size.width * .25, fontWeight: FontWeight.bold)),
              )),
              AnimatedPadding(
                  duration: const Duration(seconds: 2),
                  padding: EdgeInsets.only(top: callEnded ? primaryPaddingValue * 4 : primaryPaddingValue * 3, bottom: callEnded ? primaryPaddingValue * 3 : 0),
                  child: AnimatedScale(
                      scale: callEnded ? .5 : 1,
                      duration: const Duration(seconds: 2),
                      child: Text('Md. Zulfiaqar Sayeed', textAlign: TextAlign.center, style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)))),
              AnimatedScale(
                scale: callEnded ? 4 : 1,
                duration: const Duration(seconds: 2),
                child: AnimatedPadding(
                    duration: const Duration(seconds: 2),
                    padding: EdgeInsets.only(top: primaryPaddingValue * .5, bottom: callEnded ? primaryPaddingValue : 0),
                    child: Text('00:${(minute < 10) ? "0" : ""}$minute', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 28, fontWeight: FontWeight.normal))),
              ),
              Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
                callButton(size: callEnded ? 120 : 150, color: const Color(0xFF1ABC9C), icon: Icons.volume_up, onTap: () => print("Speaker")),
                SizedBox(width: primaryPaddingValue * 8),
                callButton(
                    size: callEnded ? 120 : 150,
                    color: const Color(0xFFf15a4a),
                    icon: Icons.call_end_rounded,
                    onTap: () async {
                      print("End Call");
                      setState(() => callEnded = true);
                      await Future.delayed(const Duration(seconds: 3));
                      // ignore: use_build_context_synchronously
                      route(context, const Home());
                    }),
              ])
            ])));
  }
}

Padding callButton({required double size, required Color color, required IconData icon, required VoidCallback onTap}) {
  return Padding(
      padding: EdgeInsets.symmetric(vertical: primaryPaddingValue * 4),
      child: Material(
          borderRadius: BorderRadius.circular(200),
          color: color,
          child: InkWell(
              borderRadius: BorderRadius.circular(200),
              onTap: onTap,
              child: AnimatedContainer(
                  duration: const Duration(seconds: 2),
                  width: size,
                  height: size,
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0x60FFFFFF), width: 8)),
                  child: Icon(icon, color: trueWhite, size: 48)))));
}
