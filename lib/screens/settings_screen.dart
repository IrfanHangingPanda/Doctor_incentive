// ignore_for_file: unnecessary_null_comparison

import 'package:doctors_incentive/apiController/logoutController.dart';
import 'package:doctors_incentive/apiController/notificationStatus.dart';

import 'package:doctors_incentive/apiController/userDetailController.dart';
import 'package:doctors_incentive/components/settingScreen_effect.dart';
import 'package:doctors_incentive/model/textsize.dart';
import 'package:doctors_incentive/screens/ChangePassword.dart';

import 'package:doctors_incentive/screens/documentView_screen.dart';
import 'package:doctors_incentive/screens/edit_profile.dart';

import 'package:doctors_incentive/screens/login_screen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

void _launchURLApp() async {
  launchUrl(Uri.parse(
      'https://www.privacypolicygenerator.info/live.php?token=dzAD7lfLz4X0Ngpr7ZgwCeTjlm8yLjGf'));
}

void _launchURLAppterms() async {
  launchUrl(Uri.parse(
      'https://www.termsandconditionsgenerator.com/live.php?token=Unqoa2SXIWSa8IAautbF8BJDmAMM2LSP'));
}

class _SettingsScreenState extends State<SettingsScreen> {
  var logoutcontroller = Get.put(LogOutController());
  var userdetailscontroller = Get.put(UserDetailsController());
  var notiStatusController = Get.put(NotiStatusController());
  bool status = true;

  @override
  void initState() {
    userdetailscontroller.dataSendToServer();
    if (userdetailscontroller.details != null &&
        userdetailscontroller.details['notification_status'] != null) {
      if (userdetailscontroller.details['notification_status'] == 0) {
        status = false;
      } else {
        status = true;
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0XFFFDAC2F),
        centerTitle: true,
      ),
      body: SizedBox(
        height: Textsize.screenHeight,
        child: Stack(
          children: [
            Container(
                height: Textsize.screenHeight * 0.25,
                width: Textsize.screenWidth,
                color: Color(0XFFFDAC2F),
                child: Obx(() => userdetailscontroller.isDataLoading.value
                    ? SettingScreenEffects()
                    : ListTile(
                        leading: Container(
                            height: 60,
                            width: 60,
                            child: userdetailscontroller
                                        .details['profile_image'] ==
                                    null
                                ? CircleAvatar(
                                    backgroundColor: Colors.white,
                                  )
                                : CircleAvatar(
                                    backgroundImage: userdetailscontroller
                                            .details['profile_image']
                                            .startsWith('http')
                                        ? NetworkImage(userdetailscontroller
                                            .details['profile_image'])
                                        : AssetImage("assets/images/doctor.jpg")
                                            as ImageProvider<Object>,
                                  )),
                        title: Text(
                            userdetailscontroller.details['full_name'] != null
                                ? userdetailscontroller.details['full_name']
                                : 'User Name',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: Textsize.titleSize,
                                fontWeight: FontWeight.w500)),
                        subtitle: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const EditprofileScreen()));
                          },
                          child: Text("Tap to edit profile",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Textsize.subTitle,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ))),
            Positioned(
              top: 100,
              child: SingleChildScrollView(
                child: Container(
                  height: Textsize.screenHeight * 0.8,
                  width: Textsize.screenWidth,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: InkWell(
                          onTap: () {
                            _launchURLAppterms();
                          },
                          child: ListTile(
                            leading: ImageIcon(
                              AssetImage("assets/images/Privacy.png"),
                              size: 23,
                              color: Color(0XFF64a3c4),
                            ),
                            title: Text("Terms & Conditions",
                                style: TextStyle(
                                    fontSize: Textsize.titleSize,
                                    fontWeight: FontWeight.w500)),
                            trailing: Icon(Icons.keyboard_arrow_right_outlined),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _launchURLApp();
                        },
                        child: ListTile(
                          leading: ImageIcon(
                            AssetImage("assets/images/terms.png"),
                            size: 23,
                            color: Color(0XFF64a3c4),
                          ),
                          title: Text("Privacy Policy",
                              style: TextStyle(
                                  fontSize: Textsize.titleSize,
                                  fontWeight: FontWeight.w500)),
                          trailing: Icon(Icons.keyboard_arrow_right_outlined),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  duration: Duration(milliseconds: 350),
                                  reverseDuration: Duration(milliseconds: 350),
                                  type: PageTransitionType.rightToLeft,
                                  child: Changepassword()));
                        },
                        child: ListTile(
                          leading: Icon(
                            size: 24,
                            Icons.password,
                            color: Color(0XFF64a3c4),
                          ),
                          title: Text("Change Password",
                              style: TextStyle(
                                  fontSize: Textsize.titleSize,
                                  fontWeight: FontWeight.w500)),
                          trailing: Icon(Icons.keyboard_arrow_right_outlined),
                        ),
                      ),
                      ListTile(
                          leading: const Icon(
                            Icons.notifications,
                            color: Color(0XFF64a3c4),
                            size: 25,
                          ),
                          title: Text(
                            'Notification',
                            style: TextStyle(
                                fontSize: Textsize.titleSize,
                                fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text('You will recive dailly updates',
                              style: TextStyle(
                                  fontSize: Textsize.subTitle,
                                  color: const Color(0XFFC4C4C4))),
                          trailing: SizedBox(
                            height: 25,
                            width: 35,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: CupertinoSwitch(
                                activeColor: Color(0XFF64a3c4),
                                value: status,
                                onChanged: (value) {
                                  setState(() {
                                    status = value;
                                    print(status);
                                    var statusData;
                                    if (status == false) {
                                      statusData = 0;
                                    } else {
                                      statusData = 1;
                                    }

                                    notiStatusController.sendData(statusData);
                                  });
                                },
                              ),
                            ),
                          )),
                      InkWell(
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const DocumentViewScreen()));
                        },
                        child: ListTile(
                          leading: Icon(
                            size: 24,
                            Icons.picture_as_pdf,
                            color: Color(0XFF64a3c4),
                          ),
                          title: Text("View Documents",
                              style: TextStyle(
                                  fontSize: Textsize.titleSize,
                                  fontWeight: FontWeight.w500)),
                          trailing: Icon(Icons.keyboard_arrow_right_outlined),
                        ),
                      ),
                      Container(
                        height: Textsize.screenHeight * 0.1,
                      ),
                      InkWell(
                        onTap: () async {
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();

                          logoutcontroller
                              .dataSendToServer(preferences.getString('token'));
                          Get.offAll(LoginScreen());

                          for (String key in preferences.getKeys()) {
                            if (key != 'tokenNotification') {
                              preferences.remove(key);
                            }
                          }
                        },
                        child: ListTile(
                          leading: Icon(
                            size: 23,
                            Icons.logout,
                            color: Color(0XFF64a3c4),
                          ),
                          title: Text("Logout",
                              style: TextStyle(
                                  fontSize: Textsize.titleSize,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
