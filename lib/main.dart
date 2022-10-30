import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hi_society_device/theme/colors.dart';
import 'package:hi_society_device/theme/text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'views/auth/sign_in.dart';
import 'views/home.dart';
import 'package:flutter/services.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  if (kDebugMode) print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  if (kDebugMode) print("---- HI SOCIETY | GUARD DEVICE ----");

  //Get Saved JWT AccessToken
  final pref = await SharedPreferences.getInstance();
  final String? accessTokenFromSharedPreferences = pref.getString("accessToken");
  if (kDebugMode) print("Access Token from Android Local Shared Preference Status: $accessTokenFromSharedPreferences");

  //Initialize Firebase Notification System
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(alert: true, announcement: false, badge: true, carPlay: false, criticalAlert: false, provisional: false, sound: true);
  if (kDebugMode) print('Firebase user granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) print('Got a message whilst in the foreground!');
    if (kDebugMode) print('Message data: ${message.data}');
    if (message.notification != null) print('Message also contained a notification: ${message.notification}');
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //If everything is Okay, Run the App
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
