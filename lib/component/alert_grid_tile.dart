import 'package:flutter/material.dart';
import '../theme/border_radius.dart';
import '../theme/colors.dart';
import '../theme/padding_margin.dart';

Material alertGridTile({required BuildContext context, required String label, required VoidCallback onTap}) {
  return Material(
      borderRadius: primaryBorderRadius,
      color: Colors.red,
      child: InkWell(
          borderRadius: primaryBorderRadius,
          onTap: onTap,
          child: Container(
              alignment: Alignment.center,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Image.asset((label == "Fire" || label == "Gas Leak" || label == "Intruder") ? "assets/alert/$label.png" : "assets/alert/Others.png",
                    color: trueBlack, fit: BoxFit.cover, width: MediaQuery.of(context).size.width * .25),
                SizedBox(height: primaryPaddingValue * 2),
                Text(label.toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: trueWhite, fontWeight: FontWeight.bold, fontSize: 28))
              ]))));
}
