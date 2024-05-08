import 'dart:convert';

import 'package:doctors_incentive/constant/url.dart';
import 'package:doctors_incentive/model/textsize.dart';
import 'package:doctors_incentive/screens/forgetChangepass.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ForgetOtpController extends GetxController {
  var isDataLoading = false.obs;
  String otpData = '';

  sendData(context, otp) {
    otpData = otp;
    print('otp Data');
    print(otpData);
    print('otp Data2');

    dataSendToServer(context);
  }

  Future<void> dataSendToServer(context) async {
    print('verify otp');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var deviceToken = prefs.getString('tokenNotification');
    print(deviceToken);
    Map<String, dynamic> dataLoginBody = <String, dynamic>{
      'otp': otpData,
    };
    String dataToSend = json.encode(dataLoginBody);
    try {
      print('sendotp2');
      print(BaseUrl.url);
      isDataLoading(true);
      print('loading details');
      var response = await http.post(
        Uri.parse('${BaseUrl.url}/api/verify-otp'),
        body: dataToSend,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
        },
      );
      print('sendotp3');
      Map responseData = jsonDecode(response.body);
      print(response.statusCode);
      var message = responseData['message'];
      if (response.statusCode == 200) {
        print('sendotp4');
        print("OTP SCREEN");
        print(responseData);

        var keyotp = responseData['key'];
        Get.offAll(ForgetChangePass(otpKey: keyotp));
        ToastContext().init(context);
        Toast.show(
          "$message",
          duration: Toast.lengthShort,
          gravity: 0,
        );
        //  docIdController.clear();
        //  passwordController.clear();
      } else {
        Get.snackbar("", '',
            titleText: Text("Error",
                style: TextStyle(
                    fontSize: Textsize.titleSize,
                    color: Colors.white,
                    fontWeight: FontWeight.w600)),
            messageText: Text('$message',
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
      print('catch error');
      print(error);
      Get.snackbar("", '',
          titleText: Text("Error",
              style: TextStyle(
                  fontSize: Textsize.titleSize,
                  color: Colors.white,
                  fontWeight: FontWeight.w600)),
          messageText: Text('$error',
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
    } finally {
      isDataLoading(false);
    }
  }
}
