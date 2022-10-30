import 'package:flutter/material.dart';
import '../theme/border_radius.dart';
import '../theme/colors.dart';
import '../theme/padding_margin.dart';
import '../theme/text_style.dart';

ElevatedButton primaryButton({required BuildContext context, required String title, required VoidCallback onTap, bool primary = true}) {
  return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
          backgroundColor: primary ? trueWhite : primaryColor,
          fixedSize: const Size(double.maxFinite, 64),
          textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color: !primary ? trueWhite : primaryColor, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(side: BorderSide(color: trueWhite, width: 2), borderRadius: primaryBorderRadius)),
      child: Text(title.toUpperCase()));
}
