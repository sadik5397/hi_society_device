import 'package:flutter/material.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import '../theme/border_radius.dart';
import '../theme/colors.dart';

ElevatedButton primaryButton({required BuildContext context, required String title, required VoidCallback onTap, bool primary = true, IconData? icon}) {
  return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
          foregroundColor: primary ? primaryColor : trueWhite,
          backgroundColor: primary ? trueWhite : primaryColor,
          fixedSize: const Size(double.maxFinite, 64),
          textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color: !primary ? trueWhite : primaryColor, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(side: BorderSide(color: trueWhite, width: 2), borderRadius: primaryBorderRadius)),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [if (icon != null) Icon(icon), if (icon != null) SizedBox(width: primaryPaddingValue), Text(title.toUpperCase())]));
}
