import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hi_society_device/api/i18n.dart';
import 'package:hi_society_device/component/app_bar.dart';
import 'package:hi_society_device/component/contact_list_tile.dart';
import 'package:hi_society_device/component/page_navigation.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import 'package:hi_society_device/views/intercom/call.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api.dart';
import '../../component/no_data.dart';
import '../../component/snack_bar.dart';
import '../../theme/placeholder.dart';

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
  List residents = [];
  List flatOwners = [];
  List allPeople = [];

  //API
  Future<void> getPeopleList({required String accessToken}) async {
    try {
      var response = await http.post(Uri.parse("$baseUrl/intercom/can-call"), headers: authHeader(accessToken));
      Map result = jsonDecode(response.body);
      print(result);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        if (kDebugMode) showSnackBar(context: context, label: result["message"]);
        setState(() => manager = [result["data"]["manager"]]);
        setState(() => committeeHeads = result["data"]["committeeHeads"]);
        setState(() => committeeMembers = result["data"]["committeeMembers"]);
        setState(() => residents = result["data"]["residents"]);
        setState(() => flatOwners = result["data"]["flatOwners"]);
        setState(() => allPeople = [manager, committeeHeads, committeeMembers, residents, flatOwners].expand((x) => x).toList());
      } else {
        showSnackBar(context: context, label: result["message"][0].toString().length == 1 ? result["message"].toString() : result["message"][0].toString());
      }
    } on Exception catch (e) {
      showSnackBar(context: context, label: e.toString());
    }
  }

  Future<void> createCall({required String accessToken, required int receiver, required String receiverImg, required String receiverName}) async {
    route(context, Call());
    // String randomChannel = generateRandomString(10);
    // // String randomChannel = "1234567890";
    // Permission.camera.request().then((value) async {
    //   print(value.toString());
    //   Permission.microphone.request().then((value) async {
    //     print(value.toString());
    //     routeNoBack(context, Call(channel: randomChannel.toString(), receiverId: receiver, receiverImage: receiverImg, receiverName: receiverName, clientRole: ClientRole.Broadcaster, intercomHistoryId: 0));
    //   });
    // });
    //
    // // try {
    // //   var response = await http.post(Uri.parse("$baseUrl/chat/create/room"), headers: authHeader(accessToken), body: jsonEncode({"roomName": roomName, "participants": participants}));
    // //   Map result = jsonDecode(response.body);
    // //   print(result);
    // //   if (result["statusCode"] == 200 || result["statusCode"] == 201) {
    // //     if (kDebugMode) showSnackBar(context: context, label: result["message"]);
    // //     setState(() => apiResult = result["data"]);
    // //     successRoute.call();
    // //   } else {
    // //     showError(context: context, label: result["message"][0].toString().length == 1 ? result["message"].toString() : result["message"][0].toString());
    // //   }
    // // } on Exception catch (e) {
    // //   showError(context: context, label: e.toString());
    // // }
  }

  //Functions
  defaultInit() async {
    final pref = await SharedPreferences.getInstance();
    setState(() => accessToken = pref.getString("accessToken").toString());
    setState(() => isBN = pref.getBool("isBN") ?? false);
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
        body: Column(
          children: [
            // Padding(
            //   padding: EdgeInsets.fromLTRB(primaryPaddingValue * 2, primaryPaddingValue * 2, primaryPaddingValue * 2, primaryPaddingValue * 1.5),
            //   child: primaryTextField(leftPadding: 0, rightPadding: 0, bottomPadding: 0, context: context, labelText: "Search Contact", controller: searchController),
            // ),
            SizedBox(height: primaryPaddingValue),
            Expanded(
                child: (allPeople.isEmpty)
                    ? noData()
                    : ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.fromLTRB(primaryPaddingValue * 2, primaryPaddingValue / 2, primaryPaddingValue * 2, primaryPaddingValue * 2),
                        children: [
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
                                      receiverImg: manager[index]["photo"] != null ? '$baseUrl/photos/${manager[index]["photo"]}' : placeholderImage,
                                    );
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
                                      receiverImg: committeeHeads[index]["member"]["photo"] != null ? '$baseUrl/photos/${committeeHeads[index]["member"]["photo"]}' : placeholderImage,
                                    );
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
                                      receiverImg: committeeMembers[index]["member"]["photo"] != null ? '$baseUrl/photos/${committeeMembers[index]["member"]["photo"]}' : placeholderImage,
                                    );
                                  })),
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
                                      receiverImg: residents[index]["photo"] != null ? '$baseUrl/photos/${residents[index]["photo"]}' : placeholderImage,
                                    );
                                  })),
                          ListView.builder(
                              primary: false,
                              itemCount: flatOwners.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) => contactListTile(
                                  img: flatOwners[index]["user"]["photo"] != null ? '$baseUrl/photos/${flatOwners[index]["photo"]}' : placeholderImage,
                                  title: flatOwners[index]["user"]["name"],
                                  subtitle: "Flat Owner",
                                  context: context,
                                  onTap: () async {
                                    await createCall(
                                      accessToken: accessToken,
                                      receiver: flatOwners[index]["user"]["userId"],
                                      receiverName: flatOwners[index]["user"]["name"],
                                      receiverImg: flatOwners[index]["user"]["photo"] != null ? '$baseUrl/photos/${flatOwners[index]["photo"]}' : placeholderImage,
                                    );
                                  }))
                        ],
                      ))
          ],
        ));
  }
}
