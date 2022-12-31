import 'package:flutter/material.dart';
import 'package:hi_society_device/component/app_bar.dart';
import 'package:hi_society_device/component/big_option_button.dart';
import 'package:hi_society_device/views/car_parking/parking_booking.dart';
import 'package:hi_society_device/views/car_parking/parking_status.dart';

class CarParking extends StatelessWidget {
  const CarParking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: primaryAppBar(context: context, title: "Car Parking"),
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            bigOptionButton(context: context, iconImage: "assets/options/parking_booking.png", label: "Booking List", toPage: const ParkingBooking()),
            bigOptionButton(context: context, iconImage: "assets/options/parking_status.png", label: "Parking Status", toPage: const ParkingStatus()),
          ]),
        ));
  }
}
