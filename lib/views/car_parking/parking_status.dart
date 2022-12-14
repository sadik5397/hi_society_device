import 'package:flutter/material.dart';
import 'package:hi_society_device/component/app_bar.dart';
import 'package:hi_society_device/component/parkStatusGrdTile.dart';
import 'package:hi_society_device/theme/padding_margin.dart';

import '../../component/no_data.dart';

class ParkingStatus extends StatefulWidget {
  const ParkingStatus({Key? key}) : super(key: key);

  @override
  State<ParkingStatus> createState() => _ParkingStatusState();
}

class _ParkingStatusState extends State<ParkingStatus> {
  //variable
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: primaryAppBar(context: context, title: "Car Parking Status"),
        body: (false)
            ? noData()
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1, crossAxisSpacing: primaryPaddingValue * 2, mainAxisSpacing: primaryPaddingValue * 2),
                shrinkWrap: true,
                padding: primaryPadding * 2,
                itemCount: 4,
                itemBuilder: (context, index) => parkStatusGridTile(context: context, index: index, isFree: false, guestName: "S.a. Sadik", guestOf: "12C"),
              ));
  }
}
