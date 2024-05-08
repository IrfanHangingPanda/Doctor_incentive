import 'dart:convert';

import 'package:doctors_incentive/constant/url.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDetailsController extends GetxController {
  var isDataLoading = false.obs;
  Map adminDetails = {};

  Future<void> dataSendToServer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      isDataLoading(true);
      var response = await http.get(
        Uri.parse('${BaseUrl.url}/api/admin-details?key=adminContact'),
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
          "Authorization": 'Bearer $token'
        },
      );

      Map responseData = jsonDecode(response.body);
      print(responseData);

      adminDetails = responseData['data'];
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('whatsappNumber', adminDetails['data']['phone']);
      print(adminDetails);
    } catch (error) {
      print('catcherror');
      print(error);
    } finally {
      isDataLoading(false);
    }
  }
}
