import 'package:flutter/material.dart';
import 'package:hi_society_device/component/app_bar.dart';
import 'package:hi_society_device/component/contact_list_tile.dart';
import 'package:hi_society_device/component/page_navigation.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import 'package:hi_society_device/views/intercom/call.dart';
import '../../component/text_field.dart';

class ContactList extends StatefulWidget {
  const ContactList({Key? key}) : super(key: key);

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  //variable
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: primaryAppBar(context: context, title: "Intercom"),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(primaryPaddingValue * 2, primaryPaddingValue * 2, primaryPaddingValue * 2, primaryPaddingValue * 1.5),
              child: primaryTextField(leftPadding: 0, rightPadding: 0, bottomPadding: 0, context: context, labelText: "Search Contact", controller: searchController),
            ),
            Expanded(
                child: (false)
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.fromLTRB(primaryPaddingValue * 2, primaryPaddingValue / 2, primaryPaddingValue * 2, primaryPaddingValue * 2),
                        itemCount: 50,
                        itemBuilder: (context, index) => contactListTile(onTap: ()=> route(context, const Call()),context: context, title: "MD. Zulfiaqar Sayeed", subtitle: "Flat Owner - Committee Member", flat: ""
                            "12A"),
                      ))
          ],
        ));
  }
}
