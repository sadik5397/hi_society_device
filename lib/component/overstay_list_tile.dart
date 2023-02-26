import 'package:flutter/material.dart';
import 'package:hi_society_device/api/i18n.dart';
import 'package:hi_society_device/component/flat_avatar.dart';

import '../theme/border_radius.dart';
import '../theme/colors.dart';
import '../theme/padding_margin.dart';

Container overstayRequestListTile(
    {required BuildContext context, required String photo, bool isBN = false, required String title, required String eta, String? guestOf, required String flat, double? bottomPadding}) {
  return Container(
      padding: primaryPadding,
      decoration: BoxDecoration(color: trueWhite, borderRadius: primaryBorderRadius),
      margin: EdgeInsets.only(bottom: bottomPadding ?? primaryPaddingValue * 1.5),
      child: Row(children: [
        intercomAvatar(context: context, photo: photo, size: 100),
        Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(title, style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w600, color: primaryColor)),
          SizedBox(height: primaryPaddingValue / 4),
          Row(children: [
            Text(i18n_residentOf(isBN), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.normal, color: primaryBlack)),
            Text(flat, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: trueRed))
          ]),
          SizedBox(height: primaryPaddingValue / 4),
          Row(children: [
            Text(i18n_eta(isBN), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.normal, color: primaryBlack)),
            Text(eta, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: trueRed))
          ])
        ]))
      ]));
}
