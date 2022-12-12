import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hi_society_device/api/i18n.dart';

import '../theme/border_radius.dart';
import '../theme/colors.dart';
import '../theme/padding_margin.dart';

Container flatAvatar({required BuildContext context, required String label, bool isBN = false}) {
  return Container(
      margin: EdgeInsets.only(right: primaryPaddingValue),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: const Color(0xFF3498DB).withOpacity(.3), borderRadius: halfOfPrimaryBorderRadius),
      height: 88,
      width: 88,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(i18n_flat(isBN), style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: primaryBlack)),
          Text(label, style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, color: primaryBlack)),
        ],
      ));
}

Container utilityAvatar({required BuildContext context, String? photo, required String type, double? size}) {
  return Container(
      margin: EdgeInsets.only(right: primaryPaddingValue),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: const Color(0xFF3498DB).withOpacity(.3), borderRadius: halfOfPrimaryBorderRadius, image: photo != null ? DecorationImage(image: CachedNetworkImageProvider(photo)) : null),
      height: size ?? 88,
      width: size ?? 88,
      child: photo == null ? Icon(Icons.construction, color: primaryTitleColor, size: 36) : null);
}
