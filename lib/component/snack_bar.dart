import 'package:flutter/material.dart';
import 'package:hi_society_device/component/page_navigation.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import '../theme/colors.dart';
import 'package:quickalert/quickalert.dart';

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

showError({required BuildContext context, String action = "OKAY", String? label, String? title, int? seconds, VoidCallback? onConfirmBtnTap}) {
  return QuickAlert.show(
      context: context,
      width: 400,
      onConfirmBtnTap: onConfirmBtnTap,
      type: QuickAlertType.error,
      borderRadius: 16,
      animType: QuickAlertAnimType.slideInUp,
      title: title ?? 'ERROR',
      text: label ?? "Something Went Wrong!",
      confirmBtnText: action,
      backgroundColor: Colors.white,
      titleColor: primaryColor,
      textColor: Colors.black87,
      autoCloseDuration: seconds != null ? Duration(seconds: seconds) : null);
}

showSuccess({required BuildContext context, String action = "OKAY", String? label, String? title, int? seconds, VoidCallback? onTap}) {
  return QuickAlert.show(
      context: context,
      onConfirmBtnTap: onTap,
      width: 400,
      type: QuickAlertType.success,
      borderRadius: 16,
      animType: QuickAlertAnimType.slideInUp,
      title: title ?? 'SUCCESS',
      text: label ?? "Progress Complete",
      confirmBtnText: action,
      backgroundColor: Colors.white,
      titleColor: primaryColor,
      textColor: Colors.black87,
      autoCloseDuration: seconds != null ? Duration(seconds: seconds) : null);
}

showPrompt({required BuildContext context, String action = "YES", String cancel = "NO", String? label, String? title, int? seconds, VoidCallback? onTap}) {
  return QuickAlert.show(
      context: context,
      onConfirmBtnTap: onTap,
      onCancelBtnTap: () => routeBack(context),
      width: 400,
      type: QuickAlertType.warning,
      borderRadius: 16,
      animType: QuickAlertAnimType.slideInUp,
      title: title ?? 'Are You Sure?',
      text: label ?? "Click Yes/No",
      confirmBtnText: action,
      showCancelBtn: true,
      cancelBtnText: cancel,
      backgroundColor: Colors.white,
      titleColor: primaryColor,
      textColor: Colors.black87,
      autoCloseDuration: seconds != null ? Duration(seconds: seconds) : null);
}

showInfo({required BuildContext context, String action = "YES", String cancel = "NO", String? label, String? title, int? seconds, VoidCallback? onTap}) {
  return QuickAlert.show(
      context: context,
      onConfirmBtnTap: onTap,
      onCancelBtnTap: () => routeBack(context),
      width: 400,
      type: QuickAlertType.info,
      borderRadius: 16,
      animType: QuickAlertAnimType.slideInUp,
      title: title ?? 'Attention!',
      text: label ?? "Click Yes/No",
      confirmBtnText: action,
      showCancelBtn: true,
      cancelBtnText: cancel,
      backgroundColor: Colors.white,
      titleColor: primaryColor,
      textColor: Colors.black87,
      autoCloseDuration: seconds != null ? Duration(seconds: seconds) : null);
}
