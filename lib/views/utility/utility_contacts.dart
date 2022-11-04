import 'package:flutter/material.dart';
import 'package:hi_society_device/component/app_bar.dart';
import 'package:hi_society_device/component/utility_contact_list_tile.dart';
import 'package:hi_society_device/theme/padding_margin.dart';

class UtilityContacts extends StatefulWidget {
  const UtilityContacts({Key? key}) : super(key: key);

  @override
  State<UtilityContacts> createState() => _UtilityContactsState();
}

class _UtilityContactsState extends State<UtilityContacts> with TickerProviderStateMixin {
  //variable
  List<String> tabs = ["All", "Electrician", "Tiles", "Plumber", "Dish/Internet"];
  late TabController controller = TabController(length: tabs.length, vsync: this);

  //initial
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 5,
        child: Scaffold(
            appBar: primaryAppbarWithTabs(context: context, title: "Utility Person Contacts", tabs: tabs, controller: controller),
            body: TabBarView(controller: controller, children: [
              // TAB ONE
              (false)
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: primaryPadding * 2,
                      itemCount: 10,
                      itemBuilder: (context, index) => utilityContactListTile(
                          photo: "https://www.kalerkantho.com/assets/news_images/2013/08/18/image_3407.tota-pakhi.jpg",
                          type: "Electrician",
                          context: context,
                          title: "MD. Zulfiaqar Sayeed",
                          number: "01515644470",
                          flat: "1${((index + 1) % 10).toString()}F")),
              // TAB TWO
              (false)
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: primaryPadding * 2,
                      itemCount: 10,
                      itemBuilder: (context, index) => utilityContactListTile(
                            photo: "https://www.kalerkantho.com/assets/news_images/2013/08/18/image_3407.tota-pakhi.jpg",
                            type: "Electrician",
                            context: context,
                            title: "MD. Zulfiaqar Sayeed",
                            number: "01515644470",
                            flat: "1${((index + 1) % 10).toString()}F",
                          ))
            ])));
  }
}
