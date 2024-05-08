import 'dart:convert';

import 'package:doctors_incentive/constant/url.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotiStatusController extends GetxController {
  var isDataLoading = false.obs;

  var notiStatus;

  sendData(data) {
    notiStatus = data;

    dataSendToServer();
  }

  Future<void> dataSendToServer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    Map<String, dynamic> dataLoginBody = <String, dynamic>{
      'status': notiStatus,
    };
    String dataToSend = json.encode(dataLoginBody);

    try {
      isDataLoading(true);
      var response = await http.post(
        Uri.parse('${BaseUrl.url}/api/notification/statusUpdate'),
        body: dataToSend,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
          "Authorization": 'Bearer $token'
        },
      );

      Map responseData = jsonDecode(response.body);

      print(responseData);
    } catch (error) {
    } finally {
      isDataLoading(false);
    }
  }
}
