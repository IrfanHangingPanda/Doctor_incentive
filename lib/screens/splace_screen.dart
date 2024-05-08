import 'dart:async';

import 'package:doctors_incentive/screens/bottombar.dart';
import 'package:doctors_incentive/screens/datamanager.dart';

import 'package:doctors_incentive/screens/login_screen.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplaceScreen extends StatefulWidget {
  const SplaceScreen({super.key});

  @override
  State<SplaceScreen> createState() => _SplaceScreenState();
}

class _SplaceScreenState extends State<SplaceScreen> {
  @override
  void initState() {
    super.initState();

    splaceTimer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  splaceTimer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (prefs.getBool('isPasswordUpdate') != null) {
      DataManager.getInstance().setUserToken(token.toString());

      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Bottombar())));
    } else {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginScreen())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 114, 179, 233),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          padding: EdgeInsets.all(20),
          child: Container(
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.height * 0.18,
              decoration: const BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage("assets/images/splaceImage.png"),
                  fit: BoxFit.contain,
                ),
              )),
        ),
      ),
    );
  }
}
