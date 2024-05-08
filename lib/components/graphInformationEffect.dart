import 'package:doctors_incentive/model/textsize.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class GraphInfoEffects extends StatefulWidget {
  const GraphInfoEffects({super.key});

  @override
  State<GraphInfoEffects> createState() => _GraphInfoEffectsState();
}

class _GraphInfoEffectsState extends State<GraphInfoEffects> {
  List tableDetails = [
    {
      "month": "Patients",
      "number": "1250",
      "lastMonth": "2",
      "sameMonthLY": "10"
    },
    {
      "month": "Discharge",
      "number": "1250",
      "lastMonth": "2",
      "sameMonthLY": "10"
    },
    {
      "month": "Follow-up",
      "number": "1250",
      "lastMonth": "2",
      "sameMonthLY": "10"
    },
    {
      "month": "Consultations ",
      "number": "1250",
      "lastMonth": "2",
      "sameMonthLY": "10"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      colorOpacity: 0.6,
      child: Column(
        children: [
          Container(
              child: Table(
                  border: TableBorder(
                      bottom: BorderSide(color: Colors.white, width: 1.5),
                      top: BorderSide.none,
                      left: BorderSide.none,
                      right: BorderSide.none,
                      verticalInside:
                          BorderSide(color: Colors.white, width: 1.5)),
                  columnWidths: const {
                0: FlexColumnWidth(3.3),
                1: FlexColumnWidth(1.6),
                2: FlexColumnWidth(1.6),
                3: FlexColumnWidth(1.8),
              },
                  children: [
                TableRow(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 167, 203, 222)
                            .withOpacity(0.2)),
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 50,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 50,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 50,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 50,
                      ),
                    ])
              ])),
          Container(
              child: Table(
                  border: TableBorder(
                      bottom: BorderSide(color: Colors.white, width: 1.5),
                      top: BorderSide(color: Colors.white, width: 1.5),
                      left: BorderSide.none,
                      right: BorderSide.none,
                      verticalInside:
                          BorderSide(color: Colors.white, width: 1.5),
                      horizontalInside:
                          BorderSide(color: Colors.white, width: 1.5)),
                  columnWidths: const {
                    0: FlexColumnWidth(3.3),
                    1: FlexColumnWidth(1.6),
                    2: FlexColumnWidth(1.6),
                    3: FlexColumnWidth(1.8),
                  },
                  children:
                      List<TableRow>.generate(tableDetails.length, (index) {
                    return TableRow(
                        decoration: BoxDecoration(
                            color: index % 2 == 0
                                ? Color.fromARGB(255, 167, 203, 222)
                                    .withOpacity(0.2)
                                : Color.fromARGB(255, 167, 203, 222)
                                    .withOpacity(0.2)),
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            alignment: Alignment.centerLeft,
                            height: 40,
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 40,
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 40,
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 40,
                          ),
                        ]);
                  }))),
          Container(
            height: Textsize.screenHeight * 0.02,
          ),
          Container(
            color: Color.fromARGB(255, 167, 203, 222).withOpacity(0.2),
            height: 400,
            width: Textsize.screenWidth,
          )
        ],
      ),
    );
  }
}
