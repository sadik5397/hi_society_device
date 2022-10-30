import 'package:flutter/material.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import '../theme/colors.dart';

showSnackBar({required BuildContext context, String action = "Dismiss", required String label, int seconds = 2, int milliseconds = 0}) {
  final snackBar = SnackBar(
    backgroundColor: trueWhite,
    dismissDirection: DismissDirection.horizontal,
    behavior: SnackBarBehavior.floating,
    duration: Duration(seconds: seconds, milliseconds: milliseconds),
    content: Padding(padding: primaryPadding, child: Text(label, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: trueBlack, fontWeight: FontWeight.w500))),
    action: SnackBarAction(textColor: primaryColor, label: action, onPressed: () => ScaffoldMessenger.of(context).clearSnackBars()),
  );
  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
