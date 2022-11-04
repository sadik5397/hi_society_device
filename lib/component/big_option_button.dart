import 'package:flutter/material.dart';
import 'package:hi_society_device/component/page_navigation.dart';
import '../theme/border_radius.dart';
import '../theme/colors.dart';
import '../theme/padding_margin.dart';

Padding bigOptionButton({required BuildContext context, required String iconImage, required String label, required Widget toPage}) {
  return Padding(
    padding: primaryPadding,
    child: InkWell(
        onTap: () => route(context, toPage),
        borderRadius: primaryBorderRadius,
        child: Container(
            padding: primaryPadding * 2,
            width: MediaQuery.of(context).size.width / 1.75,
            decoration: BoxDecoration(color: trueWhite.withOpacity(.1), borderRadius: primaryBorderRadius, border: Border.all(color: trueWhite, width: 2)),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Image.asset(iconImage, fit: BoxFit.cover, height: MediaQuery.of(context).size.height / 10),
              SizedBox(height: primaryPaddingValue),
              Text(label, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold))
            ]))),
  );
}
