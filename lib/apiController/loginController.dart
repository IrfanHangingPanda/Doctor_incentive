import 'dart:convert';

import 'package:doctors_incentive/apiController/sendOtpController.dart';
import 'package:doctors_incentive/constant/url.dart';
import 'package:doctors_incentive/model/textsize.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/homePagescreen.dart';

class LoginController extends GetxController {
  var senddataotpcontroller = Get.put(SendOtp());

  final docIdController = TextEditingController();
  final passwordController = TextEditingController();
  var isDataLoading = false.obs;
  String userDoc_id = '';
  String userPassword = '';
  sendData(fromAuthorization, id, password, isRemember, context) {
    userDoc_id = id;
    userPassword = password;
    dataSendToServer(fromAuthorization, isRemember, context);
  }

  Future<void> dataSendToServer(fromAuthorization, isRemember, context) async {
    print('islogin');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var deviceToken = prefs.getString('tokenNotification');
    print(deviceToken);
    Map<String, dynamic> dataLoginBody = <String, dynamic>{
      'dr_id': userDoc_id,
      'password': userPassword,
      'token': deviceToken
    };
    String dataToSend = json.encode(dataLoginBody);
    try {
      print('islogin2');
      print(BaseUrl.url);
      isDataLoading(true);
      print('loading details');
      var response = await http.post(
        Uri.parse('${BaseUrl.url}/api/login'),
        body: dataToSend,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
        },
      );

      Map responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('token', responseData['data']['user']['token']);
        prefs.setString('whatsapp', responseData['data']['user']['whatsApp']);
        prefs.setString('defaultPass',
            responseData['data']['user']['default_password_reset'].toString());
        var data = responseData['data']['user']['default_password_reset'];

        //
        if (fromAuthorization == true) {
          Get.offAll(HomePageScreen());
        } else {
          if (isRemember == true) {
            await prefs.setString('doctor_id', userDoc_id);
            await prefs.setString('doctor_password', userPassword);
          } else {
            if (prefs.getString('doctor_id') != null &&
                prefs.getString('doctor_password') != null) {
              prefs.remove('doctor_id');
              prefs.remove('doctor_password');
            }
          }
          if (data == 0) {
            await senddataotpcontroller.dataSendToServer(context);

            docIdController.clear();
            passwordController.clear();
          } else {
            await senddataotpcontroller.dataSendToServer(context);

            docIdController.clear();
            passwordController.clear();
          }
        }
      } else {
        errorMessage(responseData['message']);
      }
    } catch (error) {
      print('catch error');
      print(error);
      errorMessage(error);
    } finally {
      isDataLoading(false);
    }
  }

  errorMessage(text) {
    Get.snackbar("", '',
        titleText: Text("Error",
            style: TextStyle(
                fontSize: Textsize.titleSize,
                color: Colors.white,
                fontWeight: FontWeight.w600)),
        messageText: Text(text.toString(),
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
}
