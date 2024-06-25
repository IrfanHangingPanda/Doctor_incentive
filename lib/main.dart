import 'package:doctors_incentive/language/translate.dart';
import 'package:doctors_incentive/screens/splace_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> backgroundHandler(RemoteMessage message) async {}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  await Firebase.initializeApp();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  FirebaseMessaging.instance.getToken().then((value) async {
    //  print(value);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('tokenNotification', value!);
    print(prefs.getString('tokenNotification'));
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: ChangeLanguage(),
      locale: const Locale('en', 'US'),
      title: 'Flutter Demo',
      theme: ThemeData(
          fontFamily: 'OpenSans',
          primarySwatch: Colors.blue,
          unselectedWidgetColor: Colors.grey),
      home: const SplaceScreen(),
    );
  }
}
