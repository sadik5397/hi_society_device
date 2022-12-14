import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hi_society_device/component/app_bar.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api.dart';
import '../../component/no_data.dart';
import '../../component/snack_bar.dart';

class ParkingBooking extends StatefulWidget {
  const ParkingBooking({Key? key}) : super(key: key);

  @override
  State<ParkingBooking> createState() => _ParkingBookingState();
}

class _ParkingBookingState extends State<ParkingBooking> {
  //variable
  TextEditingController searchController = TextEditingController();
  String accessToken = "";
  List apiResult = [];
  List bookingList = [];

  //APIs
  Future<void> readAmenityBookingByDate({required String accessToken, required String date}) async {
    try {
      var response = await http.post(Uri.parse("$baseUrl/amenity-booking/list/amenity/booking/by-date?date=$date"), headers: authHeader(accessToken));
      Map result = jsonDecode(response.body);
      print(result);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        showSnackBar(context: context, label: result["message"]);
        setState(() => apiResult = result["data"]);
      } else {
        showSnackBar(context: context, label: result["message"][0].toString().length == 1 ? result["message"].toString() : result["message"][0].toString());
      }
    } on Exception catch (e) {
      showSnackBar(context: context, label: e.toString());
    }
  }

  //Functions
  Future<void> onRefresh() async {
    await defaultInit();
  }

  defaultInit() async {
    final pref = await SharedPreferences.getInstance();
    setState(() => accessToken = pref.getString("accessToken")!);
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
        appBar: primaryAppBar(context: context, title: "Car Park Bookings"),
        body: (apiResult.isEmpty)
            ? noData()
            : ListView.builder(
                shrinkWrap: true,
                padding: primaryPadding * 2,
                itemCount: apiResult.length,
                itemBuilder: (context, index) => const FlutterLogo(),
              ));
  }
}
