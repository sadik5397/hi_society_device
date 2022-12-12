import 'package:flutter/material.dart';
import 'package:hi_society_device/api/i18n.dart';
import 'package:hi_society_device/component/button.dart';
import 'package:hi_society_device/component/page_navigation.dart';
import 'package:hi_society_device/component/text_field.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import 'package:hi_society_device/views/gate_pass/scan_gate_pass_qr.dart';
import 'package:hi_society_device/views/gate_pass/verify_gate_pass.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool isBN = false;

  //Functions
  defaultInit() async {
    final pref = await SharedPreferences.getInstance();
    setState(() => isBN = pref.getBool("isBN") ?? false);
  }

//Initiate
  @override
  void initState() {
    super.initState();
    defaultInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: primaryAppBar(context: context, title: i18n_digitalGatePass(isBN)),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          primaryTextField(
              autoFocus: true,
              onChanged: (value) => setState(() => codeEmpty = value.isEmpty),
              hintText: "XXXXX",
              context: context,
              labelText: i18n_enterGatePass(isBN),
              controller: gatePassCodeController,
              hasSubmitButton: true,
              textCapitalization: TextCapitalization.characters,
              onFieldSubmitted: (value) => (value.isNotEmpty) ? route(context, VerifyGatePass(gatePassCode: value)) : showSnackBar(context: context, label: i18n_gatePassNoEmpty(isBN))),
          Container(
              margin: EdgeInsets.only(top: primaryPaddingValue * 2),
              width: MediaQuery.of(context).size.width / 2,
              child: primaryButton(
                  context: context,
                  title: (codeEmpty) ? i18n_orScanQr(isBN) : i18n_submit(isBN),
                  icon: (codeEmpty) ? Icons.qr_code_rounded : null,
                  onTap: () => (codeEmpty) ? route(context, const ScanGatePassQR()) : route(context, VerifyGatePass(gatePassCode: gatePassCodeController.text))))
        ]));
  }
}
