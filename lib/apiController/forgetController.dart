import 'dart:convert';

import 'package:doctors_incentive/apiController/sendOtpController.dart';
import 'package:doctors_incentive/constant/url.dart';
import 'package:doctors_incentive/model/textsize.dart';
import 'package:doctors_incentive/screens/forgetSendcode.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ForgetController extends GetxController {
  var senddataotpcontroller = Get.put(SendOtp());
  final docIdController = TextEditingController();

  var isDataLoading = false.obs;
  String userDoc_id = '';

  sendData(context, id) {
    userDoc_id = id;

    dataSendToServer(context);
  }

  Future<void> dataSendToServer(context) async {
    print('islogin');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var deviceToken = prefs.getString('tokenNotification');
    print(deviceToken);
    Map<String, dynamic> dataLoginBody = <String, dynamic>{
      'doctor_id': userDoc_id,
    };
    String dataToSend = json.encode(dataLoginBody);
    try {
      print('islogin2');
      print(BaseUrl.url);
      isDataLoading(true);
      print('loading details');
      var response = await http.post(
        Uri.parse('${BaseUrl.url}/api/reset-password'),
        body: dataToSend,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
        },
      );
      print('islogin3');
      Map responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('islogin4');
        print("LOGIN ACREEN");
        print(responseData);
        // await senddataotpcontroller.dataSendToServer(context);
        //   Get.offAll(SendOtpScreen(otpData: userDoc_id));
        print(userDoc_id);
        Get.offAll(ForgetSendOtpScreen(doctorId: userDoc_id));
        docIdController.clear();
        ToastContext().init(context);
        Toast.show(
          "Otp send successfully",
          duration: Toast.lengthShort,
          gravity: 0,
        );
        //  passwordController.clear();
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
