import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import '../theme/border_radius.dart';
import '../theme/colors.dart';
import '../theme/padding_margin.dart';
import '../theme/text_style.dart';

Padding primaryDropdown({required String title, required List<String> options, required dynamic value, required void Function(Object? value) onChanged}) {
  return Padding(
      padding: EdgeInsets.fromLTRB(primaryPaddingValue, 0, primaryPaddingValue, primaryPaddingValue * 1.5),
      child: DropdownButton2(
        underline: const SizedBox(),
        iconEnabledColor: primaryBlack.withOpacity(.5),
        buttonElevation: 0,
        dropdownElevation: 1,
        selectedItemHighlightColor: primaryColorOf,
        isExpanded: true,
        enableFeedback: true,
        buttonPadding: EdgeInsets.only(left: primaryPaddingValue, right: primaryPaddingValue),
        buttonDecoration: BoxDecoration(borderRadius: primaryBorderRadius, color: primaryColorOf),
        dropdownPadding: EdgeInsets.zero,
        dropdownDecoration: BoxDecoration(borderRadius: primaryBorderRadius, color: trueWhite),
        hint: Text('Gender', style: textFieldLabel),
        items: options.map((item) => DropdownMenuItem<String>(value: item, child: Text(item, style: textFieldLabel))).toList(),
        selectedItemBuilder: (context) => List.generate(options.length, (index) => Align(alignment: const Alignment(-1, 0), child: Text("$title: ${options[index]}"))),
        value: value,
        onChanged: onChanged,
        buttonWidth: double.maxFinite,
      ));
}
