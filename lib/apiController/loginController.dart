import 'dart:convert';

import 'package:doctors_incentive/apiController/sendOtpController.dart';
import 'package:doctors_incentive/constant/url.dart';
import 'package:doctors_incentive/model/textsize.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  var senddataotpcontroller = Get.put(SendOtp());

  final docIdController = TextEditingController();
  final passwordController = TextEditingController();
  var isDataLoading = false.obs;
  String userDoc_id = '';
  String userPassword = '';
  sendData(id, password, context) {
    userDoc_id = id;
    userPassword = password;
    dataSendToServer(context);
  }

  Future<void> dataSendToServer(context) async {
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
      print('islogin3');
      Map responseData = jsonDecode(response.body);
      print('islogin4');
      print("LOGIN ACREEN");
      print(responseData);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('token', responseData['data']['user']['token']);
      prefs.setString('whatsapp', responseData['data']['user']['whatsApp']);
      prefs.setString('defaultPass',
          responseData['data']['user']['default_password_reset'].toString());
      var data = responseData['data']['user']['default_password_reset'];

      if (data == 0) {
        await senddataotpcontroller.dataSendToServer(context);
        // Get.offAll(SendOtpScreen());
        docIdController.clear();
        passwordController.clear();
      } else {
        print('otpDetails=========');
        await senddataotpcontroller.dataSendToServer(context);
        //Get.offAll(SendOtpScreen());
        print('otpDetails=========');
        //Get.offAll(LandingScreen());
        docIdController.clear();
        passwordController.clear();
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
          messageText: Text('Please enter valid doctor id and password',
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
