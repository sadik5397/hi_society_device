import 'package:flutter/material.dart';
import 'package:hi_society_device/api/i18n.dart';
import 'package:hi_society_device/component/app_bar.dart';
import 'package:hi_society_device/component/contact_list_tile.dart';
import 'package:hi_society_device/component/page_navigation.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import 'package:hi_society_device/views/intercom/call.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  //Functions
  defaultInit() async {
    final pref = await SharedPreferences.getInstance();
    setState(() => accessToken = pref.getString("accessToken").toString());
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
        appBar: primaryAppBar(context: context, title: i18n_intercom(isBN)),
        body: Column(
          children: [
            // Padding(
            //   padding: EdgeInsets.fromLTRB(primaryPaddingValue * 2, primaryPaddingValue * 2, primaryPaddingValue * 2, primaryPaddingValue * 1.5),
            //   child: primaryTextField(leftPadding: 0, rightPadding: 0, bottomPadding: 0, context: context, labelText: "Search Contact", controller: searchController),
            // ),
            SizedBox(height: primaryPaddingValue),
            Expanded(
                child: (false)
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.fromLTRB(primaryPaddingValue * 2, primaryPaddingValue / 2, primaryPaddingValue * 2, primaryPaddingValue * 2),
                        itemCount: 50,
                        itemBuilder: (context, index) => contactListTile(
                          isBN: isBN,
                          onTap: () => route(context, const Call()),
                          context: context,
                          title: "MD. Zulfiaqar Sayeed",
                          subtitle: "Flat Owner - Committee Member",
                          flat: "12A",
                        ),
                      ))
          ],
        ));
  }
}
