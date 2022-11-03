import 'package:flutter/material.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import '../theme/colors.dart';

showSnackBar({VoidCallback? onTap, required BuildContext context, String action = "Dismiss", required String label, int seconds = 2, int milliseconds = 0}) {
  final snackBar = SnackBar(
    backgroundColor: trueWhite,
    dismissDirection: DismissDirection.horizontal,
    behavior: SnackBarBehavior.floating,
    duration: Duration(seconds: seconds, milliseconds: milliseconds),
    content: Padding(padding: primaryPadding, child: Text(label, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: trueBlack, fontWeight: FontWeight.w500))),
      action: SnackBarAction(textColor: trueWhite, label: action, onPressed: () => (action == "Dismiss") ? ScaffoldMessenger.of(context).clearSnackBars() : onTap!.call()));
  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
