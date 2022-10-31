import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hi_society_device/component/app_bar.dart';
import 'package:hi_society_device/component/basic_list_tile.dart';
import 'package:hi_society_device/component/page_navigation.dart';
import 'package:hi_society_device/theme/colors.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import 'package:hi_society_device/views/residents/assign_flat_resident.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api.dart';
import '../../component/snack_bar.dart';

class BuildingFlatsAndResidents extends StatefulWidget {
  const BuildingFlatsAndResidents({Key? key}) : super(key: key);

  @override
  State<BuildingFlatsAndResidents> createState() => _BuildingFlatsAndResidentsState();
}

class _BuildingFlatsAndResidentsState extends State<BuildingFlatsAndResidents> {
  //Variables
  String accessToken = "", buildingName = "", buildingAddress = "", buildingImg = "", buildingUniqueID = "";
  dynamic apiResult = "";

//APIs
  Future<void> readFlatListOfThisBuilding({required String accessToken}) async {
    try {
      var response = await http.get(Uri.parse("$baseUrl/building/list/flat/by-guard"), headers: authHeader(accessToken));
      Map result = jsonDecode(response.body);
      print(result);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        showSnackBar(context: context, label: result["message"]);
        setState(() => apiResult = result["data"]);
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
    setState(() => accessToken = pref.getString("accessToken")!);
    setState(() => buildingName = pref.getString("buildingName")!);
    setState(() => buildingAddress = pref.getString("buildingAddress")!);
    setState(() => buildingImg = pref.getString("buildingImg")!);
    setState(() => buildingUniqueID = pref.getString("buildingUniqueID")!);
    readFlatListOfThisBuilding(accessToken: accessToken);
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
        appBar: primaryAppBar(context: context, title: "Building Flats & Residents"),
        body: ListView(children: [
          Container(
              color: primaryColorOf,
              padding: primaryPadding,
              margin: EdgeInsets.only(bottom: primaryPaddingValue * 2),
              child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                CachedNetworkImage(imageUrl: buildingImg, height: 160, width: 160, fit: BoxFit.cover),
                SizedBox(width: primaryPaddingValue * 1.5),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(buildingName, style: Theme.of(context).textTheme.displaySmall?.copyWith(color: primaryTitleColor, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Text("Building ID: $buildingUniqueID", style: Theme.of(context).textTheme.titleLarge?.copyWith(color: primaryTitleColor, height: 1.5)),
                  Text("Address: $buildingAddress", style: Theme.of(context).textTheme.titleLarge?.copyWith(color: primaryTitleColor)),
                  Text("Chairman: S.a. Sadik", style: Theme.of(context).textTheme.titleLarge?.copyWith(color: primaryTitleColor))
                ])
              ])),
          Padding(
              padding: EdgeInsets.all(primaryPaddingValue * 2),
              child: Column(children: [
                Text("List of Flat Number of this building", style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: trueWhite, fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                Text("Tap to assign resident(s)", style: Theme.of(context).textTheme.titleMedium)
              ])),
          ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: apiResult.length,
              itemBuilder: (context, index) => basicListTile(
                  context: context,
                  key: "Flat No.  ",
                  title: apiResult[index]["flatName"],
                  onTap: () => route(context, AssignFlatResident(flatID: apiResult[index]["flatId"], flatNo: apiResult[index]["flatName"]))))
        ]));
  }
}
