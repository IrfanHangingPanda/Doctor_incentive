import 'dart:convert';

import 'package:doctors_incentive/constant/url.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';

class LockupController extends GetxController {
  var isDataLoading = false.obs;
  List lockupData = [].obs;
  @override
  void onInit() {
    dataSendToServer();
    super.onInit();
  }

  Future<void> dataSendToServer() async {
    try {
      isDataLoading(true);
      var response = await http.get(
        Uri.parse('${BaseUrl.url}/api/list/?key=genderType'),
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
        },
      );
      Map responseData = jsonDecode(response.body);
      lockupData = responseData['data'];
    } catch (error) {
    } finally {
      isDataLoading(false);
    }
  }
}
