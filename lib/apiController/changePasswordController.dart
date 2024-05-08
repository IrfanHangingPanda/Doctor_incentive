import 'dart:convert';

import 'package:doctors_incentive/constant/url.dart';
import 'package:doctors_incentive/model/textsize.dart';
import 'package:doctors_incentive/screens/bottombar.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordController extends GetxController {
  // var senddataotpcontroller = Get.put(SendOtp());
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  var isDataLoading = false.obs;

  String oldPassword = '';
  String newPassword = '';
  sendData(context, oldpass, newpass) {
    oldPassword = oldpass;
    newPassword = newpass;

    dataSendToServer(context);
  }

  Future<void> dataSendToServer(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    Map<String, dynamic> dataLoginBody = <String, dynamic>{
      'old_password': oldPassword,
      'new_password': newPassword,
    };
    String dataToSend = json.encode(dataLoginBody);
    try {
      isDataLoading(true);
      var response = await http.post(
        Uri.parse('${BaseUrl.url}/api/change-password'),
        body: dataToSend,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
          "Authorization": 'Bearer $token'
        },
      );
      Map responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await prefs.setBool("isPasswordUpdate", true);
        Get.offAll(Bottombar());
        oldPasswordController.clear();
        newPasswordController.clear();
      } else {
        Get.snackbar("", '',
            titleText: Text("Failed",
                style: TextStyle(
                    fontSize: Textsize.titleSize,
                    color: Colors.white,
                    fontWeight: FontWeight.w600)),
            messageText: Text('${responseData['message']}',
                style: TextStyle(
                    fontSize: Textsize.subTitle,
                    color: Colors.white,
                    fontWeight: FontWeight.w500)),
            padding: EdgeInsets.only(left: 30),
            icon: Icon(Icons.error_outline, color: Color(0x15000000), size: 60),
            snackPosition: SnackPosition.TOP,
            borderRadius: 0,
            margin: const EdgeInsets.all(0),
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (error) {
    } finally {
      isDataLoading(false);
    }
  }
}
