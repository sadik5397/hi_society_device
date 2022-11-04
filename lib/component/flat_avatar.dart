import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/border_radius.dart';
import '../theme/colors.dart';
import '../theme/padding_margin.dart';

Container flatAvatar({required BuildContext context, required String label}) {
  return Container(
      margin: EdgeInsets.only(right: primaryPaddingValue),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: const Color(0xFF3498DB).withOpacity(.3), borderRadius: halfOfPrimaryBorderRadius),
      height: 88,
      width: 88,
      child: Text(label, style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, color: primaryBlack)));
}

Container utilityAvatar({required BuildContext context, String? photo, required String type}) {
  return Container(
      margin: EdgeInsets.only(right: primaryPaddingValue),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: const Color(0xFF3498DB).withOpacity(.3), borderRadius: halfOfPrimaryBorderRadius, image: photo != null ? DecorationImage(image: CachedNetworkImageProvider(photo)) : null),
      height: 88,
      width: 88,
      child: photo == null ? Icon(Icons.construction, color: primaryTitleColor, size: 36) : null);
}