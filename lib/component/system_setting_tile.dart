import 'package:flutter/material.dart';
import '../theme/border_radius.dart';
import '../theme/colors.dart';
import '../theme/padding_margin.dart';

Padding systemSettingTile({required VoidCallback onTap, required BuildContext context, required String title, required IconData icon}) {
  return Padding(
      padding: EdgeInsets.only(bottom: primaryPaddingValue * 1.5),
      child: Material(
          borderRadius: primaryBorderRadius,
          color: trueWhite,
          child: InkWell(
              borderRadius: primaryBorderRadius,
              splashColor: trueBlack.withOpacity(.1),
              onTap: onTap,
              child: Container(
                  padding: primaryPadding.copyWith(left: primaryPaddingValue * 2),
                  child: Row(children: [
                    Expanded(child: Text(title, style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w600, color: primaryColor))),
                    IconButton(icon: Icon(icon, size: 36), color: primaryTitleColor, onPressed: onTap)
                  ])))));
}
