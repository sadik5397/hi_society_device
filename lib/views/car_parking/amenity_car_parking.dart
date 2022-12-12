import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hi_society_device/api/i18n.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api.dart';
import '../../component/app_bar.dart';
import '../../component/parking_booking.dart';
import '../../component/snack_bar.dart';
import '../../theme/padding_margin.dart';

class AmenityCarParking extends StatefulWidget {
  const AmenityCarParking({Key? key}) : super(key: key);

  @override
  State<AmenityCarParking> createState() => _AmenityCarParkingState();
}

class _AmenityCarParkingState extends State<AmenityCarParking> {
  //variables
  String accessToken = "";
  List bookingList = [];
  bool isBN = false;

  //APIs
  Future<void> readAmenityBookingByDate({required String accessToken, required String date}) async {
    try {
      var response = await http.post(Uri.parse("$baseUrl/amenity-booking/list/amenity/booking/by-date?date=$date"), headers: authHeader(accessToken));
      Map result = jsonDecode(response.body);
      print("$baseUrl/amenity-booking/list/amenity/booking/by-date?date=$date");
      print(result);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        showSnackBar(context: context, label: result["message"]);
        setState(() => bookingList = result["data"]);
      } else {
        showSnackBar(context: context, label: result["message"][0].toString().length == 1 ? result["message"].toString() : result["message"][0].toString());
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
    await readAmenityBookingByDate(accessToken: accessToken, date: DateFormat('yyyy-M-dd').format(DateTime.now()));
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
        appBar: primaryAppBar(context: context, title: i18n_requiredCarParking(isBN)),
        body: (bookingList.isEmpty)
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
