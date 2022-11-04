import 'dart:convert';
import 'package:hi_society_device/views/delivery/wait_for_resident_response.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hi_society_device/views/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/api.dart';
import '../../component/app_bar.dart';
import '../../component/dropdown_button.dart';
import '../../component/button.dart';
import '../../component/page_navigation.dart';
import '../../component/snack_bar.dart';
import '../../theme/padding_margin.dart';

class ReceiveParcel extends StatefulWidget {
  const ReceiveParcel({Key? key}) : super(key: key);

  @override
  State<ReceiveParcel> createState() => _ReceiveParcelState();
}

class _ReceiveParcelState extends State<ReceiveParcel> {
  //Variables
  String accessToken = "";
  dynamic apiResult;
  List<String> flatList = [];
  List<int> flatID = [];
  List<String> itemTypeList = ["Product", "Food", "Medicine", "Document", "Others"];
  List<String> merchantList = ["Daraz", "Foodpanda", "Chaldal", "Other"];
  List<String> deliveryMethod = ["I want to deliver the parcel at customer's door", "I want customer come down here to receive", "I want to drop the parcel here (PAID)"];
  List<String> deliveryMethodKeys = ["door_delivery", "hand_receive", "drop_at_guard"];
  String? selectedDeliveryMethod;
  String? selectedFlat;
  String? selectedItemType;
  String? selectedMerchant;

  //APIs
  Future<void> getFlatList({required String accessToken}) async {
    try {
      var response = await http.get(Uri.parse("$baseUrl/building/list/flat/by-guard"), headers: authHeader(accessToken));
      Map result = jsonDecode(response.body);
      print(result);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        showSnackBar(context: context, label: result["message"]);
        setState(() => apiResult = result["data"]);
        for (int i = 0; i < apiResult.length; i++) {
          setState(() => flatList.add(apiResult[i]["flatName"]));
          setState(() => flatID.add(apiResult[i]["flatId"]));
        }
      } else {
        showSnackBar(context: context, label: result["message"][0].toString().length == 1 ? result["message"].toString() : result["message"][0].toString());
      }
    } on Exception catch (e) {
      showSnackBar(context: context, label: e.toString());
    }
  }

  Future<void> createPPL({required String deliveryMethod, required String accessToken, required String itemType, required String merchant, required int flatId, required VoidCallback successRoute}) async {
    try {
      var response = await http.post(Uri.parse("$baseUrl/parcel-delivery/guard/create"),
          headers: authHeader(accessToken), body: jsonEncode({"flatId": flatId, "vendor": merchant, "deliveryMethod": deliveryMethod, "item": itemType}));
      Map result = jsonDecode(response.body);
      print(result);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        showSnackBar(context: context, label: result["message"]);
        print(result);
        successRoute.call();
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
    setState(() => accessToken = pref.getString("accessToken").toString());
    getFlatList(accessToken: accessToken);
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
        appBar: primaryAppBar(context: context, title: "Receive Parcel"),
        body: ListView(padding: EdgeInsets.symmetric(vertical: primaryPaddingValue * 4), children: [
          primaryDropdown(
            context: context,
            key: "Flat",
            title: "Which Flat to Go?",
            options: flatList,
            value: selectedFlat,
            onChanged: (value) => setState(() => selectedFlat = value.toString()),
          ),
          primaryDropdown(
            context: context,
            key: "Item Type",
            title: "What Item?",
            options: itemTypeList,
            value: selectedItemType,
            onChanged: (value) => setState(() => selectedItemType = value.toString()),
          ),
          primaryDropdown(
            context: context,
            key: "Merchant",
            title: "Which Merchant?",
            options: merchantList,
            value: selectedMerchant,
            onChanged: (value) => setState(() => selectedMerchant = value.toString()),
          ),
          primaryDropdown(
            context: context,
            title: "Deliver Method",
            options: deliveryMethod,
            value: selectedDeliveryMethod,
            onChanged: (value) => setState(() => selectedDeliveryMethod = value.toString()),
          ),
          SizedBox(height: primaryPaddingValue),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: primaryButton(
                  context: context,
                  title: "NEXT",
                  onTap: () async {
                    await createPPL(
                        deliveryMethod: selectedDeliveryMethod != null ? deliveryMethodKeys[deliveryMethod.indexOf(selectedDeliveryMethod!)] : "",
                        accessToken: accessToken,
                        itemType: selectedItemType ?? "",
                        merchant: selectedMerchant ?? "",
                        flatId: selectedFlat != null ? flatID[flatList.indexOf(selectedFlat!)] : -1,
                        successRoute: () => route(
                            context,
                            WaitForResidentResponse(
                                vendor: selectedMerchant ?? "...",
                                deliveryMethod: deliveryMethodKeys[deliveryMethod.indexOf(selectedDeliveryMethod!)],
                                flat: selectedFlat ?? "...",
                                item: selectedItemType ?? "...")));
                  }))
        ]));
  }
}
