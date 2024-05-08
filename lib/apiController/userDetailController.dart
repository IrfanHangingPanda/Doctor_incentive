import 'dart:convert';

import 'package:doctors_incentive/constant/url.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetailsController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  var isDataLoading = false.obs;
  Map details = {};
  var documentData = [];
  @override
  void onInit() {
    dataSendToServer();
    super.onInit();
  }

  Future<void> dataSendToServer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      isDataLoading(true);
      var response = await http.get(
        Uri.parse('${BaseUrl.url}/api/userProfile/detail'),
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
          "Authorization": 'Bearer $token'
        },
      );
      print('+++++++++++++++++++++++++++++++1');
      print(response.body);
      print(response.statusCode);
      print('+++++++++++++++++++++++++++++++2');
      Map responseData = jsonDecode(response.body);

      details = responseData['data'];

      documentData = details['attachment_file'];
      print(documentData);
      nameController.text =
          details['full_name'] != null ? details['full_name'] : '';
      emailController.text = details['email'] != null ? details['email'] : '';
      phoneController.text = details['phone'] != null ? details['phone'] : '';
    } catch (error) {
    } finally {
      isDataLoading(false);
    }
  }
}
