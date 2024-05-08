import 'dart:convert';

import 'package:doctors_incentive/constant/url.dart';

import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationController extends GetxController {
  var isDataLoading = false.obs;
  List notificationDetails = [];

  Future<void> dataSendToServer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      isDataLoading(true);
      var response = await http.get(
        Uri.parse('${BaseUrl.url}/api/notification/'),
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
          "Authorization": 'Bearer $token'
        },
      );

      Map responseData = jsonDecode(response.body);

      notificationDetails = responseData['data'];
    } catch (error) {
    } finally {
      isDataLoading(false);
    }
  }
}
