import 'dart:convert';

import 'package:doctors_incentive/constant/url.dart';
import 'package:doctors_incentive/model/textsize.dart';
import 'package:doctors_incentive/screens/graphInformation.dart';
import 'package:doctors_incentive/screens/statistics_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaticsController extends GetxController {
  var isDataLoading = false.obs;
  List tableDetails = [].obs;
  List<ChartData> chartData = [];
  Map staticsData = {};
  var graph = <ChartDatagraph>[];
  var graphRevenue = <ChartDatagraph>[];
  var newPatient = <ChartDatagraph>[];
  String monthName = '';
  String isYear = '0';
  String fromdata = '';
  String todata = '';
  String isfilter = '';

  dateTimeData(data, year) {
    monthName = data;
    isYear = year;
    var params = {'month': monthName, 'is_year': isYear};
    dataSendToServer(params);
  }

  fromToData(fromDate, toDate) {
    fromdata = fromDate;
    todata = toDate;

    var params = {
      'from': fromdata.toString(),
      'is_year': '0',
      'to': todata.toString()
    };
    dataSendToServer(params);
  }

  Last12Month() {
    monthName = '';
    isYear = '0';
  }

  Future<void> dataSendToServer(params) async {
    Uri url = Uri.parse("${BaseUrl.url}/api/statistics");
    var newUri = url.replace(queryParameters: params);
    print('+------------------+');
    print(newUri);
    print('+------------------+');
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
      print(
          '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
      print(response.body);
      print(
          '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
      Map responseData = jsonDecode(response.body);
      print("responsedata");
      print(responseData);
      print(response.statusCode);
      print('===================');
      print("StaticsData1");
      if (response.statusCode == 200) {
        staticsData = responseData['data'];

        print("patientcount Details");
        if (monthName == '') {
          var staticPatientCount = staticsData['patient_count'];
          if (staticPatientCount.length != 0) {
            List dynamicList = [];

            staticPatientCount.forEach((key, value) {
              print('valueData');
              print(value);
              print('valueData');
              DateTime month = DateTime.parse(key);
              dynamicList
                  .add({'monthN': month.month, 'key': key, 'year': month.year});
            });

            for (var i = 0; i < dynamicList.length; i++) {
              if (dynamicList[i]['monthN'] == 1) {
                graph.add(
                  ChartDatagraph(
                      'Jan-${dynamicList[i]['year']}',
                      double.parse(
                          staticPatientCount["${dynamicList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicList[i]['monthN'] == 2) {
                graph.add(
                  ChartDatagraph(
                      'Feb-${dynamicList[i]['year']}',
                      double.parse(
                          staticPatientCount["${dynamicList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicList[i]['monthN'] == 3) {
                graph.add(
                  ChartDatagraph(
                      'Mar-${dynamicList[i]['year']}',
                      double.parse(
                          staticPatientCount["${dynamicList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicList[i]['monthN'] == 4) {
                graph.add(
                  ChartDatagraph(
                      'Apr-${dynamicList[i]['year']}',
                      double.parse(
                          staticPatientCount["${dynamicList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicList[i]['monthN'] == 5) {
                graph.add(
                  ChartDatagraph(
                      'May-${dynamicList[i]['year']}',
                      double.parse(
                          staticPatientCount["${dynamicList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicList[i]['monthN'] == 6) {
                graph.add(
                  ChartDatagraph(
                      'Jun-${dynamicList[i]['year']}',
                      double.parse(
                          staticPatientCount["${dynamicList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicList[i]['monthN'] == 7) {
                graph.add(
                  ChartDatagraph(
                      'Jul-${dynamicList[i]['year']}',
                      double.parse(
                          staticPatientCount["${dynamicList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicList[i]['monthN'] == 8) {
                graph.add(
                  ChartDatagraph(
                      'Aug-${dynamicList[i]['year']}',
                      double.parse(
                          staticPatientCount["${dynamicList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicList[i]['monthN'] == 9) {
                graph.add(
                  ChartDatagraph(
                      'Sep-${dynamicList[i]['year']}',
                      double.parse(
                          staticPatientCount["${dynamicList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicList[i]['monthN'] == 10) {
                graph.add(
                  ChartDatagraph(
                      'Oct-${dynamicList[i]['year']}',
                      double.parse(
                          staticPatientCount["${dynamicList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicList[i]['monthN'] == 11) {
                graph.add(
                  ChartDatagraph(
                      'Nov-${dynamicList[i]['year']}',
                      double.parse(
                          staticPatientCount["${dynamicList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicList[i]['monthN'] == 12) {
                graph.add(
                  ChartDatagraph(
                      'Dec-${dynamicList[i]['year']}',
                      double.parse(
                          staticPatientCount["${dynamicList[i]['key']}"]
                              .toString())),
                );
              }
              print("completed");
            }
          }

          //Revenue
          var staticRevenue = staticsData['revenues'];
          if (staticRevenue.length != 0) {
            print("revenue count details");
            print(staticRevenue);
            print("revenue count details");

            List dynamicRevenueList = [];
            staticRevenue.forEach((key, value) {
              print('revenuevalue');
              print(value);
              print('revenuevalue');
              DateTime month = DateTime.parse(key);
              dynamicRevenueList
                  .add({'monthN': month.month, 'key': key, 'year': month.year});
            });
            for (var i = 0; i < dynamicRevenueList.length; i++) {
              if (dynamicRevenueList[i]['monthN'] == 1) {
                graphRevenue.add(
                  ChartDatagraph(
                      'Jan-${dynamicRevenueList[i]['year']}',
                      double.parse(
                          staticRevenue["${dynamicRevenueList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicRevenueList[i]['monthN'] == 2) {
                graphRevenue.add(
                  ChartDatagraph(
                      'Feb-${dynamicRevenueList[i]['year']}',
                      double.parse(
                          staticRevenue["${dynamicRevenueList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicRevenueList[i]['monthN'] == 3) {
                graphRevenue.add(
                  ChartDatagraph(
                      'Mar-${dynamicRevenueList[i]['year']}',
                      double.parse(
                          staticRevenue["${dynamicRevenueList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicRevenueList[i]['monthN'] == 4) {
                graphRevenue.add(
                  ChartDatagraph(
                      'Apr-${dynamicRevenueList[i]['year']}',
                      double.parse(
                          staticRevenue["${dynamicRevenueList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicRevenueList[i]['monthN'] == 5) {
                graphRevenue.add(
                  ChartDatagraph(
                      'May-${dynamicRevenueList[i]['year']}',
                      double.parse(
                          staticRevenue["${dynamicRevenueList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicRevenueList[i]['monthN'] == 6) {
                graphRevenue.add(
                  ChartDatagraph(
                      'Jun-${dynamicRevenueList[i]['year']}',
                      double.parse(
                          staticRevenue["${dynamicRevenueList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicRevenueList[i]['monthN'] == 7) {
                graphRevenue.add(
                  ChartDatagraph(
                      'Jul-${dynamicRevenueList[i]['year']}',
                      double.parse(
                          staticRevenue["${dynamicRevenueList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicRevenueList[i]['monthN'] == 8) {
                graphRevenue.add(
                  ChartDatagraph(
                      'Aug-${dynamicRevenueList[i]['year']}',
                      double.parse(
                          staticRevenue["${dynamicRevenueList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicRevenueList[i]['monthN'] == 9) {
                graphRevenue.add(
                  ChartDatagraph(
                      'Sep-${dynamicRevenueList[i]['year']}',
                      double.parse(
                          staticRevenue["${dynamicRevenueList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicRevenueList[i]['monthN'] == 10) {
                graphRevenue.add(
                  ChartDatagraph(
                      'Oct-${dynamicRevenueList[i]['year']}',
                      double.parse(
                          staticRevenue["${dynamicRevenueList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicRevenueList[i]['monthN'] == 11) {
                graphRevenue.add(
                  ChartDatagraph(
                      'Nov-${dynamicRevenueList[i]['year']}',
                      double.parse(
                          staticRevenue["${dynamicRevenueList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicRevenueList[i]['monthN'] == 12) {
                graphRevenue.add(
                  ChartDatagraph(
                      'Dec-${dynamicRevenueList[i]['year']}',
                      double.parse(
                          staticRevenue["${dynamicRevenueList[i]['key']}"]
                              .toString())),
                );
              }
            }
          }
          //newpatient
          var staticNewPatient = staticsData['new_patient'];
          if (staticNewPatient.length != 0) {
            List dynamicPatientList = [];
            staticNewPatient.forEach((key, value) {
              DateTime month = DateTime.parse(key);
              dynamicPatientList
                  .add({'monthN': month.month, 'key': key, 'year': month.year});
            });
            for (var i = 0; i < dynamicPatientList.length; i++) {
              if (dynamicPatientList[i]['monthN'] == 1) {
                newPatient.add(
                  ChartDatagraph(
                      'Jan-${dynamicPatientList[i]['year']}',
                      double.parse(
                          staticNewPatient["${dynamicPatientList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicPatientList[i]['monthN'] == 2) {
                newPatient.add(
                  ChartDatagraph(
                      'Feb-${dynamicPatientList[i]['year']}',
                      double.parse(
                          staticNewPatient["${dynamicPatientList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicPatientList[i]['monthN'] == 3) {
                newPatient.add(
                  ChartDatagraph(
                      'Mar-${dynamicPatientList[i]['year']}',
                      double.parse(
                          staticNewPatient["${dynamicPatientList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicPatientList[i]['monthN'] == 4) {
                newPatient.add(
                  ChartDatagraph(
                      'Apr-${dynamicPatientList[i]['year']}',
                      double.parse(
                          staticNewPatient["${dynamicPatientList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicPatientList[i]['monthN'] == 5) {
                newPatient.add(
                  ChartDatagraph(
                      'May-${dynamicPatientList[i]['year']}',
                      double.parse(
                          staticNewPatient["${dynamicPatientList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicPatientList[i]['monthN'] == 6) {
                newPatient.add(
                  ChartDatagraph(
                      'Jun-${dynamicPatientList[i]['year']}',
                      double.parse(
                          staticNewPatient["${dynamicPatientList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicPatientList[i]['monthN'] == 7) {
                newPatient.add(
                  ChartDatagraph(
                      'Jul-${dynamicPatientList[i]['year']}',
                      double.parse(
                          staticNewPatient["${dynamicPatientList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicPatientList[i]['monthN'] == 8) {
                newPatient.add(
                  ChartDatagraph(
                      'Aug-${dynamicPatientList[i]['year']}',
                      double.parse(
                          staticNewPatient["${dynamicPatientList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicPatientList[i]['monthN'] == 9) {
                newPatient.add(
                  ChartDatagraph(
                      'Sep-${dynamicPatientList[i]['year']}',
                      double.parse(
                          staticNewPatient["${dynamicPatientList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicPatientList[i]['monthN'] == 10) {
                newPatient.add(
                  ChartDatagraph(
                      'Oct-${dynamicPatientList[i]['year']}',
                      double.parse(
                          staticNewPatient["${dynamicPatientList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicPatientList[i]['monthN'] == 11) {
                newPatient.add(
                  ChartDatagraph(
                      'Nov-${dynamicPatientList[i]['year']}',
                      double.parse(
                          staticNewPatient["${dynamicPatientList[i]['key']}"]
                              .toString())),
                );
              } else if (dynamicPatientList[i]['monthN'] == 12) {
                newPatient.add(
                  ChartDatagraph(
                      'Dec-${dynamicPatientList[i]['year']}',
                      double.parse(
                          staticNewPatient["${dynamicPatientList[i]['key']}"]
                              .toString())),
                );
              }
            }
          }

          //newpatient
        }

        if (monthName != '') {
          tableDetails = [
            {
              "month": "Discharge",
              "number": staticsData["discharge"]["number"],
              "lastMonth": staticsData["discharge"]["last_month"],
              "sameMonthLY": staticsData["discharge"]["last_year"]
            },
            {
              "month": "Follow-up",
              "number": staticsData["follow_up"]["number"],
              "lastMonth": staticsData["follow_up"]["last_month"],
              "sameMonthLY": staticsData["follow_up"]["last_year"]
            },
            {
              "month": "Consultations",
              "number": staticsData["consaltation"]["number"],
              "lastMonth": staticsData["consaltation"]["last_month"],
              "sameMonthLY": staticsData["consaltation"]["last_year"]
            },
            {
              "month": "M.Procedures",
              "number": staticsData["m_procedures"]["number"],
              "lastMonth": staticsData["m_procedures"]["last_month"],
              "sameMonthLY": staticsData["m_procedures"]["last_year"]
            },
            {
              "month": "LAB",
              "number": staticsData["lab"]["number"],
              "lastMonth": staticsData["lab"]["last_month"],
              "sameMonthLY": staticsData["lab"]["last_year"]
            },
            {
              "month": "CT",
              "number": staticsData["ct"]["number"],
              "lastMonth": staticsData["ct"]["last_month"],
              "sameMonthLY": staticsData["ct"]["last_year"]
            },
            {
              "month": "MRI",
              "number": staticsData["mri"]["number"],
              "lastMonth": staticsData["mri"]["last_month"],
              "sameMonthLY": staticsData["mri"]["last_year"]
            },
          ];
          print('++++++++++++++++++++++++++++++');
          print(staticsData);
          print('++++++++++++++++++++++++++++++');
          chartData = <ChartData>[
            ChartData('Discharge', staticsData["discharge"]["number"] + .0,
                Color(0XFFF66D44)),
            ChartData('Follow-up', staticsData["follow_up"]["number"] + .0,
                Color(0XFFFEAE65)),
            ChartData('Consultations',
                staticsData["consaltation"]["number"] + .0, Color(0XFFE6F69D)),
            ChartData('M.Procedures',
                staticsData["m_procedures"]["number"] + .0, Color(0XFFAADEA7)),
            ChartData(
                'LAB', staticsData["lab"]["number"] + .0, Color(0XFF64C2A6)),
            ChartData('CT', staticsData["ct"]["number"] + .0,
                Color.fromARGB(255, 0, 200, 255)),
            ChartData('MRI', staticsData["mri"]["number"] + .0,
                Color.fromARGB(255, 0, 119, 254)),
          ];
        }
      } else {
        Get.snackbar("", '',
            titleText: Text("error",
                style: TextStyle(
                    fontSize: Textsize.titleSize,
                    color: Colors.white,
                    fontWeight: FontWeight.w600)),
            messageText: Text(responseData['message'],
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
      print("Statics screen errror>>>>>>>>>>>>>>>>>>>>>$error");
    } finally {
      isDataLoading(false);
    }
  }
}
