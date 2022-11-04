import 'package:flutter/material.dart';
import 'package:hi_society_device/component/app_bar.dart';
import 'package:hi_society_device/component/big_option_button.dart';
import 'package:hi_society_device/views/delivery/ppl_code_entry.dart';
import 'package:hi_society_device/views/delivery/receive_parcel.dart';

class ReceiveOrDistribute extends StatelessWidget {
  const ReceiveOrDistribute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: primaryAppBar(context: context,title: "Delivery Management"),
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            bigOptionButton(context: context, iconImage: "assets/options/parcel_receive.png", label: "Receive Parcel", toPage: const ReceiveParcel()),
            bigOptionButton(context: context, iconImage: "assets/options/parcel_distribute.png", label: "Disburse Parcel", toPage: const PPLCodeEntry()),
          ]),
        ));
  }
}
