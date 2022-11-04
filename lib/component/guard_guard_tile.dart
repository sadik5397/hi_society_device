import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import '../theme/border_radius.dart';
import '../theme/colors.dart';
import '../theme/placeholder.dart';

Widget guardGridTile({required BuildContext context, String? photo, required VoidCallback onTap, required String name}) {
  return ClipRRect(
      borderRadius: primaryBorderRadius,
      child: Stack(alignment: Alignment.center, children: [
        CachedNetworkImage(imageUrl: photo ?? placeholderImage, fit: BoxFit.cover, height: double.maxFinite, width: double.maxFinite),
        Container(color: trueBlack.withOpacity(.5)),
        Padding(padding: primaryPadding, child: Text(name, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center)),
        Material(color: Colors.transparent, child: InkWell(onTap: onTap, child: Container(color: Colors.transparent)))
      ]));
}
