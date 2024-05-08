import 'dart:convert';

import 'package:doctors_incentive/apiController/userDetailController.dart';
import 'package:doctors_incentive/constant/url.dart';

import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class UpdateProfileController extends GetxController {
  var userdetailcontroller = Get.put(UserDetailsController());
  var isDataLoading = false.obs;

  String userName = '';
  String userEmail = '';
  String userPhone = '';
  String userGender = '';
  sendData(context, initialGetUserData, name, email, phone, gender) {
    userName = name;
    userEmail = email;
    userPhone = phone;
    userGender = gender;
    dataSendToServer(context, initialGetUserData);
  }

  Future<void> dataSendToServer(context, initialGetUserData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    Map<String, dynamic> dataLoginBody = <String, dynamic>{
      'full_name': userName,
      'email': userEmail,
      'phone': userPhone,
      'gender_type': userGender
    };
    String dataToSend = json.encode(dataLoginBody);
    try {
      isDataLoading(true);
      var response = await http.post(
        Uri.parse('${BaseUrl.url}/api/userProfile/edit'),
        body: dataToSend,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
          "Authorization": 'Bearer $token'
        },
      );
      Map responseData = jsonDecode(response.body);
      print(responseData);
      userdetailcontroller.dataSendToServer();
      initialGetUserData();
      ToastContext().init(context);
      Toast.show(
        "profile updated succesfully ",
        duration: Toast.lengthShort,
        gravity: 0,
      );
    } catch (error) {
    } finally {
      isDataLoading(false);
    }
  }
}
