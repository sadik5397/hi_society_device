import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import '../theme/border_radius.dart';
import '../theme/colors.dart';
import '../theme/padding_margin.dart';

Container primaryDropdown({required BuildContext context, String? key, required String title, required List<String> options, required dynamic value, required void Function(Object? value) onChanged}) {
  return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: trueWhite, width: 2)),
      margin: EdgeInsets.fromLTRB(primaryPaddingValue * 3, 0, primaryPaddingValue * 3, primaryPaddingValue * 2),
      child: Container(
          height: 96,
          decoration: BoxDecoration(borderRadius: primaryBorderRadius, color: trueWhite, border: Border.all(color: primaryBackgroundColor, width: 2)),
          padding: EdgeInsets.all(primaryPaddingValue / 4),
          alignment: Alignment.center,
          child: DropdownButton2(
            underline: const SizedBox(),
            iconEnabledColor: primaryBlack.withOpacity(.5),
            buttonElevation: 0,
            dropdownElevation: 1,
            selectedItemHighlightColor: primaryColorOf,
            isExpanded: true,
            enableFeedback: true,
            buttonPadding: EdgeInsets.only(left: primaryPaddingValue, right: primaryPaddingValue),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: primaryGrey, fontWeight: FontWeight.w500),
            // customItemsHeights: List.generate(options.length, (index) => 72),
            // itemPadding: primaryPadding*2,
            dropdownPadding: EdgeInsets.zero,
            dropdownDecoration: BoxDecoration(borderRadius: primaryBorderRadius, color: trueWhite),
            hint: SelectableText(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: primaryBlack, fontWeight: FontWeight.w500)),
            items: options
                .map((item) => DropdownMenuItem<String>(value: item, child: Column(
                  children: [
                    Expanded(child: Center(child: Text(item, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: primaryBlack, fontWeight: FontWeight.w500)))),
                    Divider(color: primaryGrey,indent: 0,endIndent: 0,height: 1,thickness: .5,)
                  ],
                )))
                .toList(),
            selectedItemBuilder: (context) => List.generate(
                options.length,
                (index) => Align(
                    alignment: const Alignment(-1, 0),
                    child: Text("$key${key != null ? ': ' : null}${options[index]}", style: Theme.of(context).textTheme.titleLarge?.copyWith(color: primaryBlack, fontWeight: FontWeight.w500)))),
            value: value,
            onChanged: onChanged,
            buttonWidth: double.maxFinite,
          )));
}
