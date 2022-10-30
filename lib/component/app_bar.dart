import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hi_society_device/component/page_navigation.dart';
import 'package:hi_society_device/views/auth/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/colors.dart';
import '../theme/padding_margin.dart';
import '../theme/text_style.dart';

AppBar primaryAppBar({required BuildContext context, String? title}) {
  return AppBar(title: Text(title ?? "Hi Society"), actions: [
    IconButton(
        onPressed: () async {
          final pref = await SharedPreferences.getInstance();
          await pref.clear();
          // ignore: use_build_context_synchronously
          route(context, const SignIn());
        },
        icon: const Icon(Icons.more_vert_rounded))
  ]);
}

AppBar primaryAppbarWithTabs({required BuildContext context, String? title, required List<String> tabs}) {
  return AppBar(
      bottom: TabBar(
        labelColor: primaryColor,
        unselectedLabelColor: primaryBlack.withOpacity(.75),
        labelStyle: semiBold14Blue,
        unselectedLabelStyle: normal14black50,
        enableFeedback: true,
        indicatorColor: primaryColor,
        tabs: List.generate(tabs.length, (index) => Tab(text: tabs[index])),
      ),
      title: Text(title ?? "Hi Society", style: semiBold20Black),
      centerTitle: true,
      actions: [
        if (title != "My Profile")
          Padding(
              padding: EdgeInsets.only(right: primaryPaddingValue),
              child: CircleAvatar(
                  foregroundImage: const CachedNetworkImageProvider("https://yt3.ggpht.com/ytc/AMLnZu8eXeigoNg2-TQSIBGlaFcKx0VPKCt5vXuZC1gAf7A=s900-c-k-c0x00ffffff-no-rj"),
                  radius: 18,
                  child: SizedBox(height: 36, width: 36, child: InkWell(onTap: () {}, borderRadius: BorderRadius.circular(100))))),
      ]);
}

AppBar blankAppBar({String? title}) {
  return AppBar(title: Text(title ?? "Hi Society", style: semiBold20Black), centerTitle: true);
}
