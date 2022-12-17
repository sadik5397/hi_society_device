// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hi_society_device/api/i18n.dart';
import 'package:hi_society_device/component/button.dart';
import 'package:hi_society_device/component/guard_guard_tile.dart';
import 'package:hi_society_device/component/page_navigation.dart';
import 'package:hi_society_device/component/snack_bar.dart';
import 'package:hi_society_device/views/home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api.dart';
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
  String accessToken = "";
  List guardList = [];
  List<String> selectedGuardsAvatars = [];

  Future<void> readGuardList({required String accessToken}) async {
    try {
      var response = await http.post(Uri.parse("$baseUrl/building/info/guard-list"), headers: authHeader(accessToken));
      Map result = jsonDecode(response.body);
      if (kDebugMode) print(result.toString());
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        if (kDebugMode) if (kDebugMode) showSnackBar(context: context, label: result["message"]);
        setState(() => guardList = result["data"]);
      } else {
        showSnackBar(context: context, label: result["message"][0].toString().length == 1 ? result["message"].toString() : result["message"][0].toString());
      }
    } on Exception catch (e) {
      showSnackBar(context: context, label: e.toString());
    }
  }

  defaultInit() async {
    final pref = await SharedPreferences.getInstance();
    setState(() => isBN = pref.getBool("isBN") ?? false);
    setState(() => accessToken = pref.getString("accessToken") ?? "");
    setState(() => selectedGuardsAvatars = pref.getStringList("selectedGuardsAvatars") ?? []);
    await readGuardList(accessToken: accessToken);
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
            child: AnimatedContainer(
                duration: const Duration(seconds: 1),
                margin: EdgeInsets.symmetric(horizontal: primaryPaddingValue * 4, vertical: primaryPaddingValue),
                padding: EdgeInsets.symmetric(vertical: primaryPaddingValue * 2, horizontal: primaryPaddingValue * 2),
                decoration: BoxDecoration(color: trueWhite, borderRadius: primaryBorderRadius * 2),
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: primaryPaddingValue * 1.5),
                    child: Text(i18n_tapSwitchGuard(isBN), textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: primaryTitleColor, fontWeight: FontWeight.bold)),
                  ),
                  AnimatedCrossFade(
                      alignment: Alignment.center,
                      firstChild: Padding(padding: primaryPadding * 2, child: const CircularProgressIndicator()),
                      secondChild: GridView.builder(
                          itemCount: guardList.length,
                          padding: EdgeInsets.symmetric(horizontal: primaryPaddingValue * 2),
                          shrinkWrap: true,
                          primary: false,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: guardList.length < 2 ? 1 : 2, mainAxisSpacing: primaryPaddingValue, crossAxisSpacing: primaryPaddingValue, childAspectRatio: guardList.length < 2 ? 1.25 : 1),
                          itemBuilder: (context, index) => guardGridTile(
                              context: context,
                              onTap: () {
                                // routeBack(context);
                                selectedGuardsAvatars.contains(guardList[index]["base64photo"])
                                    ? setState(() => selectedGuardsAvatars.remove(guardList[index]["base64photo"]))
                                    : setState(() => selectedGuardsAvatars.add(guardList[index]["base64photo"]));
                              },
                              enabled: selectedGuardsAvatars.contains(guardList[index]["base64photo"]),
                              name: guardList[index]["name"],
                              photo: guardList[index]["base64photo"])),
                      duration: const Duration(milliseconds: 400),
                      crossFadeState: guardList.isEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond),
                  Padding(
                      padding: EdgeInsets.fromLTRB(primaryPaddingValue * 2, primaryPaddingValue * 1.5, primaryPaddingValue * 2, primaryPaddingValue),
                      child: primaryButton(
                          icon: Icons.refresh_rounded,
                          primary: false,
                          context: context,
                          title: i18n_switchProfile(isBN),
                          onTap: () async {
                            final pref = await SharedPreferences.getInstance();
                            pref.setStringList("selectedGuardsAvatars", selectedGuardsAvatars);
                            routeNoBack(context, const Home());
                          })),
                  Divider(color: primaryColor, indent: primaryPaddingValue * 2, endIndent: primaryPaddingValue * 2),
                  Padding(
                      padding: EdgeInsets.fromLTRB(primaryPaddingValue * 2, primaryPaddingValue, primaryPaddingValue * 2, 0),
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
