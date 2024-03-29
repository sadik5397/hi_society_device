import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hi_society_device/api/i18n.dart';
import 'package:hi_society_device/views/system/system_setting.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api.dart';
import '../../component/button.dart';
import '../../component/page_navigation.dart';
import '../../component/snack_bar.dart';
import '../../component/text_field.dart';
import '../../theme/colors.dart';
import '../../theme/padding_margin.dart';
import '../home.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
//Variables
  String accessToken = "";
  bool loadingWait = false;
  bool showPassword = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  dynamic apiResult = {};
  bool isBN = false;

//APIs
  Future<void> doSignIn({required String email, required String password, required VoidCallback home}) async {
    try {
      var response = await http.post(Uri.parse("$baseUrl/auth/login"), headers: primaryHeader, body: jsonEncode({"email": email, "password": password}));
      Map result = jsonDecode(response.body);
      print(result);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        if (kDebugMode) showSnackBar(context: context, label: result["message"]);
        setState(() => apiResult = result["data"]);
        final pref = await SharedPreferences.getInstance();
        await pref.setString("accessToken", apiResult["accessToken"]);
        await pref.setString("refreshToken", apiResult["refreshToken"]);
        await pref.setBool("isBN", true);
        setState(() => accessToken = apiResult["accessToken"]);
        home.call();
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
    setState(() => isBN = pref.getBool("isBN") ?? true);
    setState(() => accessToken = pref.getString("accessToken") ?? "");
    if (accessToken != "") routeNoBack(context, Home());
  }

//Initiate
  @override
  void initState() {
    super.initState();
    defaultInit();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                    visualDensity: VisualDensity.comfortable, icon: Icon(Icons.settings), onPressed: () => route(context, SystemSettings(isBN: isBN)), tooltip: "System Settings", enableFeedback: true)),
            body: Center(
                child: ListView(shrinkWrap: true, children: [
              Image.asset("assets/icon/icon_only.png", height: 200),
              Text(i18n_appTitle(isBN), textAlign: TextAlign.center, style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold, color: trueWhite)),
              SizedBox(height: primaryPaddingValue * 3),
              Form(
                  key: _formKey,
                  child: Column(children: [
                    primaryTextField(
                        context: context,
                        controller: emailController,
                        labelText: i18n_enterEmail(isBN),
                        keyboardType: TextInputType.emailAddress,
                        autoFocus: true,
                        errorText: i18n_requiredField(isBN),
                        textCapitalization: TextCapitalization.none),
                    primaryTextField(
                        context: context,
                        controller: passwordController,
                        labelText: i18n_enterPassword(isBN),
                        isPassword: true,
                        errorText: i18n_requiredField(isBN),
                        textCapitalization: TextCapitalization.none,
                        showPassword: showPassword,
                        showPasswordPressed: () => setState(() => showPassword = !showPassword))
                  ])),
              Padding(
                  padding: EdgeInsets.only(top: primaryPaddingValue, left: primaryPaddingValue * 8, right: primaryPaddingValue * 8),
                  child: primaryButton(
                      context: context,
                      // loadingWait: loadingWait,
                      title: i18n_login(isBN),
                      onTap: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        // setState(() => loadingWait = true);
                        if (_formKey.currentState!.validate()) {
                          await doSignIn(
                            email: emailController.text.toLowerCase(),
                            password: passwordController.text,
                            home: () => route(context, const Home()),
                          );
                        } else {
                          showSnackBar(context: context, label: i18n_invalidEntry(isBN));
                        }
                        // setState(() => loadingWait = false);
                      })),
              Padding(
                  padding: EdgeInsets.only(top: primaryPaddingValue, bottom: primaryPaddingValue * 4),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(i18n_havingTroubleLogin(isBN), style: Theme.of(context).textTheme.titleSmall),
                    InkWell(
                        child: Text(" ${i18n_pleaseContact(isBN)} ", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          showSnackBar(context: context, label: i18n_pleaseContact(isBN), seconds: 6);
                        })
                  ]))
            ]))));
  }
}
