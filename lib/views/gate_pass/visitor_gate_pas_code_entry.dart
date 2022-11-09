import 'package:flutter/material.dart';
import 'package:hi_society_device/component/button.dart';
import 'package:hi_society_device/component/page_navigation.dart';
import 'package:hi_society_device/component/text_field.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import 'package:hi_society_device/views/gate_pass/scan_gate_pass_qr.dart';
import 'package:hi_society_device/views/gate_pass/verify_gate_pass.dart';
import '../../component/app_bar.dart';
import '../../component/snack_bar.dart';

class VisitorGatePassCodeEntry extends StatefulWidget {
  const VisitorGatePassCodeEntry({Key? key}) : super(key: key);

  @override
  State<VisitorGatePassCodeEntry> createState() => _VisitorGatePassCodeEntryState();
}

class _VisitorGatePassCodeEntryState extends State<VisitorGatePassCodeEntry> {
  //Variables
  TextEditingController gatePassCodeController = TextEditingController();
  bool codeEmpty = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: primaryAppBar(context: context, title: "Digital Gate Pass"),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          primaryTextField(
              autoFocus: true,
              onChanged: (value) => setState(() => codeEmpty = value.isEmpty),
              hintText: "XXXXX",
              context: context,
              labelText: "Enter Digital Gate Pass Code",
              controller: gatePassCodeController,
              hasSubmitButton: true,
              textCapitalization: TextCapitalization.characters,
              onFieldSubmitted: (value) => (value.isNotEmpty) ? route(context, VerifyGatePass(gatePassCode: value)) : showSnackBar(context: context, label: "Gate Pass ID Mustn't be Empty")),
          Container(
              margin: EdgeInsets.only(top: primaryPaddingValue * 2),
              width: MediaQuery.of(context).size.width / 2,
              child: primaryButton(
                  context: context,
                  title: (codeEmpty) ? "Or, Scan QR" : "Submit",
                  icon: (codeEmpty) ? Icons.qr_code_rounded : null,
                  onTap: () => (codeEmpty) ? route(context, const ScanGatePassQR()) : route(context, VerifyGatePass(gatePassCode: gatePassCodeController.text))))
        ]));
  }
}
