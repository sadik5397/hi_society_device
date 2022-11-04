import 'package:flutter/material.dart';
import '../theme/border_radius.dart';
import '../theme/colors.dart';
import '../theme/padding_margin.dart';

Container basic2LineInfoCard({required String key, required String value, required BuildContext context, bool is3 = false}) {
  return Container(
      margin: EdgeInsets.symmetric(horizontal: primaryPaddingValue / 2),
      padding: EdgeInsets.all(primaryPaddingValue),
      decoration: BoxDecoration(color: trueWhite.withOpacity(.1), borderRadius: primaryBorderRadius),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width / (is3 ? 3.5 : 3),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(key, style: Theme.of(context).textTheme.titleMedium),
        Text(value, overflow: TextOverflow.ellipsis, textScaleFactor: .8, style: Theme.of(context).textTheme.displayMedium?.copyWith(color: trueWhite, fontWeight: FontWeight.w600))
      ]));
}
