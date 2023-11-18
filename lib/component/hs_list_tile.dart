import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/border_radius.dart';
import '../theme/colors.dart';
import '../theme/padding_margin.dart';
import '../theme/placeholder.dart';
import '../theme/text_style.dart';

class HSListTileWidget extends StatefulWidget {
  const HSListTileWidget({Key? key, this.type, this.img, this.status, this.qrData, this.value1, this.title, this.value2, this.value3, this.onTap, this.icon, required this.keys}) : super(key: key);
  final String? type, img, title, value1, value2, value3, status, qrData, icon;
  final VoidCallback? onTap;
  final List<String> keys;

  @override
  State<HSListTileWidget> createState() => _HSListTileWidgetState();
}

class _HSListTileWidgetState extends State<HSListTileWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: primaryPaddingValue),
        decoration: BoxDecoration(color: const Color(0xFFE8F5FF), borderRadius: primaryBorderRadius),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                borderRadius: primaryBorderRadius,
                onTap: widget.onTap,
                child: Row(mainAxisSize: MainAxisSize.max, children: [
                  Padding(
                      padding: primaryPadding,
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width / 3.6,
                        decoration:
                            (widget.type == "Visitor") ? BoxDecoration(borderRadius: halfOfPrimaryBorderRadius, image: DecorationImage(image: CachedNetworkImageProvider(widget.img!), fit: BoxFit.cover)) : null,
                        height: 108,
                        child: (widget.type == "Gate Pass" || widget.type == "PickupOTP")
                            ? ClipRRect(borderRadius: halfOfPrimaryBorderRadius, child: const FlutterLogo())
                            : (widget.type == "Delivery")
                                ? Container(
                                    decoration: BoxDecoration(borderRadius: halfOfPrimaryBorderRadius, color: trueWhite),
                                    padding: EdgeInsets.all(primaryPaddingValue * 1.5),
                                    child: CachedNetworkImage(imageUrl: widget.icon!))
                                : null,
                      )),
                  Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, primaryPaddingValue, primaryPaddingValue, primaryPaddingValue),
                      child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(mainAxisSize: MainAxisSize.max, children: [Text('${widget.keys[0]}: ', style: normal12Black50), Text(widget.value1!, style: normal12Black)]),
                        Text(widget.title!, textAlign: TextAlign.start, style: semiBold20Black),
                        Row(mainAxisSize: MainAxisSize.max, children: [Text('${widget.keys[1]}: ', style: normal12Black50), Text(widget.value2!, style: normal12Black)]),
                        Row(mainAxisSize: MainAxisSize.max, children: [Text('${widget.keys[2]}: ', style: normal12Black50), Text(widget.value3!, style: normal12Black)]),
                        Container(
                            width: 100,
                            margin: EdgeInsets.only(top: primaryPaddingValue / 2),
                            padding: EdgeInsets.symmetric(vertical: primaryPaddingValue / 4),
                            decoration: BoxDecoration(color: const Color(0xFF3498DB), borderRadius: quarterOfPrimaryBorderRadius),
                            child: Text(widget.status!.toUpperCase(), textAlign: TextAlign.center, textScaler: TextScaler.linear(.9), style: semiBold12white))
                      ]))
                ]))));
  }
}

class MiniListTileWidget extends StatefulWidget {
  const MiniListTileWidget({Key? key, this.img, this.title, this.flat, this.onTap}) : super(key: key);
  final String? title, flat, img;
  final VoidCallback? onTap;

  @override
  State<MiniListTileWidget> createState() => _MiniListTileWidgetState();
}

class _MiniListTileWidgetState extends State<MiniListTileWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: primaryPaddingValue),
        decoration: BoxDecoration(color: const Color(0xFFE8F5FF), borderRadius: primaryBorderRadius),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                borderRadius: primaryBorderRadius,
                onTap: widget.onTap,
                child: Row(mainAxisSize: MainAxisSize.max, children: [
                  Padding(padding: primaryPadding, child: CircleAvatar(foregroundImage: CachedNetworkImageProvider(widget.img ?? placeholderImage))),
                  Expanded(
                      child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, primaryPaddingValue, primaryPaddingValue, primaryPaddingValue),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(widget.title!, style: semiBold16Black), Text(widget.flat!, style: normal12Black)]))),
                  IconButton(onPressed: () {}, icon: Icon(Icons.call, color: primaryBlack.withOpacity(.85), size: 18)),
                ]))));
  }
}
