import 'package:flutter/material.dart';
import 'package:hi_society_device/api/i18n.dart';
import 'package:hi_society_device/component/flat_avatar.dart';

import '../theme/colors.dart';
import '../theme/padding_margin.dart';

ListTile basicListTile({required BuildContext context, bool isBN = false, required String title, String? photo, String? subTitle, String? key, VoidCallback? onTap, bool isVerified = false}) {
  return ListTile(
      visualDensity: VisualDensity.standard,
      tileColor: trueWhite,
      enableFeedback: true,
      dense: false,
      // leading: photo == null ? null : Padding(padding: EdgeInsets.only(bottom: primaryPaddingValue), child: intercomAvatar(context: context, photo: photo, size: 48)),
      subtitle: (subTitle != null) ? Text("${i18n_takenBy(isBN)} $subTitle", style: Theme.of(context).textTheme.titleLarge?.copyWith(color: trueBlack, fontWeight: FontWeight.w400)) : null,
      trailing: isVerified
          // ? CircleAvatar(backgroundColor: primaryColor, child: const Icon(Icons.download_done_rounded, color: Colors.white))
          ? intercomAvatar(context: context, photo: photo, size: 60, rightPadding: 0)
          : const Icon(Icons.arrow_forward_ios_rounded, size: 40, color: Colors.black38),
      title: Row(children: [
        Text(key ?? "", style: Theme.of(context).textTheme.displaySmall?.copyWith(color: isVerified ? primaryColor : trueBlack, fontWeight: FontWeight.w300)),
        if (key != null) SizedBox(width: primaryPaddingValue),
        Text(title, style: Theme.of(context).textTheme.displaySmall?.copyWith(color: isVerified ? primaryColor : trueBlack, fontWeight: FontWeight.w500))
      ]),
      contentPadding: EdgeInsets.all(primaryPaddingValue * 2),
      onTap: onTap);
}
