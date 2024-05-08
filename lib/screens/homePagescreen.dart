import 'dart:io';

import 'package:doctors_incentive/apiController/adminDetailsController.dart';
import 'package:doctors_incentive/apiController/userDetailController.dart';
import 'package:doctors_incentive/components/homeScreen_effects.dart';
import 'package:doctors_incentive/model/textsize.dart';

import 'package:doctors_incentive/screens/incentive_screen.dart';
import 'package:doctors_incentive/screens/notificationScreen.dart';
import 'package:doctors_incentive/screens/settings_screen.dart';
import 'package:doctors_incentive/screens/statistics_screen.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  var userdetailscontroller = Get.put(UserDetailsController());
  var admindetailsController = Get.put(AdminDetailsController());

  var contactNumber;

  @override
  void initState() {
    super.initState();
    userdetailscontroller.dataSendToServer();
    admindetailsController.dataSendToServer();
    getWhatsapp();
  }

  Future<void> getWhatsapp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userWhatsapp = prefs.getString('whatsappNumber');

    if (userWhatsapp == null) {
      contactNumber = '+965 6646 2721';
    } else {
      contactNumber = userWhatsapp;
      print('$contactNumber -------------------------');
    }
  }

  @override
  Widget build(BuildContext context) {
    Textsize().init(context);
    return Scaffold(
        body: Container(
            height: Textsize.screenHeight,
            width: Textsize.screenWidth,
            color: Colors.white,
            child: Stack(
              children: [
                Container(
                    height: Textsize.screenHeight * 0.42,
                    width: Textsize.screenWidth,
                    decoration: BoxDecoration(
                        color: Color(0XFFFDAC2F),
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(150))),
                    child: Stack(children: [
                      Positioned(
                        top: 50,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.centerRight,
                          height: Textsize.screenHeight * 0.05,
                          width: Textsize.screenWidth,
                          child: Row(
                            children: [
                              Text("Dashboard",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400)),
                              Spacer(),
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            duration:
                                                Duration(milliseconds: 500),
                                            reverseDuration:
                                                Duration(milliseconds: 500),
                                            type:
                                                PageTransitionType.topToBottom,
                                            child: NotificationScreen()));
                                  },
                                  child: Obx(() => userdetailscontroller
                                              .isDataLoading.value ||
                                          admindetailsController
                                              .isDataLoading.value
                                      ? SizedBox(
                                          child:
                                              const CircularProgressIndicator(
                                            color: Color(0XFFFDAC2F),
                                            strokeWidth: 3,
                                          ),
                                          height: 2,
                                          width: 2,
                                        )
                                      : Stack(
                                          children: [
                                            Icon(
                                              Icons.notifications_outlined,
                                              color: Colors.white,
                                              size: 28,
                                            ),
                                            if (userdetailscontroller.details[
                                                    'notificationFlag'] ==
                                                1)
                                              Positioned(
                                                  right: 0,
                                                  child: new Container(
                                                    padding: EdgeInsets.all(1),
                                                    decoration:
                                                        new BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                    constraints: BoxConstraints(
                                                      minWidth: 12,
                                                      minHeight: 12,
                                                    ),
                                                  ))
                                          ],
                                        ))),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 100,
                        child: Container(
                            width: Textsize.screenWidth,
                            alignment: Alignment.center,
                            child: Obx(
                              () => userdetailscontroller.isDataLoading.value
                                  ? HomeScreenEffects()
                                  : Column(
                                      children: [
                                        Container(
                                            height:
                                                Textsize.screenHeight * 0.15,
                                            width: Textsize.screenHeight * 0.15,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100)),
                                            ),
                                            child: userdetailscontroller
                                                            .details[
                                                        'profile_image'] ==
                                                    null
                                                ? CircleAvatar(
                                                    backgroundImage: AssetImage(
                                                        "assets/images/doctor.jpg"),
                                                    maxRadius: 15,
                                                    minRadius: 15,
                                                  )
                                                : CircleAvatar(
                                                    backgroundImage: userdetailscontroller
                                                            .details[
                                                                'profile_image']
                                                            .startsWith('http')
                                                        ? NetworkImage(
                                                            userdetailscontroller
                                                                    .details[
                                                                'profile_image'])
                                                        : AssetImage(
                                                                "assets/images/doctor.jpg")
                                                            as ImageProvider<
                                                                Object>,
                                                    maxRadius: 15,
                                                    minRadius: 15,
                                                  )),
                                        Container(
                                          width: Textsize.screenWidth * 0.04,
                                        ),
                                        Container(
                                          height: Textsize.screenHeight * 0.01,
                                        ),
                                        Text(
                                          userdetailscontroller
                                                      .details['full_name'] !=
                                                  null
                                              ? "Hi, " +
                                                  userdetailscontroller
                                                      .details['full_name']
                                              : "Hi,Dr. Name",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          "Super Speciality",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: Textsize.subTitle,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400),
                                        )
                                      ],
                                    ),
                            )),
                      ),
                    ])),
                Positioned.fill(
                  top: 20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const StatisticsScreen()));
                                      },
                                      child: Container(
                                          height: Textsize.screenHeight * 0.22,
                                          width: Textsize.screenWidth * 0.38,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                blurRadius: 3.0,
                                                spreadRadius: 1,
                                                offset: const Offset(
                                                  2,
                                                  2,
                                                ),
                                              )
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    height: 80,
                                                    width: 80,
                                                    decoration: BoxDecoration(
                                                      color: Color(0XFF65A4C5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    child: ImageIcon(
                                                        AssetImage(
                                                            "assets/images/Statistics.png"),
                                                        size: 40,
                                                        color: Colors.white)),
                                              ),
                                              RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                      text: 'Statistics',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500)))
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const IncentiveScreen()));
                                      },
                                      child: Container(
                                          height: Textsize.screenHeight * 0.22,
                                          width: Textsize.screenWidth * 0.38,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                blurRadius: 3.0,
                                                spreadRadius: 1,
                                                offset: const Offset(
                                                  2,
                                                  2,
                                                ),
                                              )
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 80,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                    color: Color(0XFF65A4C5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                  child: ImageIcon(
                                                      AssetImage(
                                                          "assets/images/Incentive.png"),
                                                      size: 40,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                      text: 'Incentive',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500)))
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                              ])),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 60,
                  width: Textsize.screenWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             const ContactAdminChat()));
                                        var contact = contactNumber;
                                        var androidUrl =
                                            "whatsapp://send?phone=$contact&text=Hi";
                                        var iosUrl =
                                            "https://wa.me/$contact?text=${Uri.parse('Hi')}";

                                        try {
                                          if (Platform.isIOS) {
                                            await launchUrl(Uri.parse(iosUrl));
                                          } else {
                                            if (await launchUrl(
                                                Uri.parse(androidUrl))) {
                                              await launchUrl(
                                                  Uri.parse(androidUrl));
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      "WhatsApp is not installed on the device"),
                                                ),
                                              );
                                            }
                                          }
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                  "WhatsApp is not installed"),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                          height: Textsize.screenHeight * 0.22,
                                          width: Textsize.screenWidth * 0.38,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                blurRadius: 3.0,
                                                spreadRadius: 1,
                                                offset: const Offset(
                                                  2,
                                                  2,
                                                ),
                                              )
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    height: 80,
                                                    width: 80,
                                                    decoration: BoxDecoration(
                                                      color: Color(0XFF65A4C5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    child: ImageIcon(
                                                        AssetImage(
                                                            "assets/images/whatsappimage.png"),
                                                        size: 40,
                                                        color: Colors.white)),
                                              ),
                                              RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                      text: 'Contact Us',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500)))
                                            ],
                                          )),
                                    ),
                                    Container(
                                      height: Textsize.screenHeight * 0.01,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const SettingsScreen()));
                                      },
                                      child: Container(
                                          height: Textsize.screenHeight * 0.22,
                                          width: Textsize.screenWidth * 0.38,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                blurRadius: 3.0,
                                                spreadRadius: 1,
                                                offset: const Offset(
                                                  2,
                                                  2,
                                                ),
                                              )
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 80,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                    color: Color(0XFF65A4C5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                  child: ImageIcon(
                                                      AssetImage(
                                                          "assets/images/Setting.png"),
                                                      size: 40,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                      text: 'Settings',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500)))
                                            ],
                                          )),
                                    ),
                                    Container(
                                      height: Textsize.screenHeight * 0.01,
                                    ),
                                  ],
                                ),
                              ])),
                    ],
                  ),
                ),
              ],
            )));
  }
}
