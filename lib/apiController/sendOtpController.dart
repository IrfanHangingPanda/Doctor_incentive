import 'dart:convert';

import 'package:doctors_incentive/constant/url.dart';
import 'package:doctors_incentive/model/textsize.dart';
import 'package:doctors_incentive/screens/ChangePassword.dart';
import 'package:doctors_incentive/screens/otpScreen.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class SendOtp extends GetxController {
//  var loginController = Get.put(LoginController());
  var isDataLoading = false.obs;

  var message;
  var otpData;

  Future<void> dataSendToServer(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      print('otp details 1------##');
      isDataLoading(true);
      var response = await http.get(
        Uri.parse('${BaseUrl.url}/api/notification/sendOtp'),
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
          "Authorization": 'Bearer $token'
        },
      );
      print(
          '${response.statusCode}+++++++++++++++++++++++++++${response.body}');
      Map responseData = jsonDecode(response.body);
      print('otp details 2----------###');
      print(responseData);
      print('otp details 3');
      message = responseData['message'];
      otpData = responseData['otp'];
      print('otp details 4');
      print("OTP AFTER LOGIN==============$otpData");

      if (response.statusCode == 200) {
        print('otp details 5');
        // loginController.docIdController.clear();
        // loginController.passwordController.clear();
        if (otpData == '') {
          print('otp details 6');
          Get.offAll(Changepassword());
          Get.snackbar("", '',
              titleText: Text("Failed",
                  style: TextStyle(
                      fontSize: Textsize.titleSize,
                      color: Colors.white,
                      fontWeight: FontWeight.w600)),
              messageText: Text(message,
                  style: TextStyle(
                      fontSize: Textsize.subTitle,
                      color: Colors.white,
                      fontWeight: FontWeight.w500)),
              padding: EdgeInsets.only(left: 30),
              icon:
                  Icon(Icons.error_outline, color: Color(0x15000000), size: 60),
              snackPosition: SnackPosition.TOP,
              borderRadius: 0,
              margin: const EdgeInsets.all(0),
              backgroundColor: Colors.red,
              colorText: Colors.white);
        } else {
          Get.offAll(SendOtpScreen(otpData: otpData.toString()));
          print('otp details 7');
          ToastContext().init(context);
          Toast.show(
            message,
            duration: Toast.lengthShort,
            gravity: 0,
          );
        }
      }
    } catch (error) {
      print("catch error=======otp error======$error");
    } finally {
      isDataLoading(false);
    }
  }
}
