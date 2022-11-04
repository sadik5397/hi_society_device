import 'package:flutter/material.dart';
import 'package:hi_society_device/component/app_bar.dart';
import 'package:hi_society_device/component/parking_booking.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import '../../component/overstay_list_tile.dart';

class ParkingBooking extends StatefulWidget {
  const ParkingBooking({Key? key}) : super(key: key);

  @override
  State<ParkingBooking> createState() => _ParkingBookingState();
}

class _ParkingBookingState extends State<ParkingBooking> {
  //variable
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: primaryAppBar(context: context, title: "Car Park Bookings"),
        body: (false)
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                shrinkWrap: true,
                padding: primaryPadding * 2,
                itemCount: 50,
                itemBuilder: (context, index) => parkBookingListTile(
                  context: context,
                  title: "MD. Zulfiaqar Sayeed",
                  date: "12-05-2023",
                  time: "03:45 AM",
                  flat: "1${((index + 1) % 10).toString()}F",
                ),
              ));
  }
}
