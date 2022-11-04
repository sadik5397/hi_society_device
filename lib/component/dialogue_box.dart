// ignore_for_file: use_build_context_synchronously
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hi_society_device/component/button.dart';
import 'package:hi_society_device/component/guard_guard_tile.dart';
import 'package:hi_society_device/component/page_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/border_radius.dart';
import '../theme/colors.dart';
import '../theme/padding_margin.dart';
import '../views/auth/sign_in.dart';

Scaffold switchGuardUser({required BuildContext context}) {
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
                  child: Text("Tap to switch Guard profile", textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: primaryTitleColor, fontWeight: FontWeight.bold)),
                ),
                GridView.builder(
                    itemCount: 2,
                    shrinkWrap: true,
                    primary: false,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: primaryPaddingValue, crossAxisSpacing: primaryPaddingValue),
                    itemBuilder: (context, index) => guardGridTile(context: context, onTap: () => routeBack(context), name: "Samiul Alam Kafi", photo: "https://picsum.photos/200/300?random=$index")),
                Padding(
                    padding: EdgeInsets.fromLTRB(primaryPaddingValue * 2, primaryPaddingValue * 2, primaryPaddingValue * 2, primaryPaddingValue),
                    child: primaryButton(
                        icon: Icons.lock_clock_rounded,
                        primary: false,
                        context: context,
                        title: "DEACTIVATE DEVICE",
                        onTap: () async {
                          final pref = await SharedPreferences.getInstance();
                          await pref.clear();
                          route(context, const SignIn());
                        }))
              ]))));
}
