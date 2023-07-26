import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hi_society_device/api/i18n.dart';
import 'package:hi_society_device/component/app_bar.dart';
import 'package:hi_society_device/component/contact_list_tile.dart';
import 'package:hi_society_device/component/page_navigation.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api.dart';
import '../../component/no_data.dart';
import '../../component/snack_bar.dart';
import '../../theme/placeholder.dart';
import 'call_new.dart';

class ContactList extends StatefulWidget {
  const ContactList({Key? key}) : super(key: key);

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  //variable
  TextEditingController searchController = TextEditingController();
  String accessToken = "";
  bool isBN = false;
  List manager = [];
  List committeeHeads = [];
  List committeeMembers = [];
  List residentHeads = [];
  List residents = [];
  List flatOwners = [];
  List allPeople = [];
  int userId = 0;
  dynamic myInfo = {};
  List residentHeadsWithFlatName = [];

  //API
  Future<void> getMyInfo({required String accessToken}) async {
    if (kDebugMode) print("---------getMyInfo---------");
    try {
      var response = await http.post(Uri.parse("$baseUrl/user/me"), headers: authHeader(accessToken));
      Map result = jsonDecode(response.body);
      if (kDebugMode) print(result);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        if (kDebugMode) showSnackBar(context: context, label: result["message"]);
        setState(() => myInfo = result["data"]);
        setState(() => userId = myInfo["userId"]);
      } else {
        showSnackBar(context: context, label: result["message"][0].toString().length == 1 ? result["message"].toString() : result["message"][0].toString());
      }
    } on Exception catch (e) {
      showSnackBar(context: context, label: e.toString());
    }
  }

  Future<void> getPeopleList({required String accessToken}) async {
    try {
      var response = await http.post(Uri.parse("$baseUrl/intercom/can-call"), headers: authHeader(accessToken));
      Map result = jsonDecode(response.body);
      print(result);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        if (kDebugMode) showSnackBar(context: context, label: result["message"]);
        setState(() => manager = result["data"]["manager"]);
        setState(() => committeeHeads = result["data"]["committeeHeads"]);
        setState(() => committeeMembers = result["data"]["committeeMembers"]);
        setState(() => residentHeads = result["data"]["resident_heads"]);
        setState(() => residents = result["data"]["residents_only"]);
        setState(() => flatOwners = result["data"]["flatOwners"]);
        setState(() => allPeople = [manager, committeeHeads, committeeMembers, residents, flatOwners].expand((x) => x).toList());
      } else {
        showSnackBar(context: context, label: result["message"][0].toString().length == 1 ? result["message"].toString() : result["message"][0].toString());
      }
    } on Exception catch (e) {
      showSnackBar(context: context, label: e.toString());
    }
  }

  Future<void> getResidentHeadListWithFlatName({required String accessToken}) async {
    try {
      var response = await http.get(Uri.parse("$baseUrl/building/list/flat/by-guard"), headers: authHeader(accessToken));
      Map result = jsonDecode(response.body);
      print(result);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        if (kDebugMode) showSnackBar(context: context, label: result["message"]);
        List allFlats = result["data"];
        for (int i = 0; i < allFlats.length; i++) {
          if (allFlats[i]["residentHead"] != null) setState(() => residentHeadsWithFlatName.add(allFlats[i]));
        }
      } else {
        showSnackBar(context: context, label: result["message"][0].toString().length == 1 ? result["message"].toString() : result["message"][0].toString());
      }
    } on Exception catch (e) {
      showSnackBar(context: context, label: e.toString());
    }
  }

  Future<void> createCall({required String accessToken, required int receiver, required String receiverImg, required String receiverName}) async {
    if (userId == receiver.toString()) {
      showSnackBar(context: context, label: "Calling yourself is not allowed");
    } else {
      Permission.camera.request().then((value) async {
        print(value.toString());
        Permission.microphone.request().then((value) async {
          print(value.toString());
          route(context, CallNew(userId: userId, callID: '${userId}_hiSociety_$receiver', receiverId: receiver, receiverImage: receiverImg, receiverName: receiverName, intercomHistoryId: 0));
        });
      });
    }
  }

  //Functions
  defaultInit() async {
    final pref = await SharedPreferences.getInstance();
    setState(() => accessToken = pref.getString("accessToken").toString());
    setState(() => isBN = pref.getBool("isBN") ?? false);
    await getMyInfo(accessToken: accessToken);
    await getResidentHeadListWithFlatName(accessToken: accessToken);
    await getPeopleList(accessToken: accessToken);
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
        appBar: primaryAppBar(context: context, title: i18n_intercom(isBN)),
        body: Column(children: [
          Expanded(
              child: (allPeople.isEmpty)
                  ? noData()
                  : ListView(shrinkWrap: true, padding: EdgeInsets.fromLTRB(primaryPaddingValue * 2, primaryPaddingValue * 2, primaryPaddingValue * 2, primaryPaddingValue * 2), children: [
                      ListView.builder(
                          primary: false,
                          itemCount: manager.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) => contactListTile(
                              img: manager[index]["photo"] != null ? '$baseUrl/photos/${manager[index]["photo"]}' : placeholderImage,
                              title: manager[index]["name"],
                              context: context,
                              subtitle: "Manager",
                              onTap: () async {
                                await createCall(
                                    accessToken: accessToken,
                                    receiver: manager[index]["userId"],
                                    receiverName: manager[index]["name"],
                                    receiverImg: manager[index]["photo"] != null ? '$baseUrl/photos/${manager[index]["photo"]}' : placeholderImage);
                              })),
                      ListView.builder(
                          primary: false,
                          itemCount: committeeHeads.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) => contactListTile(
                              img: committeeHeads[index]["member"]["photo"] != null ? '$baseUrl/photos/${committeeHeads[index]["member"]["photo"]}' : placeholderImage,
                              title: committeeHeads[index]["member"]["name"],
                              subtitle: "Committee Head",
                              context: context,
                              onTap: () async {
                                await createCall(
                                    accessToken: accessToken,
                                    receiver: committeeHeads[index]["member"]["userId"],
                                    receiverName: committeeHeads[index]["member"]["name"],
                                    receiverImg: committeeHeads[index]["member"]["photo"] != null ? '$baseUrl/photos/${committeeHeads[index]["member"]["photo"]}' : placeholderImage);
                              })),
                      ListView.builder(
                          primary: false,
                          itemCount: committeeMembers.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) => contactListTile(
                              img: committeeMembers[index]["member"]["photo"] != null ? '$baseUrl/photos/${committeeMembers[index]["member"]["photo"]}' : placeholderImage,
                              title: committeeMembers[index]["member"]["name"],
                              subtitle: "Committee Member",
                              context: context,
                              onTap: () async {
                                await createCall(
                                    accessToken: accessToken,
                                    receiver: committeeMembers[index]["member"]["userId"],
                                    receiverName: committeeMembers[index]["member"]["name"],
                                    receiverImg: committeeMembers[index]["member"]["photo"] != null ? '$baseUrl/photos/${committeeMembers[index]["member"]["photo"]}' : placeholderImage);
                              })),
                      ListView.builder(
                          primary: false,
                          itemCount: residentHeadsWithFlatName.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) => contactListTile(
                              img: residentHeadsWithFlatName[index]["residentHead"]["photo"] != null ? '$baseUrl/photos/${residentHeadsWithFlatName[index]["residentHead"]["photo"]}' : placeholderImage,
                              title: residentHeadsWithFlatName[index]["residentHead"]["name"],
                              subtitle: "Flat ${residentHeadsWithFlatName[index]["flatName"]} : Resident Head",
                              context: context,
                              onTap: () async {
                                await createCall(
                                    accessToken: accessToken,
                                    receiver: residentHeadsWithFlatName[index]["residentHead"]["userId"],
                                    receiverName: residentHeadsWithFlatName[index]["residentHead"]["name"],
                                    receiverImg:
                                        residentHeadsWithFlatName[index]["residentHead"]["photo"] != null ? '$baseUrl/photos/${residentHeadsWithFlatName[index]["residentHead"]["photo"]}' : placeholderImage);
                              })),
                      // ListView.builder(
                      //     primary: false,
                      //     itemCount: residentHeads.length,
                      //     shrinkWrap: true,
                      //     itemBuilder: (context, index) => contactListTile(
                      //         img: residentHeads[index]["photo"] != null ? '$baseUrl/photos/${residentHeads[index]["photo"]}' : placeholderImage,
                      //         title: residentHeads[index]["name"],
                      //         subtitle: "Resident Head",
                      //         context: context,
                      //         onTap: () async {
                      //           await createCall(
                      //               accessToken: accessToken,
                      //               receiver: residentHeads[index]["userId"],
                      //               receiverName: residentHeads[index]["name"],
                      //               receiverImg: residentHeads[index]["photo"] != null ? '$baseUrl/photos/${residentHeads[index]["photo"]}' : placeholderImage);
                      //         })),
                      ListView.builder(
                          primary: false,
                          itemCount: residents.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) => contactListTile(
                              img: residents[index]["photo"] != null ? '$baseUrl/photos/${residents[index]["photo"]}' : placeholderImage,
                              title: residents[index]["name"],
                              subtitle: "Resident",
                              context: context,
                              onTap: () async {
                                await createCall(
                                    accessToken: accessToken,
                                    receiver: residents[index]["userId"],
                                    receiverName: residents[index]["name"],
                                    receiverImg: residents[index]["photo"] != null ? '$baseUrl/photos/${residents[index]["photo"]}' : placeholderImage);
                              })),
                      ListView.builder(
                          primary: false,
                          itemCount: flatOwners.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) => contactListTile(
                              img: flatOwners[index]["user"]["photo"] != null ? '$baseUrl/photos/${flatOwners[index]["user"]["photo"]}' : placeholderImage,
                              title: flatOwners[index]["user"]["name"],
                              subtitle: "Flat Owner",
                              context: context,
                              onTap: () async {
                                await createCall(
                                    accessToken: accessToken,
                                    receiver: flatOwners[index]["user"]["userId"],
                                    receiverName: flatOwners[index]["user"]["name"],
                                    receiverImg: flatOwners[index]["user"]["photo"] != null ? '$baseUrl/photos/${flatOwners[index]["user"]["photo"]}' : placeholderImage);
                              }))
                    ]))
        ]));
  }
}
