import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hi_society_device/api/i18n.dart';
import 'package:hi_society_device/component/utility_contact_list_tile.dart';
import 'package:hi_society_device/theme/border_radius.dart';
import 'package:hi_society_device/theme/placeholder.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api.dart';
import '../../component/app_bar.dart';
import '../../component/snack_bar.dart';
import '../../theme/colors.dart';
import '../../theme/padding_margin.dart';

class UtilityContacts extends StatefulWidget {
  const UtilityContacts({Key? key}) : super(key: key);

  @override
  State<UtilityContacts> createState() => _UtilityContactsState();
}

class _UtilityContactsState extends State<UtilityContacts> {
  //Variables
  String accessToken = "";
  List category = [];
  List<List> contacts = [];
  bool isBN = false;

//APIs
  Future<void> readCategory({required String accessToken}) async {
    try {
      var response = await http.post(Uri.parse("$baseUrl/utility-contact/view/category"), headers: authHeader(accessToken));
      Map result = jsonDecode(response.body);
      print(result);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        showSnackBar(context: context, label: result["message"]);
        setState(() => category = result["data"]);
      } else {
        showSnackBar(context: context, label: result["message"][0].toString().length == 1 ? result["message"].toString() : result["message"][0].toString());
      }
    } on Exception catch (e) {
      showSnackBar(context: context, label: e.toString());
    }
  }

  Future<void> readContacts({required String accessToken, required List category}) async {
    try {
      for (int i = 0; i < category.length; i++) {
        var response = await http.post(Uri.parse("$baseUrl/utility-contact/view/contact/by-category?cid=${category[i]['utilityContactCategoryId']}"), headers: authHeader(accessToken));
        Map result = jsonDecode(response.body);
        print(result);
        if (result["statusCode"] == 200 || result["statusCode"] == 201) {
          showSnackBar(context: context, label: result["message"]);
          (result["data"].length == 0)
              ? setState(() => contacts.add([
                    {"contactName": "Empty"}
                  ]))
              : setState(() => contacts.add(result["data"]));
        } else {
          showSnackBar(context: context, label: result["message"][0].toString().length == 1 ? result["message"].toString() : result["message"][0].toString());
        }
      }
    } on Exception catch (e) {
      showSnackBar(context: context, label: e.toString());
    }
  }

//Functions
  defaultInit() async {
    final pref = await SharedPreferences.getInstance();
    setState(() => accessToken = pref.getString("accessToken")!);
    setState(() => isBN = pref.getBool("isBN") ?? false);
    await readCategory(accessToken: accessToken);
    await readContacts(accessToken: accessToken, category: category);
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
        appBar: primaryAppBar(context: context, title: i18n_utilityContacts(isBN)),
        body: (category.isEmpty)
            ? const Center(child: CircularProgressIndicator())
            : ClipRRect(
                borderRadius: primaryBorderRadius,
                child: ListView.builder(
                    padding: primaryPadding,
                    itemCount: category.length,
                    itemBuilder: (context, index) => ExpansionTile(
                        initiallyExpanded: true,
                        subtitle: Text("${(contacts[index][0]["contactName"] == "Empty") ? 0 : (contacts[index].length)} ${i18n_contacts(isBN)}"),
                        title: Text(category[index]["name"]),
                        tilePadding: EdgeInsets.symmetric(horizontal: primaryPaddingValue),
                        expandedAlignment: Alignment.centerLeft,
                        backgroundColor: Colors.white,
                        collapsedBackgroundColor: trueWhite,
                        maintainState: true,
                        iconColor: primaryColor,
                        // collapsedIconColor: themeTitle,
                        collapsedTextColor: primaryTitleColor,
                        childrenPadding: EdgeInsets.symmetric(horizontal: primaryPaddingValue),
                        textColor: primaryColor,
                        children: (contacts.isEmpty)
                            ? [const Center(child: CircularProgressIndicator())]
                            : List.generate(contacts[index].length, (index2) {
                                if (contacts[index][index2]["contactName"] != "Empty") {
                                  return utilityContactListTile(photo: placeholderImage, context: context, title: contacts[index][index2]["contactName"], number: contacts[index][index2]["contactNumber"]);
                                } else {
                                  return Padding(padding: EdgeInsets.only(bottom: primaryPaddingValue), child: Text(i18n_noContactFound(isBN), style: TextStyle(color: primaryTitleColor)));
                                }
                              })))));
  }
}
