import 'package:doctors_incentive/model/textsize.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphInformation extends StatefulWidget {
  const GraphInformation({super.key});

  @override
  State<GraphInformation> createState() => _GraphInformationState();
}

class _GraphInformationState extends State<GraphInformation> {
  List details = [
    {"information": "Rank", "data": "2"},
    {"information": "Mpnthly Averege", "data": "1350"},
    {"information": "% From Department", "data": "52%"},
    {"information": "Change Over Last Year ", "data": "+12%"},
  ];
  List tableDetails = [
    {"month": "Last Month", "count": "1250", "rank": "2"},
    {"month": "Last Month-1", "count": "1250", "rank": "2"},
    {"month": "Last Month", "count": "1250", "rank": "2"},
    {"month": "Last Month ", "count": "1255", "rank": "2"},
    {"month": "Last Month ", "count": "1250", "rank": "6"},
    {"month": "Last Month ", "count": "1250", "rank": "2"},
    {"month": "Last Month ", "count": "1250", "rank": "2"},
    {"month": "Last Month ", "count": "1250", "rank": "2"},
    {"month": "Last Month ", "count": "1250", "rank": "2"},
  ];
  static List<ChartData> chartData = <ChartData>[
    ChartData('Rent', 1000, Colors.teal),
    ChartData('Food', 2500, Colors.lightBlue),
    ChartData('Savings', 760, Colors.brown),
    ChartData('Tax', 1897, Colors.grey),
    ChartData('Others', 2987, Colors.blueGrey)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color.fromARGB(255, 14, 98, 167),
          centerTitle: true,
          title: Text(
            'Consultation Statistics',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
        body: Container(
          height: Textsize.screenHeight,
          width: Textsize.screenWidth,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 14, 98, 167),
              image: DecorationImage(
                  image: AssetImage("assets/images/background_image.png"),
                  fit: BoxFit.cover)),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(
                      height: Textsize.screenHeight * 0.52,
                      child: SfCircularChart(
                          legend: Legend(
                              isVisible: true, position: LegendPosition.bottom),
                          series: <CircularSeries>[
                            // Render pie chart

                            PieSeries<ChartData, String>(
                                dataSource: chartData,
                                explode: true,
                                dataLabelSettings: DataLabelSettings(

                                    // Renders the data label
                                    isVisible: true),
                                // All the segments will be exploded
                                explodeIndex: 1,
                                pointColorMapper: (ChartData data, _) =>
                                    data.color,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y),
                          ])),
                  Container(
                      child: Table(
                          border:
                              TableBorder.all(color: Colors.white, width: 1.5),
                          columnWidths: const {
                        0: FlexColumnWidth(4),
                        1: FlexColumnWidth(1.5),
                        2: FlexColumnWidth(2),
                      },
                          children: [
                        TableRow(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 14, 98, 167)),
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height: 50,
                                child: Text("Period",
                                    style: TextStyle(
                                        fontSize: Textsize.titleSize,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700)),
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: 50,
                                child: Text(
                                  "Count",
                                  style: TextStyle(
                                      fontSize: Textsize.titleSize,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: 50,
                                child: Text(
                                  "Rank",
                                  style: TextStyle(
                                      fontSize: Textsize.titleSize,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ])
                      ])),
                  Container(
                    height: 3,
                    color: Colors.white,
                  ),
                  Container(
                      child: Table(
                          border:
                              TableBorder.all(color: Colors.white, width: 1.5),
                          columnWidths: const {
                            0: FlexColumnWidth(4),
                            1: FlexColumnWidth(1.5),
                            2: FlexColumnWidth(2),
                          },
                          children: List<TableRow>.generate(tableDetails.length,
                              (index) {
                            return TableRow(
                                decoration: BoxDecoration(
                                    color: index % 2 == 0
                                        ? Color.fromARGB(255, 174, 214, 247)
                                        : Color.fromARGB(255, 100, 157, 205)),
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    alignment: Alignment.centerLeft,
                                    height: 40,
                                    child: Text(
                                      tableDetails[index]['month'],
                                      style: TextStyle(
                                          fontSize: Textsize.subTitle,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    child: Text(
                                      tableDetails[index]['count'],
                                      style: TextStyle(
                                          fontSize: Textsize.subTitle,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    child: Text(
                                      tableDetails[index]['rank'],
                                      style: TextStyle(
                                          fontSize: Textsize.subTitle,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ]);
                          })))
                ],
              ),
            ),
          ),
        ));
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
