import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hi_society_device/theme/padding_margin.dart';

import '../theme/border_radius.dart';
import '../theme/colors.dart';

Widget guardGridTile({required BuildContext context, required String photo, required VoidCallback onTap, required bool enabled, required String name}) {
  return ClipRRect(
      borderRadius: primaryBorderRadius,
      child: Stack(alignment: Alignment.center, children: [
        CachedNetworkImage(imageUrl: photo, fit: BoxFit.cover, height: double.maxFinite, width: double.maxFinite),
        // Image.memory(base64Decode(photo), fit: BoxFit.cover, height: double.maxFinite, width: double.maxFinite),
        Container(color: trueBlack.withOpacity(.5)),
        Padding(
            padding: primaryPadding,
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              if (enabled) Icon(Icons.done_outline_rounded, color: trueWhite, size: 64),
              Text(name, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
            ])),
        Material(color: Colors.transparent, child: InkWell(onTap: onTap, child: Container(color: Colors.transparent)))
      ]));
}
