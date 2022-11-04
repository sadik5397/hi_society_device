import 'package:flutter/material.dart';
import 'package:hi_society_device/component/app_bar.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import '../../component/overstay_list_tile.dart';

class OverstayAlerts extends StatefulWidget {
  const OverstayAlerts({Key? key}) : super(key: key);

  @override
  State<OverstayAlerts> createState() => _OverstayAlertsState();
}

class _OverstayAlertsState extends State<OverstayAlerts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: primaryAppBar(context: context, title: "Overstay Requests"),
        body: (false)
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                shrinkWrap: true,
                padding: primaryPadding * 2,
                itemCount: 50,
                itemBuilder: (context, index) => overstayRequestListTile(
                  guestOf: (index % 2 == 0) ? "S.a. Sadik" : null,
                  context: context,
                  title: "MD. Zulfiaqar Sayeed",
                  eta: "03:45 AM",
                  flat: "1${((index + 1) % 10).toString()}F",
                ),
              ));
  }
}
