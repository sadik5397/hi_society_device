import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hi_society_device/api/i18n.dart';
import 'package:hi_society_device/component/dropdown_button.dart';
import 'package:hi_society_device/component/page_navigation.dart';
import 'package:hi_society_device/component/text_field.dart';
import 'package:hi_society_device/theme/colors.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import 'package:hi_society_device/views/visitor/ask_permission_to_enter.dart';
import 'package:hi_society_device/views/visitor/new_visitor_info.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api.dart';
import '../../api/phone_number_validator.dart';
import '../../component/app_bar.dart';
import '../../component/button.dart';
import '../../component/snack_bar.dart';
import '../gate_pass/scan_gate_pass_qr.dart';
import '../gate_pass/verify_gate_pass.dart';

class VisitorMobileNoEntry extends StatefulWidget {
  const VisitorMobileNoEntry({Key? key}) : super(key: key);

  @override
  State<VisitorMobileNoEntry> createState() => _VisitorMobileNoEntryState();
}

class _VisitorMobileNoEntryState extends State<VisitorMobileNoEntry> {
  //Variables
  String accessToken = "";
  dynamic apiResult;
  TextEditingController mobileNumberController = TextEditingController();
  String? selectedFlat;
  String? selectedRelation;
  List<String> flatList = [];
  String? buildingName, buildingAddress, buildingImg;
  bool isBN = false;
  List<int> flatID = [];
  TextEditingController gatePassCodeController = TextEditingController();
  bool codeEmpty = true;

  //APIs
  Future<void> sendVisitorsPhoneNumber({required String accessToken, required String mobileNumber, required VoidCallback existingVisitor, required VoidCallback newVisitor}) async {
    try {
      var response = await http.post(Uri.parse("$baseUrl/visitor/guard/info?phone=$mobileNumber"), headers: authHeader(accessToken));
      Map result = jsonDecode(response.body);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        FocusManager.instance.primaryFocus?.unfocus();
        if (kDebugMode) showSnackBar(context: context, label: result["message"]);
        setState(() => apiResult = result["data"]);
        existingVisitor.call();
      } else {
        showSnackBar(context: context, label: result["message"][0].toString().length == 1 ? result["message"].toString() : result["message"][0].toString());
        newVisitor.call();
      }
    } on Exception catch (e) {
      showSnackBar(context: context, label: e.toString());
    }
  }

  Future<void> getFlatList({required String accessToken}) async {
    try {
      var response = await http.get(Uri.parse("$baseUrl/building/list/flat/by-guard"), headers: authHeader(accessToken));
      Map result = jsonDecode(response.body);
      print(result);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        if (kDebugMode) showSnackBar(context: context, label: result["message"]);
        setState(() => apiResult = result["data"]);
        for (int i = 0; i < apiResult.length; i++) {
          setState(() => flatList.add(apiResult[i]["flatName"]));
          setState(() => flatID.add(apiResult[i]["flatId"]));
        }
      } else {
        showSnackBar(context: context, label: result["message"][0].toString().length == 1 ? result["message"].toString() : result["message"][0].toString());
      }
    } on Exception catch (e) {
      showSnackBar(context: context, label: e.toString());
    }
  }

