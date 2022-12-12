import 'package:flutter/material.dart';
import 'package:hi_society_device/api/i18n.dart';
import 'package:hi_society_device/component/app_bar.dart';
import 'package:hi_society_device/component/big_option_button.dart';
import 'package:hi_society_device/views/delivery/ppl_code_entry.dart';
import 'package:hi_society_device/views/delivery/receive_parcel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReceiveOrDistribute extends StatefulWidget {
  const ReceiveOrDistribute({Key? key}) : super(key: key);

  @override
  State<ReceiveOrDistribute> createState() => _ReceiveOrDistributeState();
}

class _ReceiveOrDistributeState extends State<ReceiveOrDistribute> {
  bool isBN = false;

  //Functions
  defaultInit() async {
    final pref = await SharedPreferences.getInstance();
    setState(() => isBN = pref.getBool("isBN") ?? false);
  }

  @override
  void initState() {
    super.initState();
    defaultInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: primaryAppBar(context: context, title: i18n_deliveryManagement(isBN)),
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            bigOptionButton(context: context, iconImage: "assets/options/parcel_receive.png", label: i18n_rcvParcel(isBN), toPage: const ReceiveParcel()),
            bigOptionButton(context: context, iconImage: "assets/options/parcel_distribute.png", label: i18n_dsbParcel(isBN), toPage: const PPLCodeEntry()),
          ]),
        ));
  }
}
