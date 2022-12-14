import 'package:flutter/material.dart';
import 'package:hi_society_device/component/flat_avatar.dart';
import 'package:hi_society_device/theme/border_radius.dart';
import 'package:hi_society_device/theme/colors.dart';
import 'package:hi_society_device/theme/padding_margin.dart';

Container parkStatusGridTile({bool isBN = false, required BuildContext context, String guestName = "N/A", bool isFree = true, required int index, String? guestOf}) {
  return Container(
      alignment: Alignment.center,
      padding: primaryPadding,
      decoration: BoxDecoration(color: trueWhite, borderRadius: primaryBorderRadius),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        flatAvatar(context: context, isBN: isBN, label: index.toString()),
        SizedBox(height: primaryPaddingValue),
        if (isFree) Text("FREE", style: Theme.of(context).textTheme.displayLarge?.copyWith(color: allowedColor, fontWeight: FontWeight.bold)),
        if (!isFree) Text(guestName, style: Theme.of(context).textTheme.displaySmall?.copyWith(color: primaryColorDark, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        if (guestOf != null) Text("Guest of $guestOf", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: primaryTitleColor), textAlign: TextAlign.center)
      ]));
}
