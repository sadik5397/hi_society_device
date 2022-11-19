import 'package:flutter/material.dart';
import 'package:hi_society_device/component/flat_avatar.dart';
import '../theme/border_radius.dart';
import '../theme/colors.dart';
import '../theme/padding_margin.dart';

Container utilityContactListTile({String? photo, required BuildContext context, required String title, required String number, double? bottomPadding}) {
  return Container(
      // padding: primaryPadding,
      decoration: BoxDecoration(color: trueWhite, borderRadius: primaryBorderRadius),
      margin: EdgeInsets.only(bottom: bottomPadding ?? primaryPaddingValue),
      child: Row(children: [
        utilityAvatar(context: context, type: "", photo: photo, size: 72),
        Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(height: primaryPaddingValue / 4),
          Text(title, style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w600, color: primaryColor)),
          SizedBox(height: primaryPaddingValue / 4),
          Row(children: [
            Text("Call: ", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.normal, color: primaryBlack)),
            Text(number, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFFE67E22)))
          ])
        ]))
      ]));
}
