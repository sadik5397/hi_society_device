import 'package:flutter/material.dart';
import 'package:hi_society_device/component/flat_avatar.dart';

import '../theme/border_radius.dart';
import '../theme/colors.dart';
import '../theme/padding_margin.dart';

Container overstayRequestListTile({required BuildContext context, bool isBN = false, required String title, required String eta, String? guestOf, required String flat, double? bottomPadding}) {
  return Container(
      padding: primaryPadding,
      decoration: BoxDecoration(color: trueWhite, borderRadius: primaryBorderRadius),
      margin: EdgeInsets.only(bottom: bottomPadding ?? primaryPaddingValue * 1.5),
      child: Row(children: [
        flatAvatar(context: context, label: flat, isBN: isBN),
        Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(title, style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w600, color: primaryColor)),
          SizedBox(height: primaryPaddingValue / 4),
          Row(children: [
            Text("Expected Arrival Time: ", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.normal, color: primaryBlack)),
            Text(eta, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: trueRed))
          ]),
          if (guestOf != null) SizedBox(height: primaryPaddingValue / 4),
          if (guestOf != null)
            Row(children: [
              Text("Guest of: ", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.normal, color: primaryBlack)),
              Text(guestOf, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: trueRed))
            ])
        ]))
      ]));
}
