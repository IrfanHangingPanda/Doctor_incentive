import 'package:doctors_incentive/apiController/staticsController.dart';
import 'package:doctors_incentive/components/graphInformationEffect.dart';
import 'package:doctors_incentive/components/statisticsEffects.dart';
import 'package:doctors_incentive/model/textsize.dart';
import 'package:doctors_incentive/screens/graphInformation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toast/toast.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with WidgetsBindingObserver {
  var staticsDatacontroller = Get.put(StaticsController());
  TextEditingController fromMonthController = TextEditingController();
  TextEditingController toMonthController = TextEditingController();
  late List<_ChartData> dataA;
  late List<_ChartData> dataB;
  late List<_ChartData> dataC;
  late TooltipBehavior _tooltipA;
  late TooltipBehavior _tooltipB;
  late TooltipBehavior _tooltipC;

  bool graph = false;
  bool clock = false;
  bool from = true;
  bool to = false;

  var monthNameshow = '';
  var fromDate = '';
  var toDate = '';
  bool cliprectGraph = false;
  bool cliprectClock = false;
  List<_ChartData> chartData = [
    _ChartData('A', 10),
    _ChartData('B', 20),
    _ChartData('C', 30),
    _ChartData('D', 40),
  ];
  @override
  void initState() {
    super.initState();
    staticsDatacontroller.monthName = '';
    var params = {
      'is_year': staticsDatacontroller.isYear,
    };

    staticsDatacontroller.dataSendToServer(params);
    staticsDatacontroller.graph.clear();
    staticsDatacontroller.graphRevenue.clear();
    staticsDatacontroller.newPatient.clear();
    clock = true;
    _tooltipA = TooltipBehavior(enable: true, header: "");

    _tooltipB = TooltipBehavior(enable: true, header: "");
    _tooltipC = TooltipBehavior(enable: true, header: "");
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context, year) async {
    showMonthPicker(
      context: context,
      firstDate: DateTime(2022),
      lastDate: DateTime(2070),
      selectableMonthPredicate: (DateTime) {
        return true;
      },
      customHeight: 250,
      customWidth: 850,
      confirmWidget: Text(
        "OK",
        style: TextStyle(color: Color(0XFFffaa2f), fontWeight: FontWeight.w700),
      ),
      cancelWidget: Text(
        "CANCEL",
        style: TextStyle(color: Color(0XFFffaa2f), fontWeight: FontWeight.w700),
      ),
      headerColor: Color(0XFF64a3c4),
      selectedMonthBackgroundColor: Color(0XFF64a3c4),
      unselectedMonthTextColor: Color(0XFF64a3c4),
      initialDate: DateTime.now(),
    ).then((date) {
      if (date != null) {
        setState(() {
          clock = false;
          graph = true;

          selectedDate = date;

          var dateTimeformate = DateTime.parse(selectedDate.toString());
          var monthLength = dateTimeformate.month.toString();

          var month = monthLength.length == 1
              ? "0${dateTimeformate.month}"
              : "${dateTimeformate.month}";
          var dateTime = "${dateTimeformate.year}-$month-01";
          print('-----');
          monthNameshow = DateFormat('MMM-yyyy').format(selectedDate);
          print(monthNameshow);
          staticsDatacontroller.dateTimeData(dateTime, year);
        });
      }
    });
  }

  var fromMonthname;
  var toMonthname;
  Future<void> _selectmonth(BuildContext context, year, type) async {
    showMonthPicker(
      context: context,
      firstDate: DateTime(2022),
      lastDate: DateTime(2070),
      customHeight: 250,
      customWidth: 850,
      headerColor: Color(0XFF64a3c4),
      selectedMonthBackgroundColor: Color(0XFF64a3c4),
      unselectedMonthTextColor: Color(0XFF64a3c4),
      confirmWidget: Text(
        "OK",
        style: TextStyle(color: Color(0XFFffaa2f), fontWeight: FontWeight.w700),
      ),
      cancelWidget: Text(
        "CANCEL",
        style: TextStyle(color: Color(0XFFffaa2f), fontWeight: FontWeight.w700),
      ),
      initialDate: DateTime.now(),
    ).then((date) {
      if (date != null) {
        setState(() {
          selectedDate = date;
          var formate = DateTime.parse(selectedDate.toString());
          var monthLength = formate.month.toString();

          var monthdata = monthLength.length == 1
              ? "0${formate.month}"
              : "${formate.month}";

          if (type == 'from') {
            fromMonthname = DateFormat('MMMM').format(selectedDate);
            fromDate = "${formate.year}-$monthdata-01";
            fromMonthController.text = fromMonthname;
          } else {
            toMonthname = DateFormat('MMMM').format(selectedDate);
            toDate = "${formate.year}-$monthdata-01";
            toMonthController.text = toMonthname;
          }

          print(fromDate);
          print(toDate);
        });
      }
    });
  }

  Future<void> _showmonthDialog() async {
    return showDialog<void>(
      context: context,

      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // <-- SEE HERE
          title: const Text('Select month'),

          content: SingleChildScrollView(
            child: ListBody(
              children: [
                InkWell(
                  onTap: () {
                    _selectmonth(context, '0', 'from');
                    setState(() {
                      from = true;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("From :",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0XFFffaa2f),
                                fontWeight: FontWeight.w700)),
                        Row(
                          children: [
                            Container(
                              height: 40,
                              width: 90,
                              //color: Colors.amber,
                              child: TextFormField(
                                controller: fromMonthController,
                                decoration: InputDecoration(
                                  hintText: "Month",
                                  hintStyle: TextStyle(
                                    fontSize: 16,
                                  ),
                                  border: InputBorder.none,
                                ),
                                readOnly: true,
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectmonth(context, '0', 'to');
                      from = false;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: 130,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("To :",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0XFFffaa2f),
                                fontWeight: FontWeight.w700)),
                        Row(
                          children: [
                            Container(
                              height: 40,
                              width: 90,
                              //color: Colors.amber,
                              child: TextFormField(
                                //textAlign: TextAlign.center,
                                controller: toMonthController,
                                decoration: InputDecoration(
                                  hintText: "Month",
                                  hintStyle: TextStyle(
                                    fontSize: 16,
                                  ),
                                  border: InputBorder.none,
                                ),
                                readOnly: true,
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.w700)),
              onPressed: () {
                fromMonthController.clear();
                toMonthController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.w700)),
              onPressed: () {
                if (fromDate.isNotEmpty && toDate.isNotEmpty) {
                  print('object');
                  var dt1 = DateTime.parse(fromDate);
                  var dt2 = DateTime.parse(toDate);

                  if (dt1.isAtSameMomentAs(dt2)) {
                    ToastContext().init(context);

                    Toast.show("'From'and'To'months are same salect another",
                        duration: 1, gravity: Toast.top);
                    fromDate = '';
                    toDate = '';
                  } else if (dt1.isAfter(dt2)) {
                    ToastContext().init(context);

                    Toast.show("'To'month should be next to'From'month",
                        duration: Toast.lengthShort, gravity: Toast.top);
                    fromDate = '';
                    toDate = '';
                  } else if (dt1.isBefore(dt2)) {
                    staticsDatacontroller.graph.clear();
                    staticsDatacontroller.graphRevenue.clear();
                    staticsDatacontroller.newPatient.clear();
                    staticsDatacontroller.fromToData(
                      fromDate,
                      toDate,
                    );
                    fromDate = '';
                    toDate = '';
                    Navigator.of(context).pop();
                  }
                }

                fromMonthController.clear();
                toMonthController.clear();
              },
            ),
          ],
        );
      },
    );
  }

  int _selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0XFFFDAC2F),
        title: Text(
          ' Statistics',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        actions: [
          if (clock)
            IconButton(
                onPressed: () {
                  setState(() {
                    _showmonthDialog();
                  });
                },
                icon: Icon(Icons.filter_alt_sharp)),
        ],
      ),
      body: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: Color(0XFF64a3c4),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 100,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          staticsDatacontroller.Last12Month();

                          clock = true;
                          graph = false;

                          setState(() {});
                        },
                        child: clock == true
                            ? ClipPath(
                                clipper: ClipperStack(),
                                child: Container(
                                  height: Textsize.screenHeight * 0.07,
                                  decoration: BoxDecoration(
                                      color: graph == false
                                          ? Color(0XFF64a3c4)
                                          : Colors.grey.shade400,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 10, left: 10, right: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.access_time_outlined,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                        Container(
                                          width: Textsize.screenWidth * 0.01,
                                        ),
                                        Text("Last 12 Month",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600))
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.all(10),
                                height: Textsize.screenHeight * 0.07,
                                decoration: BoxDecoration(
                                    color: graph == false
                                        ? Color(0XFF64a3c4)
                                        : Colors.grey.shade400,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.access_time_outlined,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                    Container(
                                      width: Textsize.screenWidth * 0.01,
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text("Last 12 Month",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600)),
                                    )
                                  ],
                                ),
                              ),
                      ),
                      InkWell(
                        onTap: () {
                          graph = true;
                          clock = false;
                          setState(() {});

                          _selectDate(context, '0');
                        },
                        child: graph == true
                            ? ClipPath(
                                clipper: ClipperStack(),
                                child: Container(
                                  //padding: EdgeInsets.all(10),
                                  height: Textsize.screenHeight * 0.07,
                                  decoration: BoxDecoration(
                                      color: clock == false
                                          ? Color(0XFF64a3c4)
                                          : Colors.grey.shade400,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 10, left: 10, right: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.calendar_month,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                        Container(
                                          width: Textsize.screenWidth * 0.01,
                                        ),
                                        Text(
                                          "Current month",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.all(10),
                                height: Textsize.screenHeight * 0.07,
                                decoration: BoxDecoration(
                                    color: clock == false
                                        ? Color(0XFF64a3c4)
                                        : Colors.grey.shade400,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.calendar_month,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    Container(
                                      width: Textsize.screenWidth * 0.01,
                                    ),
                                    Text(
                                      "Current month",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: Textsize.screenHeight * 0.01,
                ),
                if (graph == true)
                  Container(
                    child: Text(
                      monthNameshow,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                  ),
                Container(
                  height: Textsize.screenHeight * 0.01,
                ),
                if (graph == true)
                  Obx(() => staticsDatacontroller.isDataLoading.value
                      ? Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: GraphInfoEffects(),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            children: [
                              Card(
                                borderOnForeground: false,
                                color: Colors.white,
                                elevation: 0.5,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.white70, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                        child: Table(columnWidths: const {
                                      0: FlexColumnWidth(3.0),
                                      1: FlexColumnWidth(1.6),
                                      2: FlexColumnWidth(1.6),
                                      3: FlexColumnWidth(2.3),
                                    }, children: [
                                      TableRow(
                                          decoration: BoxDecoration(
                                              color: Color(0XFF64a3c4),
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  topRight:
                                                      Radius.circular(15))),
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              height: 50,
                                              child: Text("",
                                                  style: TextStyle(
                                                      fontSize:
                                                          Textsize.titleSize,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              height: 50,
                                              child: Text(
                                                "Number",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize:
                                                        Textsize.titleSize,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              height: 50,
                                              child: Text(
                                                "Last Month",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize:
                                                        Textsize.titleSize,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.centerRight,
                                              height: 50,
                                              child: Text(
                                                "Same Month LY",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize:
                                                        Textsize.titleSize,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ])
                                    ])),
                                    Container(
                                        child: Table(
                                            columnWidths: const {
                                          0: FlexColumnWidth(3.0),
                                          1: FlexColumnWidth(1.6),
                                          2: FlexColumnWidth(1.6),
                                          3: FlexColumnWidth(2.3),
                                        },
                                            children: List<TableRow>.generate(
                                                staticsDatacontroller
                                                    .tableDetails
                                                    .length, (index) {
                                              return TableRow(
                                                  decoration: BoxDecoration(
                                                      color: index % 2 != 0
                                                          ? Colors.white
                                                          : Colors.blueGrey
                                                              .withOpacity(
                                                                  0.1)),
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 50,
                                                      child: Text(
                                                        staticsDatacontroller
                                                            .tableDetails[index]
                                                                ['month']
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: Textsize
                                                                .subTitle,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: 50,
                                                      child: Text(
                                                        staticsDatacontroller
                                                            .tableDetails[index]
                                                                ['number']
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: Textsize
                                                                .subTitle,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: 50,
                                                      child: Text(
                                                        staticsDatacontroller
                                                            .tableDetails[index]
                                                                ['lastMonth']
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: Textsize
                                                                .subTitle,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: 50,
                                                      child: Text(
                                                        staticsDatacontroller
                                                            .tableDetails[index]
                                                                ['sameMonthLY']
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: Textsize
                                                                .subTitle,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                  ]);
                                            }))),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                  margin: EdgeInsets.all(5),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                    boxShadow: [
                                      new BoxShadow(
                                        color:
                                            Color.fromARGB(255, 211, 210, 210),
                                        blurRadius: 20.0,
                                      ),
                                    ],
                                  ),
                                  height: 360,
                                  width: Textsize.screenWidth,
                                  child: SfCircularChart(
                                    legend: Legend(
                                      isVisible: true,
                                     
                                      position: LegendPosition.bottom,
                                      overflowMode: LegendItemOverflowMode.wrap,
                                    ),
                                    series: <CircularSeries>[
                                      DoughnutSeries<ChartData, String>(
                                        dataSource:
                                            staticsDatacontroller.chartData,
                                        dataLabelSettings: DataLabelSettings(
                                          isVisible: true,
                                          labelPosition:
                                              ChartDataLabelPosition.inside,
                                        ),
                                        startAngle: 90,
                                        endAngle: 450,
                                        explode: true,
                                        explodeIndex: _selectedIndex,
                                        explodeAll: false,
                                        radius: '95%',
                                        enableTooltip: true,
                                        onPointTap: (ChartPointDetails args) {
                                          setState(() {
                                            _selectedIndex = args.pointIndex!;
                                          });
                                        },
                                        pointColorMapper: (ChartData data, _) =>
                                            data.color,
                                        xValueMapper: (ChartData data, _) =>
                                            data.x,
                                        yValueMapper: (ChartData data, _) =>
                                            data.y,
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        )),
                if (clock == true)
                  Obx(() => staticsDatacontroller.isDataLoading.value
                      ? Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: StatisticsEffects(),
                        )
                      : Container(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                      padding:
                                          EdgeInsets.only(top: 40, bottom: 20),
                                      height: Textsize.screenHeight * 0.28,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            new BoxShadow(
                                              color: Color.fromARGB(
                                                  255, 211, 210, 210),
                                              blurRadius: 20.0,
                                            ),
                                          ],
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Container(
                                          width: Textsize.screenWidth + 200,
                                          child: SfCartesianChart(
                                              tooltipBehavior: _tooltipC,
                                              primaryXAxis: CategoryAxis(
                                                  labelRotation: 270),
                                              series: <ChartSeries>[
                                                LineSeries<ChartDatagraph,
                                                        String>(
                                                    dataSource:
                                                        staticsDatacontroller
                                                            .newPatient,
                                                    xValueMapper:
                                                        (ChartDatagraph data,
                                                                _) =>
                                                            data.x,
                                                    yValueMapper:
                                                        (ChartDatagraph data,
                                                                _) =>
                                                            data.y,
                                                    color: Color.fromARGB(
                                                        255, 111, 36, 30),
                                                    markerSettings:
                                                        MarkerSettings(
                                                            isVisible: true,
                                                            shape:
                                                                DataMarkerType
                                                                    .circle))
                                              ]),
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                        child: Text("New Patient",
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black))),
                                  ),
                                ],
                              ),
                              Container(
                                height: Textsize.screenHeight * 0.02,
                              ),
                              Stack(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.only(
                                          top: 40, bottom: 20),
                                      height: Textsize.screenHeight * 0.28,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            new BoxShadow(
                                              color: Color.fromARGB(
                                                  255, 211, 210, 210),
                                              blurRadius: 20.0,
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Container(
                                          width: Textsize.screenWidth + 200,
                                          child: SfCartesianChart(
                                              tooltipBehavior: _tooltipA,
                                              primaryXAxis: CategoryAxis(
                                                  labelRotation: 270),
                                              series: <ChartSeries>[
                                                LineSeries<ChartDatagraph,
                                                        String>(
                                                    dataSource:
                                                        staticsDatacontroller
                                                            .graph,
                                                    xValueMapper:
                                                        (ChartDatagraph data,
                                                                _) =>
                                                            data.x,
                                                    yValueMapper:
                                                        (ChartDatagraph data,
                                                                _) =>
                                                            data.y,
                                                    color: Color(0XFF64a3c4),
                                                    markerSettings:
                                                        MarkerSettings(
                                                      isVisible: true,
                                                    ))
                                              ]),
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                        child: Text("Patient Count",
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black))),
                                  ),
                                ],
                              ),
                              Container(
                                height: Textsize.screenHeight * 0.02,
                              ),
                              Stack(
                                children: [
                                  Container(
                                      padding:
                                          EdgeInsets.only(top: 40, bottom: 20),
                                      height: Textsize.screenHeight * 0.28,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            new BoxShadow(
                                              color: Color.fromARGB(
                                                  255, 211, 210, 210),
                                              blurRadius: 20.0,
                                            ),
                                          ],
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Container(
                                          width: Textsize.screenWidth + 200,
                                          child: SfCartesianChart(
                                              tooltipBehavior: _tooltipB,
                                              primaryXAxis: CategoryAxis(
                                                  labelRotation: 270),
                                              series: <ChartSeries>[
                                                LineSeries<ChartDatagraph,
                                                        String>(
                                                    dataSource:
                                                        staticsDatacontroller
                                                            .graphRevenue,
                                                    xValueMapper:
                                                        (ChartDatagraph data,
                                                                _) =>
                                                            data.x,
                                                    yValueMapper:
                                                        (ChartDatagraph data,
                                                                _) =>
                                                            data.y,
                                                    color: Color.fromARGB(
                                                        255, 111, 36, 30),
                                                    markerSettings:
                                                        MarkerSettings(
                                                            isVisible: true,
                                                            shape:
                                                                DataMarkerType
                                                                    .circle))
                                              ]),
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                        child: Text("Revenues",
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black))),
                                  ),
                                ],
                              ),
                              Container(
                                height: Textsize.screenHeight * 0.02,
                              ),
                            ],
                          ),
                        ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChartDatagraph {
  ChartDatagraph(
    this.x,
    this.y,
  );
  final String x;
  final double y;
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}

class ClipperStack extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0.0, 0.0);
    path.lineTo(0.0, size.height - 10);
    path.lineTo((size.width / 2) - 10, size.height - 10);

    path.lineTo(size.width / 2, size.height);

    path.lineTo((size.width / 2) + 10, size.height - 10);
    path.lineTo(size.width, size.height - 10);

    path.lineTo(size.width, 0.0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
