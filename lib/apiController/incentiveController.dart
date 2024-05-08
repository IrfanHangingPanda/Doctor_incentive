import 'dart:convert';

import 'package:doctors_incentive/constant/url.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IncentiveController extends GetxController {
  var isDataLoading = false.obs;
  List dynamicList = [].obs;
  List netIncentiveList = [].obs;
  List documentData = [].obs;

  List netincentiveDetails = [].obs;
  var selectedYear = '';
  var yearname = '';
  var infoYearName = '';
  var calculativeIncentive = '';
  var netIncentive = '';
  var drDebitInvoice = '';
  //Map incentives = {};
  Map<String, dynamic> incentives = {};

  String isYear = '1';
  String yearData = '';
  String monthName = '';
  bool isMonthInformation = false;
  bool isfilterData = false;

  filterData(filterYear, isyear) {
    yearData = filterYear;
    var params = {
      'year': yearData,
      'is_year': isYear,
    };
    dataSendToServer(params);
  }

  monthinformation(data, yearN) {
    isMonthInformation = true;
    monthName = data;
    var params = {
      'month': monthName,
      'is_year': yearN,
    };

    dataSendToServer(params);
  }

  Future<void> dataSendToServer(params) async {
    Uri url = Uri.parse("${BaseUrl.url}/api/incentive");
    var newUri = url.replace(queryParameters: params);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      isDataLoading(true);
      var response = await http.get(
        newUri,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
          "Authorization": 'Bearer $token'
        },
      );
      print('---------------------------------------------->>>>>>>1');
      print(response.body);
      print(response.statusCode);
      print('---------------------------------------------->>>>>>>2');
      if (response.statusCode == 200) {
        Map responseData = jsonDecode(response.body);

        if (responseData['data']['document'] != null) {
          documentData = responseData['data']['document'];
        }

        if (isYear == '1') {
          yearname = responseData['data']['year'];
          selectedYear = yearname;
          var incentiveData = responseData['data']['incentive'];
          incentiveData.forEach((key, value) {
            DateTime month = DateTime.parse(key);
            dynamicList.add({
              'monthN': month.month,
              'key': key,
              'year': month.year,
              'value': incentiveData[key],
              'lable': Moment(month).format("MMM-YYYY")
            });
          });
        }

        if (isYear == '0') {
          var dateformate = responseData['data']['year'];
          print(dateformate);
          String dateString = dateformate;
          DateTime date = DateFormat('yyyy-MM').parse(dateString);

          infoYearName = DateFormat('MMM-yyyy').format(date);
          incentives = responseData['data']['dr_debit_invoice_details'];

          netincentiveDetails =
              responseData['data']['calculated_incentive_details'];
        }

        calculativeIncentive =
            responseData['data']['calculated_incentive'].toString();
        netIncentive = responseData['data']['net_incentive'].toString();
        drDebitInvoice = responseData['data']['dr_debit_invoice'].toString();

        netIncentiveList = [
          {
            "incentive": "Calculated Incentive",
            "detail": calculativeIncentive,
          },
          {
            "incentive": "DR Invoice & Other debits",
            "detail": drDebitInvoice,
          },
        ];
      }
    } catch (error) {
      print('error->>>$error');
    } finally {
      isDataLoading(false);
    }
  }
}
