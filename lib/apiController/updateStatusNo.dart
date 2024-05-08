import 'dart:convert';

import 'package:doctors_incentive/apiController/notificationController.dart';
import 'package:doctors_incentive/apiController/userDetailController.dart';

import 'package:doctors_incentive/constant/url.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateStatusNotController extends GetxController {
  var notificatiobcontroller = Get.put(NotificationController());
  var userdetailscontroller = Get.put(UserDetailsController());
  var isDataLoading = false.obs;

  var notificationId = '';
  var id;
  sendData(data) {
    notificationId = data;

    print(notificationId);
    dataSendToServer();
  }

  Future<void> dataSendToServer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    Map<String, dynamic> dataLoginBody = <String, dynamic>{
      'notificationKey':
          notificationId == 'ALL' ? notificationId : int.parse(notificationId),
    };
    String dataToSend = json.encode(dataLoginBody);

    try {
      isDataLoading(true);
      await http.post(
        Uri.parse('${BaseUrl.url}/api/notification/updateNotification'),
        body: dataToSend,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
          "Authorization": 'Bearer $token'
        },
      );

      notificatiobcontroller.dataSendToServer();
      userdetailscontroller.dataSendToServer();
    } catch (error) {
      print('Error decoding response: $error');
    } finally {
      isDataLoading(false);
    }
  }
}
