import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:hi_society_device/api/i18n.dart';
import 'package:hi_society_device/component/page_navigation.dart';
import 'package:hi_society_device/theme/padding_margin.dart';

import '../api/api.dart';
import '../theme/colors.dart';
import '../theme/text_style.dart';
import '../views/home.dart';

AppBar primaryAppBar({required BuildContext context, String? title, Widget? prefix, Widget? suffix, bool isBN = false}) => AppBar(
    iconTheme: IconThemeData(color: trueWhite),
    leading: (prefix != null) ? prefix : null,
    title: Text(title ??
        '${i18n_appTitle(isBN)}${baseUrl == "https://dev.hisocietyserver.online" ? " (DEV)" : baseUrl == "https://hisocietyserver.online" ? "" : " (OLD)"}'),
    actions: (suffix != null)
        ? [suffix]
        : [
            IconButton(
                color: trueWhite,
                onPressed: () => route(context, const Home()).then((value) => Phoenix.rebirth(context)),
                icon: Padding(padding: EdgeInsets.symmetric(horizontal: primaryPaddingValue * .6), child: Icon(Icons.home)))
          ]);

// AppBar primaryAppbarWithTabs({required BuildContext context, String? title, required List<String> tabs, TabController? controller, bool isBN = false}) {
//   return AppBar(
//       bottom: TabBar(
//         controller: controller,
//         labelColor: trueWhite,
//         unselectedLabelColor: trueWhite.withOpacity(.75),
//         labelStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color: trueWhite, fontWeight: FontWeight.bold),
//         unselectedLabelStyle: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.normal),
//         indicatorWeight: 5,
//         indicator: BoxDecoration(color: trueBlack.withOpacity(.15), border: Border(bottom: BorderSide(color: trueWhite, width: 5))),
//         enableFeedback: true,
//         padding: EdgeInsets.zero,
//         labelPadding: EdgeInsets.symmetric(horizontal: primaryPaddingValue * 2.5),
//         isScrollable: true,
//         indicatorColor: primaryColor,
//         tabs: List.generate(tabs.length, (index) => Tab(text: tabs[index])),
//       ),
//       title: Text(title ?? i18n_appTitle(isBN)),
//       actions: [
//         IconButton(
//             onPressed: () async {
//               final pref = await SharedPreferences.getInstance();
//               await pref.clear();
//               // ignore: use_build_context_synchronously
//               route(context, const SignIn());
//             },
//             icon: const Icon(Icons.more_vert_rounded))
//       ]);
// }

AppBar blankAppBar({String? title, bool isBN = false}) {
  return AppBar(title: Text(title ?? i18n_appTitle(isBN), style: semiBold20Black), centerTitle: true);
}
