import 'package:doctors_incentive/apiController/incentiveController.dart';
import 'package:doctors_incentive/apiController/notificationController.dart';
import 'package:doctors_incentive/apiController/updateStatusNo.dart';
import 'package:doctors_incentive/apiController/userDetailController.dart';

import 'package:doctors_incentive/model/textsize.dart';
import 'package:doctors_incentive/screens/information.dart';
import 'package:eraser/eraser.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  var notificationController = Get.put(NotificationController());
  var updateStatusnotification = Get.put(UpdateStatusNotController());
  var userdetailscontroller = Get.put(UserDetailsController());
  var incentiveController = Get.put(IncentiveController());
  var formattedDate;
  var formattedTime;

  @override
  void initState() {
    notificationController.dataSendToServer();

    Eraser.clearAllAppNotifications();

    super.initState();
  }

  showPopupMenu() {
    showMenu<String>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0),
      ),
      context: context,
      position: RelativeRect.fromLTRB(25.0, 75.0, 0.0, 0.0),
      items: [
        PopupMenuItem<String>(
            height: 25,
            onTap: () {
              setState(() {
                //  var allRead='ALL';
                updateStatusnotification.sendData('ALL');
                //markAllAsRead();
              });
            },
            child: Center(
              child: Text('Mark all as read',
                  style: TextStyle(
                    fontSize: Textsize.titleSize,
                    fontWeight: FontWeight.w500,
                  )),
            ))
      ],
      elevation: 8.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          elevation: 0,
          backgroundColor: Color(0XFFFDAC2F),
          title: const Text(
            'Notifications',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          actions: [
            InkWell(
                onTap: () {
                  showPopupMenu();
                },
                child: Icon(Icons.more_vert))
          ],
        ),
        body: Obx(
          () => notificationController.isDataLoading.value ||
                  userdetailscontroller.isDataLoading.value
              ? Center(
                  child: CircularProgressIndicator(
                  color: Color(0XFFFDAC2F),
                ))
              : Container(
                  color: Colors.white.withOpacity(0.0),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          notificationController.notificationDetails.isEmpty
                              ? Container(
                                  height: Textsize.screenHeight,
                                  width: Textsize.screenWidth,
                                  child: Center(
                                      child:
                                          Text("Notification not available")),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: notificationController
                                      .notificationDetails.length,
                                  itemBuilder: (context, index) {
                                    final Color tileColor =
                                        notificationController
                                                        .notificationDetails[
                                                    index]['read_status'] ==
                                                1
                                            ? Colors.white.withOpacity(0.0)
                                            : Colors.grey.withOpacity(0.1);
                                    var createdDate = notificationController
                                            .notificationDetails[index]
                                        ["created_at"];
                                    DateTime dateTime =
                                        DateTime.parse(createdDate);

                                    formattedDate = DateFormat('yyyy-MM-dd')
                                        .format(dateTime);
                                    print(formattedDate);
                                    formattedTime =
                                        DateFormat('HH:mm').format(dateTime);
                                    print(formattedTime);
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {},
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: InkWell(
                                              onTap: () {
                                                var notiId =
                                                    notificationController
                                                            .notificationDetails[
                                                        index]['id'];

                                                print("data");
                                                print(notiId);
                                                updateStatusnotification
                                                    .sendData(
                                                        notiId.toString());
                                                var monthDetails =
                                                    notificationController
                                                            .notificationDetails[
                                                        index]["date"];

                                                print('data');
                                                print(monthDetails);
                                                print('data');

                                                incentiveController
                                                    .monthinformation(
                                                        monthDetails,
                                                        incentiveController
                                                            .isYear = '0');

                                                Navigator.push(
                                                    context,
                                                    PageTransition(
                                                        type: PageTransitionType
                                                            .fade,
                                                        child:
                                                            InformationScreen()));
                                              },
                                              child: ListTile(
                                                tileColor:
                                                    tileColor, // Set color based on read status
                                                leading: const Icon(
                                                  Icons
                                                      .circle_notifications_sharp,
                                                  color: Color(0XFFFDAC2F),
                                                  size: 50,
                                                ),
                                                title: Text(
                                                    notificationController
                                                            .notificationDetails[
                                                        index]["title"]),
                                                subtitle: Text(
                                                    notificationController
                                                            .notificationDetails[
                                                        index]["messages"]),
                                                trailing: Text(
                                                    formattedDate.toString()),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                        ],
                      ),
                    ),
                  ),
                ),
        ));
  }
}
