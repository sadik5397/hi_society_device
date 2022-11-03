import 'package:flutter/material.dart';
import 'package:hi_society_device/component/dropdown_button.dart';
import 'package:hi_society_device/component/page_navigation.dart';
import 'package:hi_society_device/component/text_field.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import 'package:hi_society_device/views/visitor/ask_permission_to_enter.dart';
import 'package:hi_society_device/views/visitor/new_visitor_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/api.dart';
import '../../component/app_bar.dart';
import '../../component/header_building_image.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../component/snack_bar.dart';
import '../home.dart';

class VisitorGatePassCodeEntry extends StatefulWidget {
  const VisitorGatePassCodeEntry({Key? key, required this.buildingImg, required this.buildingName, required this.buildingAddress}) : super(key: key);
  final String buildingName, buildingAddress, buildingImg;

  @override
  State<VisitorGatePassCodeEntry> createState() => _VisitorGatePassCodeEntryState();
}

class _VisitorGatePassCodeEntryState extends State<VisitorGatePassCodeEntry> {
  //Variables
  String accessToken = "";
  dynamic apiResult;
  TextEditingController gadePassCodeController = TextEditingController();
  String? selectedFlat;
  String? selectedRelation;
  List<String> flatList = [];
  List<int> flatID = [];

  //APIs
  Future<void> sendVisitorsPhoneNumber({required String accessToken, required String mobileNumber, required VoidCallback existingVisitor, required VoidCallback newVisitor}) async {
    try {
      var response = await http.post(Uri.parse("$baseUrl/visitor/guard/info?phone=$mobileNumber"), headers: authHeader(accessToken));
      Map result = jsonDecode(response.body);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        FocusManager.instance.primaryFocus?.unfocus();
        showSnackBar(context: context, label: result["message"]);
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
        showSnackBar(context: context, label: result["message"]);
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
        appBar: primaryAppBar(context: context),
        body: Column(children: [
          Padding(
              padding: EdgeInsets.only(top: primaryPaddingValue),
              child: primaryTextField(
                  autoFocus: true,
                  hintText: "XXXXX",
                  context: context,
                  labelText: " Enter Digital Gate Pass Code",
                  controller: gadePassCodeController,
                  textCapitalization: TextCapitalization.none,
                  onFieldSubmitted: (value) async {
                    (selectedFlat != null)
                        ? await sendVisitorsPhoneNumber(
                            accessToken: accessToken,
                            mobileNumber: gadePassCodeController.text,
                            existingVisitor: () => route(
                                context,
                                AskPermissionToEnter(
                                  flatID: flatID[flatList.indexOf(selectedFlat ?? "")],
                                  mobileNumber: gadePassCodeController.text,
                                  visitorName: apiResult["name"],
                                  visitorPhoto: apiResult["photo"],
                                )),
                            newVisitor: () => route(context, NewVisitorInformation(selectedFlat: selectedFlat.toString(), mobileNumber: gadePassCodeController.text)))
                        : showSnackBar(context: context, label: "Please Select Flat");
                  }))
        ]));
  }
}
