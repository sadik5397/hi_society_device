// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:hi_society_device/api/i18n.dart';
import 'package:hi_society_device/component/button.dart';
import 'package:hi_society_device/component/guard_guard_tile.dart';
import 'package:hi_society_device/component/page_navigation.dart';
import 'package:hi_society_device/views/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/border_radius.dart';
import '../theme/colors.dart';
import '../theme/padding_margin.dart';

class SwitchGuardUser extends StatefulWidget {
  const SwitchGuardUser({Key? key, required this.onSignOut}) : super(key: key);
  final VoidCallback onSignOut;

  @override
  State<SwitchGuardUser> createState() => _SwitchGuardUserState();
}

class _SwitchGuardUserState extends State<SwitchGuardUser> {
  bool isBN = false;

  //Functions
  defaultInit() async {
    final pref = await SharedPreferences.getInstance();
    setState(() => isBN = pref.getBool("isBN") ?? false);
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
        backgroundColor: trueBlack.withOpacity(.5),
        body: Center(
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: primaryPaddingValue * 4, vertical: primaryPaddingValue),
                padding: EdgeInsets.symmetric(vertical: primaryPaddingValue * 2, horizontal: primaryPaddingValue * 2),
                decoration: BoxDecoration(color: trueWhite, borderRadius: primaryBorderRadius * 2),
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: primaryPaddingValue * 1.5),
                    child: Text(i18n_tapSwitchGuard(isBN), textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: primaryTitleColor, fontWeight: FontWeight.bold)),
                  ),
                  GridView.builder(
                      itemCount: 2,
                      shrinkWrap: true,
                      primary: false,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: primaryPaddingValue, crossAxisSpacing: primaryPaddingValue),
                      itemBuilder: (context, index) => guardGridTile(context: context, onTap: () => routeBack(context), name: "Samiul Alam Kafi", photo: "https://picsum.photos/200/300?random=$index")),
                  Padding(
                      padding: EdgeInsets.fromLTRB(primaryPaddingValue * 2, primaryPaddingValue * 2, primaryPaddingValue * 2, 0),
                      child: (ToggleButtons(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          borderRadius: primaryBorderRadius,
                          textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color: trueWhite, fontWeight: FontWeight.bold),
                          isSelected: [!isBN, isBN],
                          onPressed: (index) async {
                            setState(() => isBN = !isBN);
                            final pref = await SharedPreferences.getInstance();
                            pref.setBool("isBN", isBN);
                            route(context, const Home());
                          },
                          color: primaryColor,
                          fillColor: primaryColor,
                          borderColor: primaryColor,
                          disabledBorderColor: trueBlack,
                          disabledColor: primaryColor,
                          renderBorder: true,
                          splashColor: primaryColor.withOpacity(.15),
                          selectedBorderColor: primaryColor,
                          selectedColor: trueWhite,
                          borderWidth: 2,
                          children: [
                            Container(
                                alignment: Alignment.center, width: MediaQuery.of(context).size.width / 2 - primaryPaddingValue * 8.4, height: 56, child: const Text("English", textAlign: TextAlign.center)),
                            Container(alignment: Alignment.center, width: MediaQuery.of(context).size.width / 2 - primaryPaddingValue * 8.4, height: 56, child: const Text("বাংলা", textAlign: TextAlign.center)),
                          ]))),
                  Padding(
                      padding: EdgeInsets.fromLTRB(primaryPaddingValue * 2, primaryPaddingValue * 1.5, primaryPaddingValue * 2, primaryPaddingValue),
                      child: primaryButton(icon: Icons.lock_clock_rounded, primary: false, context: context, title: i18n_deActiveDevice(isBN), onTap: widget.onSignOut)),
                ]))));
  }
}
