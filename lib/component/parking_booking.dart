import 'package:flutter/material.dart';
import 'package:hi_society_device/component/flat_avatar.dart';
import '../theme/border_radius.dart';
import '../theme/colors.dart';
import '../theme/padding_margin.dart';

Padding parkBookingListTile({required BuildContext context, required String title, required String date, required String time, required String flat, double? bottomPadding}) {
  return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding ?? primaryPaddingValue * 1.5),
      child: Material(
          borderRadius: primaryBorderRadius,
          color: trueWhite,
          child: InkWell(
              borderRadius: primaryBorderRadius,
              splashColor: trueBlack.withOpacity(.1),
              onTap: () {},
              child: Container(
                  padding: primaryPadding,
                  child: Row(children: [
                    flatAvatar(context: context, label: flat),
                    Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(title, style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w600, color: primaryColor)),
                      SizedBox(height: primaryPaddingValue / 4),
                      Row(
                        children: [
                          Text("Date: ", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.normal, color: primaryBlack)),
                          Text(date, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: primaryBlack)),
                          Text("  |  ", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: primaryBlack)),
                          Text("Time: ", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.normal, color: primaryBlack)),
                          Text(time, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: primaryBlack)),
                        ],
                      )
                    ])),
                    IconButton(icon: const Icon(Icons.done_rounded, size: 36), color: primaryTitleColor, onPressed: () {})
                  ])))));
}
