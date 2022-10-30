import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/padding_margin.dart';

ListTile basicListTile({required BuildContext context, required String title, String? key, VoidCallback? onTap}) {
  return ListTile(
      visualDensity: VisualDensity.standard,
      tileColor: trueWhite,
      enableFeedback: true,
      dense: false,
      trailing: IconButton(icon: const Icon(Icons.arrow_forward_ios_rounded), onPressed: onTap, color: primaryGrey, iconSize: 40),
      title: Row(children: [
        Text(key ?? "", style: Theme.of(context).textTheme.displaySmall?.copyWith(color: trueBlack, fontWeight: FontWeight.w300)),
        Text(title, style: Theme.of(context).textTheme.displaySmall?.copyWith(color: trueBlack, fontWeight: FontWeight.w500))
      ]),
      contentPadding: EdgeInsets.all(primaryPaddingValue * 2),
      onTap: onTap);
}
