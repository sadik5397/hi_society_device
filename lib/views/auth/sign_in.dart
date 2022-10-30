import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/api.dart';
import '../../component/button.dart';
import '../../component/page_navigation.dart';
import '../../component/snackbar.dart';
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

//APIs
  Future<void> doSignIn({required String email, required String password, required VoidCallback home}) async {
    try {
      var response = await http.post(Uri.parse("$baseUrl/auth/login"), headers: primaryHeader, body: jsonEncode({"email": email, "password": password}));
      Map result = jsonDecode(response.body);
      if (result["statusCode"] == 200 || result["statusCode"] == 201) {
        showSnackBar(context: context, label: result["message"]);
        setState(() => apiResult = result["data"]);
        final pref = await SharedPreferences.getInstance();
        await pref.setString("accessToken", apiResult["accessToken"]);
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
  defaultInit() async {}

//Initiate
  @override
  void initState() {
    super.initState();
    defaultInit();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            body: Center(
          child: ListView(shrinkWrap: true, children: [
            Image.asset("assets/icon/icon_only.png", height: 200),
            Text("Hi Society", textAlign: TextAlign.center, style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold, color: trueWhite)),
            SizedBox(height: primaryPaddingValue * 3),
            Form(
                key: _formKey,
                child: Column(children: [
                  primaryTextField(
                      context: context,
                      controller: emailController,
                      labelText: "Enter Hi Society Email",
                      keyboardType: TextInputType.emailAddress,
                      autoFocus: true,
                      errorText: "Username/Email required",
                      textCapitalization: TextCapitalization.none),
                  primaryTextField(
                      context: context,
                      controller: passwordController,
                      labelText: "Enter Password",
                      isPassword: true,
                      errorText: "Password required",
                      textCapitalization: TextCapitalization.none,
                      showPassword: showPassword,
                      showPasswordPressed: () => setState(() => showPassword = !showPassword))
                ])),
            Padding(
                padding: EdgeInsets.only(top: primaryPaddingValue, left: primaryPaddingValue * 8, right: primaryPaddingValue * 8),
                child: primaryButton(
                    context: context,
                    // loadingWait: loadingWait,
                    title: "Login",
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
                        showSnackBar(context: context, label: "Invalid Entry! Please Check");
                      }
                      // setState(() => loadingWait = false);
                    })),
            Padding(
                padding: EdgeInsets.only(top: primaryPaddingValue, bottom: primaryPaddingValue * 4),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("Having trouble login?", style: Theme.of(context).textTheme.titleSmall),
                  InkWell(
                      child: Text(" Please contact HI SOCIETY ", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
                      onTap: () => FocusManager.instance.primaryFocus?.unfocus())
                ]))
          ]),
        )));
  }
}
