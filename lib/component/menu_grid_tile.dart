import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hi_society_device/component/page_navigation.dart';
import 'package:hi_society_device/component/snack_bar.dart';
import 'package:hi_society_device/theme/colors.dart';
import '../theme/padding_margin.dart';

Widget menuGridTile({required String title, required String assetImage, Widget? toPage, required BuildContext context}) {
  return Expanded(
    child: InkWell(
      onTap: () => (toPage == null) ? showSnackBar(context: context, label: "Not Implemented Yet") : route(context, toPage),
      child: Container(
          padding: primaryPadding*1.5,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: trueWhite.withOpacity(.1), border: Border.all(color: trueWhite, width: 3, strokeAlign: StrokeAlign.center)),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            CachedNetworkImage(imageUrl: "https://sadik.work/_/hi_society_app_assets/menu/$assetImage.png", height: 72, fit: BoxFit.fitHeight),
            SizedBox(height: primaryPaddingValue/2),
            Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold))
          ])),
    ),
  );
}
