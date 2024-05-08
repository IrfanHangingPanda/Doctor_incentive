import 'dart:convert';

import 'package:doctors_incentive/apiController/adminChatController.dart';
import 'package:doctors_incentive/constant/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactAdminController extends GetxController {
  var adminchatGetController = Get.put(AdminChatController());
  final messageController = TextEditingController();
  var isDataLoading = false.obs;
  String messageData = '';
  List chatPostDetails = [];
  sendData(message) {
    messageData = message;

    dataSendToServer();
  }

  Future<void> dataSendToServer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print(token);
    Map<String, dynamic> dataLoginBody = <String, dynamic>{
      'message': messageData,
    };
    String dataToSend = json.encode(dataLoginBody);
    try {
      isDataLoading(true);
      var response = await http.post(
        Uri.parse('${BaseUrl.url}/api/chats/message'),
        body: dataToSend,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
          "Authorization": 'Bearer $token'
        },
      );
      Map responseData = jsonDecode(response.body);
      chatPostDetails = responseData['data'];

      adminchatGetController.dataSendToServer();
      messageController.clear();
    } finally {
      isDataLoading(false);
    }
  }
}
