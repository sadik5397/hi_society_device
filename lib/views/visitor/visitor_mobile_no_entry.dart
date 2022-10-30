import 'package:flutter/material.dart';
import 'package:hi_society_device/component/page_navigation.dart';
import 'package:hi_society_device/component/text_field.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../component/app_bar.dart';
import '../../component/header_building_image.dart';

class VisitorMobileNoEntry extends StatefulWidget {
  const VisitorMobileNoEntry({Key? key, required this.buildingImg, required this.buildingName, required this.buildingAddress}) : super(key: key);
  final String buildingName, buildingAddress, buildingImg;

  @override
  State<VisitorMobileNoEntry> createState() => _VisitorMobileNoEntryState();
}

class _VisitorMobileNoEntryState extends State<VisitorMobileNoEntry> {
  //Variables
  String? accessToken;
  dynamic apiResult;
  TextEditingController mobileNumberController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

//Functions
  defaultInit() async {
    final pref = await SharedPreferences.getInstance();
    setState(() => accessToken = pref.getString("accessToken"));
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) FocusScope.of(context).requestFocus(_focusNode);
    });
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
                            focusNode: _focusNode,
                            autoFocus: true,
                            hintText: "01XXXXXXXXX",
                            keyboardType: TextInputType.number,
                            context: context,
                            labelText: "Please, Enter Your Mobile Number...",
                            controller: mobileNumberController,
                            hasSubmitButton: true,
                            onFieldSubmitted: (value) async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              // await doSignIn(
                              //   email: emailController.text.toLowerCase(),
                              //   password: passwordController.text,
                              //   home: () => route(context, const Home()),
                              // );
                              route(context, widget);
                            })),
                  )))
        ]));
  }
}
