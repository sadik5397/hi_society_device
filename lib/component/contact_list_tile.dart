import 'package:flutter/material.dart';
import 'package:hi_society_device/component/flat_avatar.dart';

import '../theme/border_radius.dart';
import '../theme/colors.dart';
import '../theme/padding_margin.dart';

Padding contactListTile({required VoidCallback onTap, bool isBN = false, required BuildContext context, required String title, required String subtitle, required String flat, double? bottomPadding}) {
  return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding ?? primaryPaddingValue * 1.5),
      child: Material(
          borderRadius: primaryBorderRadius,
          color: trueWhite,
          child: InkWell(
              borderRadius: primaryBorderRadius,
              splashColor: trueBlack.withOpacity(.1),
              onTap: onTap,
              child: Container(
                  padding: primaryPadding,
                  child: Row(children: [
                    flatAvatar(context: context, label: flat, isBN: isBN),
                    Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(title, style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w600, color: primaryColor)),
                      SizedBox(height: primaryPaddingValue / 4),
                      Text(subtitle, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.normal, color: primaryBlack))
                    ])),
                    IconButton(icon: const Icon(Icons.call_rounded, size: 36), color: primaryTitleColor, onPressed: onTap)
                  ])))));
}
