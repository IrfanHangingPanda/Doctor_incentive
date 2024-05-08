import 'dart:convert';

import 'package:doctors_incentive/constant/url.dart';
import 'package:doctors_incentive/model/textsize.dart';
import 'package:doctors_incentive/screens/login_screen.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgetChangePassController extends GetxController {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var isDataLoading = false.obs;

  String keyData = '';
  String newPassword = '';
  sendData(context, newpass, keydata) {
    newPassword = newpass;
    keyData = keydata;
    print(newPassword);
    print(keyData);
    dataSendToServer(context);
  }

  Future<void> dataSendToServer(context) async {
    void _confirmationModal(BuildContext contex) {
      showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40)),
          ),
          backgroundColor: Colors.white,
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(100)),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Password change succesfully',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Color(0XFFFDAC2F),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4))),
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const Bottombar()));
                        Get.offAll(LoginScreen());

                        confirmPasswordController.clear();
                        newPasswordController.clear();
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                        child: Text(
                          "Ok",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ))
                ],
              ),
            );
          });
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    Map<String, dynamic> dataLoginBody = <String, dynamic>{
      'key': keyData,
      'password': newPassword,
    };
    String dataToSend = json.encode(dataLoginBody);
    try {
      isDataLoading(true);
      var response = await http.post(
        Uri.parse('${BaseUrl.url}/api/update-password'),
        body: dataToSend,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
          "Authorization": 'Bearer $token'
        },
      );
      Map responseData = jsonDecode(response.body);
      print(responseData);
      if (response.statusCode == 200) {
        _confirmationModal(context);
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
