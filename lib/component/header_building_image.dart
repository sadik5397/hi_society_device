import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import 'package:hi_society_device/theme/placeholder.dart';

import '../theme/colors.dart';

class HeaderBuildingImage extends StatefulWidget {
  const HeaderBuildingImage({Key? key, this.flex, this.buildingAddress, this.buildingName, this.buildingImage}) : super(key: key);

  final String? buildingAddress, buildingName, buildingImage;
  final int? flex;

  @override
  State<HeaderBuildingImage> createState() => _HeaderBuildingImageState();
}

class _HeaderBuildingImageState extends State<HeaderBuildingImage> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: widget.flex ?? 1,
        child: Hero(
          tag: "head",
          child: Container(
              width: double.infinity,
              decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: CachedNetworkImageProvider(widget.buildingImage ?? placeholderImage))),
              child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.transparent, Colors.black.withOpacity(.8)], stops: const [0, 1], begin: const AlignmentDirectional(0, -1), end: const AlignmentDirectional(0, 1))),
                  child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
                    Image.asset("assets/icon/icon.png", height: 72),
                    const SizedBox(height: 12),
                    Text(widget.buildingName!, textAlign: TextAlign.center, style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold, color: trueWhite)),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: primaryPaddingValue * 2),
                        child: Text(widget.buildingAddress!, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center))
                  ]))),
        ));
  }
}
