import 'package:flutter/material.dart';
import 'package:hi_society_device/component/button.dart';
import 'package:hi_society_device/component/page_navigation.dart';
import 'package:hi_society_device/component/text_field.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import 'package:hi_society_device/views/delivery/scan_ppl_qr.dart';
import 'package:hi_society_device/views/delivery/verify_ppl.dart';
import 'package:hi_society_device/views/gate_pass/scan_gate_pass_qr.dart';
import 'package:hi_society_device/views/gate_pass/verify_gate_pass.dart';
import '../../component/app_bar.dart';
import '../../component/snack_bar.dart';

class PPLCodeEntry extends StatefulWidget {
  const PPLCodeEntry({Key? key}) : super(key: key);

  @override
  State<PPLCodeEntry> createState() => _PPLCodeEntryState();
}

class _PPLCodeEntryState extends State<PPLCodeEntry> {
  //Variables
  TextEditingController gatePassCodeController = TextEditingController();
  bool codeEmpty = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: primaryAppBar(context: context, title: "Distribute Parcel"),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          primaryTextField(
              autoFocus: true,
              onChanged: (value) => setState(() => codeEmpty = value.isEmpty),
              hintText: "XXXXX",
              context: context,
              labelText: "Enter Pickup Parcel Later OTP Below",
              controller: gatePassCodeController,
              hasSubmitButton: true,
              textCapitalization: TextCapitalization.characters,
              onFieldSubmitted: (value) => (value.isNotEmpty) ? route(context, VerifyPPL(gatePassCode: value)) : showSnackBar(context: context, label: "Gate Pass ID Mustn't be Empty")),
          Container(
              margin: EdgeInsets.only(top: primaryPaddingValue * 2),
              width: MediaQuery.of(context).size.width / 2,
              child: primaryButton(
                  context: context,
                  title: (codeEmpty) ? "Or, Scan QR" : "Submit",
                  icon: (codeEmpty) ? Icons.qr_code_rounded : null,
                  onTap: () => (codeEmpty) ? route(context, const ScanPPLQR()) : route(context, VerifyPPL(gatePassCode: gatePassCodeController.text))))
        ]));
  }
}
