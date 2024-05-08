import 'dart:convert';

import 'dart:io';

import 'package:doctors_incentive/apiController/userDetailController.dart';
import 'package:doctors_incentive/constant/url.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfileImageController extends GetxController {
  var userdetailcontroller = Get.put(UserDetailsController());
  var isDataLoading = false.obs;
  List image = [].obs;
  String userImage = '';

  sendData(context, image) async {
    Future<String> imageToBase64(String? image) async {
      if (image == null) {
        // Handle the case where 'image' is null, e.g., show an error message
        print('Image is null');
        return ''; // You might want to return something appropriate or throw an exception
      }

      File imageFile = File(image);
      if (!imageFile.existsSync()) {
        // Handle the case where the file does not exist, e.g., show an error message
        print('Image file does not exist');
        return ''; // You might want to return something appropriate or throw an exception
      }

      List<int> imageBytes = await imageFile.readAsBytes();

      String base64Image = "data:image/png;base64," + base64Encode(imageBytes);

      return base64Image;
    }

    String base64Image = await imageToBase64(image);

    userImage = base64Image.toString();

    dataSendToServer(context);
  }

  Future<void> dataSendToServer(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    Map<String, dynamic> dataLoginBody = <String, dynamic>{
      'profile_image': userImage,
    };
    String dataToSend = json.encode(dataLoginBody);
    try {
      isDataLoading(true);
      var response = await http.post(
        Uri.parse('${BaseUrl.url}/api/userProfile/imageUpdate'),
        body: dataToSend,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
          "Authorization": 'Bearer $token'
        },
      );
      print(
          '---------------------------------------------------------------------update profile11');
      print(response.body);
      print(response.statusCode);
      print(
          '---------------------------------------------------------------------update profile');
      userdetailcontroller.dataSendToServer();
    } catch (error) {
    } finally {
      isDataLoading(false);
    }
  }
}
