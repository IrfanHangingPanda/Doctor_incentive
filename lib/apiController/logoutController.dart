import 'package:doctors_incentive/constant/url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LogOutController extends GetxController {
  Future<void> dataSendToServer(token) async {
    try {
      await http.post(
        Uri.parse('${BaseUrl.url}/api/logout'),
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
          "Authorization": "Bearer $token"
        },
      );
    } catch (err) {}
  }
}