//Functions
  defaultInit() async {
    final pref = await SharedPreferences.getInstance();
    setState(() => accessToken = pref.getString("accessToken").toString());
    setState(() => isBN = pref.getBool("isBN") ?? false);
    setState(() => buildingName = pref.getString("buildingName"));
    setState(() => buildingAddress = pref.getString("buildingAddress"));
    setState(() => buildingImg = pref.getString("buildingImg"));
    getFlatList(accessToken: accessToken);
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
        appBar: primaryAppBar(context: context, title: i18n_visitorManagement(isBN)),
        body: Container(
            decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/smart_background.png"), fit: BoxFit.cover, opacity: .4)),
            child: Column(children: [
              //Visitor
              Expanded(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Row(children: [
                  Expanded(
                      flex: 3,
                      child: primaryDropdown(
                          paddingRight: 0, context: context, title: i18n_flat(isBN), options: flatList, value: selectedFlat, onChanged: (value) => setState(() => selectedFlat = value.toString()))),
                  Expanded(
                      flex: 7,
                      child: primaryTextField(
                          leftPadding: primaryPaddingValue,
                          autoFocus: true,
                          hintText: "01XXXXXXXXX",
                          keyboardType: TextInputType.number,
                          context: context,
                          labelText: "${i18n_enterMobile(isBN)}...",
                          controller: mobileNumberController,
                          textCapitalization: TextCapitalization.characters,
                          onFieldSubmitted: (value) async {
                            bool valid = true;
                            valid = await validatePhoneNumber(mobileNumberController.text);
                            !valid
                                ? showSnackBar(context: context, label: i18n_invalidPhone(isBN))
                                : (selectedFlat != null)
                                    ? await sendVisitorsPhoneNumber(
                                        accessToken: accessToken,
                                        mobileNumber: mobileNumberController.text,
                                        existingVisitor: () => route(
                                            context,
                                            AskPermissionToEnter(
                                                flatID: flatID[flatList.indexOf(selectedFlat ?? "")],
                                                mobileNumber: mobileNumberController.text,
                                                visitorName: apiResult["name"],
                                                visitorPhoto: apiResult["photo"])),
                                        newVisitor: () => route(context, NewVisitorInformation(selectedFlat: selectedFlat.toString(), mobileNumber: mobileNumberController.text)))
                                    : showSnackBar(context: context, label: i18n_selectFlat(isBN));
                          }))
                ]),
                Container(
                    // margin: EdgeInsets.only(top: primaryPaddingValue * 2),
                    width: MediaQuery.of(context).size.width / 2,
                    child: primaryButton(
                        context: context,
                        title: i18n_submit(isBN),
                        onTap: () async {
                          bool valid = true;
                          valid = await validatePhoneNumber(mobileNumberController.text);
                          !valid
                              ? showSnackBar(context: context, label: i18n_invalidPhone(isBN))
                              : (selectedFlat != null)
                                  ? await sendVisitorsPhoneNumber(
                                      accessToken: accessToken,
                                      mobileNumber: mobileNumberController.text,
                                      existingVisitor: () => route(
                                          context,
                                          AskPermissionToEnter(
                                              flatID: flatID[flatList.indexOf(selectedFlat ?? "")], mobileNumber: mobileNumberController.text, visitorName: apiResult["name"], visitorPhoto: apiResult["photo"])),
                                      newVisitor: () => route(context, NewVisitorInformation(selectedFlat: selectedFlat.toString(), mobileNumber: mobileNumberController.text)))
                                  : showSnackBar(context: context, label: i18n_selectFlat(isBN));
                        }))
              ])),
              //Divider
              Divider(color: trueWhite, thickness: 2, height: 4, indent: primaryPaddingValue, endIndent: primaryPaddingValue),
              Divider(color: trueWhite, thickness: 2, height: 4, indent: primaryPaddingValue, endIndent: primaryPaddingValue),
              //GatePass
              Expanded(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                primaryTextField(
                    // autoFocus: true,
                    onChanged: (value) => setState(() => codeEmpty = value.isEmpty),
                    hintText: "XXXXX",
                    context: context,
                    labelText: i18n_enterGatePass(isBN),
                    controller: gatePassCodeController,
                    hasSubmitButton: true,
                    textCapitalization: TextCapitalization.characters,
                    onFieldSubmitted: (value) => (value.isNotEmpty) ? route(context, VerifyGatePass(gatePassCode: value)) : showSnackBar(context: context, label: i18n_gatePassNoEmpty(isBN))),
                Container(
                    // margin: EdgeInsets.only(top: primaryPaddingValue * 2),
                    width: MediaQuery.of(context).size.width / 2,
                    child: primaryButton(
                        context: context,
                        title: (codeEmpty) ? i18n_orScanQr(isBN) : i18n_submit(isBN),
                        icon: (codeEmpty) ? Icons.qr_code_rounded : null,
                        onTap: () => (codeEmpty) ? route(context, const ScanGatePassQR()) : route(context, VerifyGatePass(gatePassCode: gatePassCodeController.text))))
              ]))
            ])));
  }
}
