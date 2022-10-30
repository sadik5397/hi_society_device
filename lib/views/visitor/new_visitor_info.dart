import 'package:flutter/material.dart';
import 'dart:io';
import 'package:hi_society_device/component/button.dart';
import 'package:hi_society_device/component/dropdown_button.dart';
import 'package:hi_society_device/component/text_field.dart';
import 'package:hi_society_device/theme/padding_margin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/api.dart';
import '../../component/app_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../component/snackbar.dart';
import '../../theme/border_radius.dart';
import '../../theme/colors.dart';

class NewVisitorInformation extends StatefulWidget {
  const NewVisitorInformation({Key? key, required this.mobileNumber}) : super(key: key);
  final String mobileNumber;

  @override
  State<NewVisitorInformation> createState() => _NewVisitorInformationState();
}

class _NewVisitorInformationState extends State<NewVisitorInformation> {
  //Variables
  String accessToken = "";
  dynamic apiResult;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  late TextEditingController mobileNumberController = TextEditingController(text: widget.mobileNumber);
  List<String> flatList = [];
  List<String> relationList = ["Father", "Mother", "Sister", "Brother", "Spouse", "Friend", "Colleague", "Others"];
  List<int> flatID = [];
  String? selectedFlat;
  String? selectedRelation;
  late File _image = File("");
  String base64img = "";
  final ImagePicker _picker = ImagePicker();

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

  Future<void> createNewVisitorProfile(
      {required String accessToken, required String name, required String address, String? email, required String phone, required String relation, required String photo, required int flatId}) async {
    try {
      var response = await http.post(Uri.parse("$baseUrl/visitor/guard/create"),
          headers: authHeader(accessToken), body: jsonEncode({"name": name, "address": address, "email": email, "phone": phone, "flatId": flatId, "relation": relation, "photo": photo}));
      Map result = jsonDecode(response.body);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        showSnackBar(context: context, label: result["message"]);
        print(result);
        askForPermissionToEnter(accessToken: accessToken, phone: phone, flatId: flatId);
      } else {
        showSnackBar(context: context, label: result["message"][0].toString().length == 1 ? result["message"].toString() : result["message"][0].toString());
      }
    } on Exception catch (e) {
      showSnackBar(context: context, label: e.toString());
    }
  }

  Future<void> askForPermissionToEnter(
      {required String accessToken, required String phone, required int flatId}) async {
    try {
      var response = await http.post(Uri.parse("$baseUrl/visitor/guard/access?fid=$flatId&phone=$phone"),
          headers: authHeader(accessToken));
      Map result = jsonDecode(response.body);
      print(result);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        showSnackBar(context: context, label: result["message"]);
        print(result);
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

  Future getImage() async {
    final image = await _picker.pickImage(source: ImageSource.camera);
    setState(() => _image = File(image!.path));
    setState(() => base64img = (base64Encode(_image.readAsBytesSync())));
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
        appBar: primaryAppBar(context: context),
        body: ListView(padding: EdgeInsets.symmetric(vertical: primaryPaddingValue * 4), children: [
          // SelectableText(base64img),
          primaryTextField(
            autoFocus: true,
            context: context,
            labelText: "Full Name",
            controller: nameController,
            textCapitalization: TextCapitalization.words,
          ),
          primaryTextField(
            context: context,
            labelText: "Address",
            controller: addressController,
            textCapitalization: TextCapitalization.words,
          ),
          primaryTextField(
            context: context,
            labelText: "Email (Optional)",
            controller: emailController,
            textCapitalization: TextCapitalization.none,
            keyboardType: TextInputType.emailAddress,
          ),
          primaryTextField(
            context: context,
            isDisable: true,
            labelText: "Mobile Number",
            controller: mobileNumberController,
            textCapitalization: TextCapitalization.none,
            keyboardType: TextInputType.phone,
          ),
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
            key: "Relation",
            title: "Relation?",
            options: relationList,
            value: selectedRelation,
            onChanged: (value) => setState(() => selectedRelation = value.toString()),
          ),
          Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: trueWhite, width: 2)),
              margin: EdgeInsets.fromLTRB(primaryPaddingValue * 3, 0, primaryPaddingValue * 3, primaryPaddingValue * 2),
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 50),
                  height: (base64img != "") ? MediaQuery.of(context).size.width * .5 : 96,
                  decoration: BoxDecoration(borderRadius: primaryBorderRadius, color: trueWhite, border: Border.all(color: primaryBackgroundColor, width: 2)),
                  padding: EdgeInsets.all(primaryPaddingValue / 4),
                  alignment: Alignment.center,
                  child: (base64img != "")
                      ? Stack(fit: StackFit.expand, alignment: Alignment.center, children: [
                          ClipRRect(borderRadius: primaryBorderRadius / 1.4, child: Opacity(opacity: .5, child: Image.memory(base64Decode(base64img), fit: BoxFit.cover))),
                          Image.memory(base64Decode(base64img))
                        ])
                      : ElevatedButton.icon(
                          onPressed: getImage,
                          icon: const Icon(Icons.camera_alt_outlined),
                          label: const Text("Take Photo"),
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: trueWhite,
                              fixedSize: const Size(double.maxFinite, double.maxFinite),
                              textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color: trueWhite, fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(borderRadius: primaryBorderRadius / 2))))),
          SizedBox(height: primaryPaddingValue),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: primaryButton(
                  context: context,
                  title: "NEXT",
                  onTap: () async {
                    await createNewVisitorProfile(
                        accessToken: accessToken,
                        name: nameController.text,
                        address: addressController.text,
                        phone: mobileNumberController.text,
                        relation: selectedRelation ?? "",
                        photo: "data:image/png;base64,$base64img",
                        flatId: flatID[flatList.indexOf(selectedFlat!)]);
                  }))
        ]));
  }
}
