import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hi_society_device/theme/colors.dart';
import 'package:hi_society_device/theme/text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/auth/sign_in.dart';
import 'views/home.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  if (kDebugMode) print("---- HI SOCIETY | GUARD DEVICE ----");
  final pref = await SharedPreferences.getInstance();
  final String? accessTokenFromSharedPreferences = pref.getString("accessToken");
  if (kDebugMode) print("Access Token from Android Local Shared Preference Status: $accessTokenFromSharedPreferences");
  runApp(MyApp(accessToken: accessTokenFromSharedPreferences ?? ""));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.accessToken}) : super(key: key);
  final String accessToken;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hi Society Guard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        scaffoldBackgroundColor: primaryBackgroundColor,
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          centerTitle: true,
          foregroundColor: trueWhite,
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light),
          titleTextStyle: bold22White,
        ),
      ),
      home: accessToken.isEmpty ? const SignIn() : const Home(),
    );
  }
}
