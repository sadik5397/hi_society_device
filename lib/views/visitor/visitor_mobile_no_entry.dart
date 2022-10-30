import 'package:flutter/material.dart';
import 'package:hi_society_device/component/page_navigation.dart';
import 'package:hi_society_device/component/text_field.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import 'package:hi_society_device/views/visitor/new_visitor_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/api.dart';
import '../../component/app_bar.dart';
import '../../component/header_building_image.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../component/snackbar.dart';
import '../home.dart';

class VisitorMobileNoEntry extends StatefulWidget {
  const VisitorMobileNoEntry({Key? key, required this.buildingImg, required this.buildingName, required this.buildingAddress}) : super(key: key);
  final String buildingName, buildingAddress, buildingImg;

  @override
  State<VisitorMobileNoEntry> createState() => _VisitorMobileNoEntryState();
}

class _VisitorMobileNoEntryState extends State<VisitorMobileNoEntry> {
  //Variables
  String accessToken = "";
  dynamic apiResult;
  TextEditingController mobileNumberController = TextEditingController();

  //APIs
  Future<void> sendVisitorsPhoneNumber({required String accessToken, required String mobileNumber, required VoidCallback existingVisitor, required VoidCallback failRoute}) async {
    try {
      var response = await http.post(Uri.parse("$baseUrl/visitor/guard/info?phone=$mobileNumber"), headers: authHeader(accessToken));
      Map result = jsonDecode(response.body);
      print(mobileNumber);
      print(result);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        FocusManager.instance.primaryFocus?.unfocus();
        showSnackBar(context: context, label: result["message"]);
        setState(() => apiResult = result["data"]);
        existingVisitor.call();
      } else {
        showSnackBar(context: context, label: result["message"][0].toString().length == 1 ? result["message"].toString() : result["message"][0].toString());
        failRoute.call();
      }
    } on Exception catch (e) {
      showSnackBar(context: context, label: e.toString());
    }
  }

  Future<void> askForPermissionToEnter({required String accessToken, required String phone, required int flatId}) async {
    try {
      var response = await http.post(Uri.parse("$baseUrl/visitor/guard/access?fid=$flatId&phone=$phone"), headers: authHeader(accessToken));
      Map result = jsonDecode(response.body);
      print(result);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        showSnackBar(context: context, label: result["message"]);
        print(result);
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
          HeaderBuildingImage(buildingAddress: widget.buildingAddress, buildingImage: widget.buildingImg, buildingName: widget.buildingName),
          Expanded(
              child: Container(
                  decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/smart_background.png"), fit: BoxFit.cover, opacity: .4)),
                  child: Center(
                    child: Padding(
                        padding: EdgeInsets.only(top: primaryPaddingValue),
                        child: primaryTextField(
                            autoFocus: true,
                            hintText: "01XXXXXXXXX",
                            keyboardType: TextInputType.number,
                            context: context,
                            labelText: "Please, Enter Your Mobile Number...",
                            controller: mobileNumberController,
                            onFieldSubmitted: (value) async {
                              await sendVisitorsPhoneNumber(
                                accessToken: accessToken,
                                mobileNumber: mobileNumberController.text,
                                existingVisitor: () async => await askForPermissionToEnter(accessToken: accessToken, phone: mobileNumberController.text, flatId: 45), //todo:
                                failRoute: () => route(context, NewVisitorInformation(mobileNumber: mobileNumberController.text)),
                              );
                            })),
                  )))
        ]));
  }
}
