import 'dart:io';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import 'package:doctors_incentive/screens/homePagescreen.dart';

import 'package:doctors_incentive/screens/incentive_screen.dart';
import 'package:doctors_incentive/screens/settings_screen.dart';
import 'package:doctors_incentive/screens/statistics_screen.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Bottombar extends StatefulWidget {
  const Bottombar({super.key});

  @override
  State<Bottombar> createState() => _BottombarState();
}

var contactNumber;
final userPages = [
  const StatisticsScreen(),
  const IncentiveScreen(),
  const HomePageScreen(),
  const HomePageScreen(),
  const SettingsScreen()
];

whatsapp(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userWhatsapp = prefs.getString('whatsapp');
  if (userWhatsapp == null) {
    contactNumber = '+965 6646 2721';
  } else {
    contactNumber = userWhatsapp;
  }
  var contact = contactNumber;
  var androidUrl = "whatsapp://send?phone=$contact&text=Hi";
  var iosUrl = "https://wa.me/$contact?text=${Uri.parse('Hi')}";

  try {
    if (Platform.isIOS) {
      await launchUrl(Uri.parse(iosUrl));
    } else {
      if (await launchUrl(Uri.parse(androidUrl))) {
        await launchUrl(Uri.parse(androidUrl));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("WhatsApp is not installed on the device"),
          ),
        );
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text("WhatsApp is not installed"),
      ),
    );
  }
}

class _BottombarState extends State<Bottombar> {
  int _selectedIndex = 2;
  Widget _currentScreen = userPages[2];
  List<Color> iconColors = [
    Colors.white.withOpacity(0.6), // Color for Statistics icon
    Colors.white.withOpacity(0.6), // Color for Incentive icon
    Colors.white, // Color for Homepage icon
    Colors.white.withOpacity(0.6), // Color for Contact icon
    Colors.white.withOpacity(0.6) // Color for Setting icon
  ];

  @override
  void initState() {
    super.initState();
    initIconColors();
  }

  void initIconColors() {
    for (int index = 0; index < iconColors.length; index++) {
      if (index == _selectedIndex) {
        iconColors[index] = Colors.white; // Set initial color for active tab
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentScreen,
      bottomNavigationBar: ConvexAppBar(
        activeColor: Color(0XFFFDAC2F),
        color: Color(0XFFFDAC2F),
        backgroundColor: Color(0XFF65A4C5),
        initialActiveIndex: 2,
        top: -25,
        curve: Curves.bounceInOut,
        style: TabStyle.fixedCircle,
        cornerRadius: 20,
        curveSize: 0,
        height: 53,
        items: [
          TabItem(
            icon: Container(
              alignment: Alignment.center,
              child: ImageIcon(
                AssetImage("assets/images/Statistics.png"),
                color: iconColors[0],
                size: _selectedIndex == 0 ? 40 : 20,
              ),
            ),
          ),
          TabItem(
            icon: Container(
              alignment: Alignment.center,
              child: ImageIcon(
                AssetImage("assets/images/Incentive.png"),
                color: iconColors[1],
                size: _selectedIndex == 1 ? 40 : 20,
              ),
            ),
          ),
          TabItem(
            icon: Container(
              alignment: Alignment.center,
              child: ImageIcon(
                AssetImage("assets/images/homepage.png"),
                color: iconColors[2],
                size: _selectedIndex == 2 ? 30 : 20,
              ),
            ),
          ),
          TabItem(
            icon: Container(
              alignment: Alignment.center,
              child: ImageIcon(
                AssetImage("assets/images/whatsappimage.png"),
                color: iconColors[3],
                size: _selectedIndex == 3 ? 40 : 20,
              ),
            ),
          ),
          TabItem(
            icon: Container(
              alignment: Alignment.center,
              child: ImageIcon(
                AssetImage("assets/images/Setting.png"),
                color: iconColors[4],
                size: _selectedIndex == 4 ? 50 : 20,
              ),
            ),
          ),
        ],
        onTap: (i) {
          setState(() {
            _selectedIndex = i;
            for (int index = 0; index < iconColors.length; index++) {
              if (index == i) {
                iconColors[index] = Colors.white; // Active tab color
              } else {
                iconColors[index] =
                    Colors.white.withOpacity(0.6); // Inactive tab color
              }
            }
          });
          if (i == 3) {
            whatsapp(context);
          } else {
            _currentScreen = userPages[i];
          }
        },
      ),
    );
  }
}
