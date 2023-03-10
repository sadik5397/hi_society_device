import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hi_society_device/theme/colors.dart';
import 'package:hi_society_device/theme/text_style.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'views/auth/sign_in.dart';
import 'views/home.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  if (kDebugMode) print("---- HI SOCIETY | GUARD DEVICE ----");

  //Get Saved JWT AccessToken
  //region
  final pref = await SharedPreferences.getInstance();
  final String accessTokenFromSharedPreferences = pref.getString("accessToken") ?? "";
  if (kDebugMode) print("Access Token from Android Local Shared Preference Status: $accessTokenFromSharedPreferences");
  //endregion

  //Initialize Firebase Notification System
  //region
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(alert: true, announcement: true, badge: true, carPlay: false, criticalAlert: false, provisional: false, sound: true);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  if (kDebugMode) print('Firebase user granted permission: ${settings.authorizationStatus}');
  //endregion

  //Pull Last Notification, if app terminated
  //region
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    if (kDebugMode) print("Terminated Background message: ${initialMessage.data}");
    // final pref = await SharedPreferences.getInstance();
    // pref.setString("fcmPayload", jsonEncode(initialMessage.data));
    // print("(Receive) from Shared Pref: ${pref.getString("fcmPayload")}");
  }
  //endregion

  //Foreground Notification
  //region
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    if (kDebugMode) print('Foreground Message data: ${message.data}');
    if (message.notification != null) print('Message also contained a notification: ${message.notification}');
  });
  //endregion

  //Background Notification
  //region
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //endregion

  //Notification Permissions
  //region
  (settings.authorizationStatus == AuthorizationStatus.authorized)
      ? print('FCM Notification : User granted permission')
      : (settings.authorizationStatus == AuthorizationStatus.provisional)
          ? print('FCM Notification : User granted provisional permission')
          : print('FCM Notification : User declined or has not accepted permission');
  //endregion

  //If everything is Okay, Run the App
  runApp(Phoenix(child: MyApp(accessToken: accessTokenFromSharedPreferences)));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async => print("(Receive) FCM : app on Background : ${message.data}");

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
                titleTextStyle: bold22White)),
        home: accessToken.isEmpty ? const SignIn() : const Home()
        // home: const Call(),
        );
  }
}
