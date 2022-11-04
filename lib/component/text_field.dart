import 'package:flutter/material.dart';
import '../theme/border_radius.dart';
import '../theme/colors.dart';
import '../theme/padding_margin.dart';

Container primaryTextField(
    {required BuildContext context,
    required String labelText,
    bool isPassword = false,
    double? bottomPadding,
    double? leftPadding,
    double? rightPadding,
    bool isDate = false,
    bool hasSubmitButton = false,
    TextInputType keyboardType = TextInputType.text,
    String hintText = "Type Here",
    required TextEditingController controller,
    bool autoFocus = false,
    FocusNode? focusNode,
    String errorText = "This field should not be empty",
    bool required = false,
    bool showPassword = false,
    TextCapitalization textCapitalization = TextCapitalization.sentences,
    VoidCallback? showPasswordPressed,
    VoidCallback? onFieldSubmittedAlternate,
    Function(String value)? onFieldSubmitted,
    Function(String value)? onChanged,
    bool isDisable = false}) {
  return Container(
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: trueWhite, width: 2)),
    margin: EdgeInsets.fromLTRB(leftPadding ?? primaryPaddingValue * 3, 0, rightPadding ?? primaryPaddingValue * 3, bottomPadding ?? primaryPaddingValue * 2),
    child: Container(
        decoration: BoxDecoration(borderRadius: primaryBorderRadius, color: trueWhite, border: Border.all(color: primaryBackgroundColor, width: 2)),
        padding: EdgeInsets.all(primaryPaddingValue / 4),
        child: TextFormField(
            onChanged: onChanged,
            textAlign: TextAlign.center,
            focusNode: focusNode,
            keyboardAppearance: Brightness.dark,
            onFieldSubmitted: onFieldSubmitted,
            keyboardType: keyboardType,
            textCapitalization: textCapitalization,
            obscureText: (isPassword) ? !showPassword : false,
            controller: controller,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: primaryTitleColor, fontWeight: FontWeight.w500, fontSize: 30, height: 1.4),
            autofocus: autoFocus,
            enabled: !isDisable,
            validator: (value) => required
                ? value == null || value.isEmpty
                    ? errorText
                    : null
                : null,
            decoration: InputDecoration(
                border: InputBorder.none,
                floatingLabelAlignment: FloatingLabelAlignment.center,
                labelText: labelText,
                isDense: true,
                alignLabelWithHint: false,
                contentPadding: EdgeInsets.all(primaryPaddingValue),
                labelStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color: primaryGrey, fontWeight: FontWeight.w500),
                hintText: hintText,
                hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: primaryGrey, fontWeight: FontWeight.w300, fontSize: 26),
                floatingLabelStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color: primaryColor, fontWeight: FontWeight.w500),
                suffixIconColor: primaryBlack,
                // ignore: dead_code
                prefix: (isPassword || isDate || hasSubmitButton || true) ? const SizedBox(width: 54) : null,
                //todo: controller.text.isNotEmpty (state is not updating)
                suffixIcon: (isPassword)
                    ? IconButton(onPressed: showPasswordPressed, icon: Icon((!showPassword) ? Icons.visibility_outlined : Icons.visibility_off_outlined), iconSize: 18, color: primaryBlack.withOpacity(.5))
                    : (isDate)
                        ? IconButton(onPressed: () {}, icon: const Icon(Icons.calendar_month_sharp), iconSize: 18, color: primaryBlack.withOpacity(.5))
                        : (hasSubmitButton)
                            ? IconButton(onPressed: onFieldSubmittedAlternate, icon: const Icon(Icons.arrow_downward_sharp), iconSize: 18, color: primaryBlack.withOpacity(.5))
                            : (true) //todo: controller.text.isNotEmpty (state is not updating)
                                ? IconButton(onPressed: () => controller.clear(), icon: const Icon(Icons.cancel_outlined), iconSize: 18, color: primaryBlack.withOpacity(.5))
                                // ignore: dead_code
                                : null))),
  );
}
