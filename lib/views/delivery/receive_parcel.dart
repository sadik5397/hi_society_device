import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hi_society_device/api/i18n.dart';
import 'package:hi_society_device/component/text_field.dart';
import 'package:hi_society_device/views/delivery/wait_for_resident_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api.dart';
import '../../api/static_values.dart';
import '../../component/app_bar.dart';
import '../../component/button.dart';
import '../../component/dropdown_button.dart';
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
  bool isBN = false;
  dynamic apiResult;
  List<String> flatList = [];
  List<int> flatID = [];
  List<String> merchantList = merchants;
  List<String> deliveryMethodKeys = deliveryMethods;
  String? selectedDeliveryMethod;
  String? selectedFlat;
  String? selectedItemType;
  String? selectedMerchant;
  TextEditingController noteController = TextEditingController();

  //APIs
  Future<void> getFlatList({required String accessToken}) async {
    try {
      var response = await http.get(Uri.parse("$baseUrl/building/list/flat/by-guard"), headers: authHeader(accessToken));
      Map result = jsonDecode(response.body);
      print(result);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        if (kDebugMode) showSnackBar(context: context, label: result["message"]);
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
        if (kDebugMode) showSnackBar(context: context, label: result["message"]);
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
    setState(() => isBN = pref.getBool("isBN") ?? false);
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
        appBar: primaryAppBar(context: context, title: i18n_rcvParcel(isBN)),
        body: ListView(padding: EdgeInsets.symmetric(vertical: primaryPaddingValue * 4), children: [
          primaryDropdown(context: context, key: i18n_flat(isBN), title: i18n_whichFlat(isBN), options: flatList, value: selectedFlat, onChanged: (value) => setState(() => selectedFlat = value.toString())),
          primaryDropdown(
              context: context,
              key: i18n_itemType(isBN),
              title: i18n_whatItem(isBN),
              options: [i18n_product(isBN), i18n_food(isBN), i18n_medicine(isBN), i18n_document(isBN), i18n_others(isBN)],
              value: selectedItemType,
              onChanged: (value) => setState(() => selectedItemType = value.toString())),
          primaryDropdown(
              context: context,
              key: i18n_merchant(isBN),
              title: i18n_whichMerchant(isBN),
              options: merchantList,
              value: selectedMerchant,
              onChanged: (value) => setState(() => selectedMerchant = value.toString())),
          primaryDropdown(
              context: context,
              title: i18n_deliverMethod(isBN),
              options: [i18n_deliverParcelAtCustomersDoor(isBN), i18n_customerComeDownHereToReceive(isBN), i18n_dropParcelHere(isBN)],
              value: selectedDeliveryMethod,
              onChanged: (value) => setState(() => selectedDeliveryMethod = value.toString())),
          primaryTextField(context: context, labelText: i18n_deliveryNote(isBN), controller: noteController, textCapitalization: TextCapitalization.words, autoFocus: false),
          SizedBox(height: primaryPaddingValue),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: primaryButton(
                  context: context,
                  title: i18n_next(isBN),
                  onTap: () async {
                    selectedFlat == null
                        ? showSnackBar(context: context, label: i18n_selectFlat(isBN))
                        : await createPPL(
                            deliveryMethod: selectedDeliveryMethod != null
                                ? deliveryMethodKeys[[i18n_deliverParcelAtCustomersDoor(isBN), i18n_customerComeDownHereToReceive(isBN), i18n_dropParcelHere(isBN)].indexOf(selectedDeliveryMethod!)]
                                : "",
                            accessToken: accessToken,
                            itemType: '${selectedItemType ?? ""} || ${noteController.text}',
                            merchant: selectedMerchant ?? "",
                            flatId: selectedFlat != null ? flatID[flatList.indexOf(selectedFlat!)] : -1,
                            successRoute: () => route(
                                context,
                                WaitForResidentResponse(
                                    codeGenerated:
                                        deliveryMethodKeys[[i18n_deliverParcelAtCustomersDoor(isBN), i18n_customerComeDownHereToReceive(isBN), i18n_dropParcelHere(isBN)].indexOf(selectedDeliveryMethod!)] ==
                                            "drop_at_guard",
                                    note: noteController.text.toString(),
                                    vendor: selectedMerchant ?? "...",
                                    deliveryMethod:
                                        deliveryMethodKeys[[i18n_deliverParcelAtCustomersDoor(isBN), i18n_customerComeDownHereToReceive(isBN), i18n_dropParcelHere(isBN)].indexOf(selectedDeliveryMethod!)],
                                    flat: selectedFlat ?? "...",
                                    flatId: selectedFlat != null ? flatID[flatList.indexOf(selectedFlat!)] : -1,
                                    item: selectedItemType ?? "...")));
                  }))
        ]));
  }
}
