import 'package:doctors_incentive/apiController/incentiveController.dart';
import 'package:doctors_incentive/components/incentiveScreen_effect.dart';
import 'package:doctors_incentive/model/currency.dart';
import 'package:doctors_incentive/model/textsize.dart';
import 'package:doctors_incentive/screens/information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

class IncentiveScreen extends StatefulWidget {
  const IncentiveScreen({super.key});

  @override
  State<IncentiveScreen> createState() => _IncentiveScreenState();
}

class _IncentiveScreenState extends State<IncentiveScreen> {
  var incentiveController = Get.put(IncentiveController());
  final Corrcontroller = CorrencyController();
  @override
  void initState() {
    incentiveController.filterData(
        '${DateTime.now().year}-01-01', incentiveController.isYear = '1');
    incentiveController.selectedYear = '${DateTime.now().year}';
    incentiveController.dynamicList.clear();
    super.initState();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Textsize().init(context);
    void bottomModal(BuildContext context) {
      showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          List yearList = List.generate(35, (index) => 2023 + index);
          return StatefulBuilder(builder: (context, setState) {
            return SizedBox(
              height: Textsize.screenHeight / 2,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, left: 20, right: 20, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Select A Year",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700)),
                        if (incentiveController.selectedYear !=
                            '${DateTime.now().year}')
                          InkWell(
                            onTap: () {
                              setState(() {
                                incentiveController.selectedYear =
                                    '${DateTime.now().year}';
                              });
                              incentiveController.dynamicList.clear();

                              incentiveController.filterData(
                                  '${DateTime.now().year}-01-01',
                                  incentiveController.isYear = '1');
                              print('------>>>>' +
                                  incentiveController.selectedYear);
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.red)),
                              child: Text("Clear filter",
                                  style: TextStyle(
                                      fontSize: Textsize.titleSize,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.all(10),
                      shrinkWrap: false,
                      itemCount: yearList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 5,
                        childAspectRatio: 2.5,
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                var yearname = yearList[index].toString();

                                var yearFormat = "$yearname-01-01";
                                print(yearFormat);
                                incentiveController.dynamicList.clear();
                                ///////
                                incentiveController.filterData(yearFormat,
                                    incentiveController.isYear = '1');
                                ///////
                                ///
                                incentiveController.selectedYear =
                                    yearList[index].toString();
                                print(incentiveController.selectedYear);
                                Navigator.pop(context);
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: incentiveController.selectedYear ==
                                            yearList[index].toString()
                                        ? Color(0XFFFDAC2F)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Center(
                                    child: Text(
                                  yearList[index].toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: incentiveController.selectedYear ==
                                            yearList[index].toString()
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ))),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          });
        },
      ).then((value) {
        setState(() {
          incentiveController.selectedYear;
        });
      });
    }

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          // automaticallyImplyLeading: true,
          // iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          backgroundColor: Color(0XFFFDAC2F),
          actions: [
            Stack(
              children: [
                IconButton(
                    onPressed: () {
                      bottomModal(context);
                      setState(() {});
                    },
                    icon: Icon(Icons.filter_alt_sharp)),
                if (incentiveController.selectedYear !=
                    '${DateTime.now().year}')
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  )
              ],
            )
          ],
          title: Text(
            'incentive'.tr,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
        body: Obx(
          () => incentiveController.isDataLoading.value
              ? IncentiveScreenEffect()
              : Container(
                  padding: const EdgeInsets.all(20),
                  child: Card(
                    color: Colors.transparent,
                    elevation: 0.0,
                    child: Column(
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Selected Year ' +
                                  incentiveController.selectedYear,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            )),
                        SizedBox(
                          height: Textsize.screenHeight * 0.02,
                        ),
                        Container(
                          height: Textsize.screenHeight * 0.07,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            decoration: BoxDecoration(
                                color: Color(0XFF64a3c4),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Month",
                                    style: TextStyle(
                                        fontSize: Textsize.titleSize,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700)),
                                Text("Net Incentive",
                                    style: TextStyle(
                                        fontSize: Textsize.titleSize,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: incentiveController.dynamicList.isEmpty
                              ? Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 40),
                                      //alignment: Alignment.center,
                                      height: Textsize.screenHeight * 0.2,
                                      width: Textsize.screenWidth * 0.3,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/incentiveEmpty.png"))),
                                    ),
                                    Text("No data found !")
                                  ],
                                )
                              : ScrollConfiguration(
                                  behavior: ScrollBehavior(),
                                  child: GlowingOverscrollIndicator(
                                    axisDirection: AxisDirection.down,
                                    color: Color(0XFF64a3c4),
                                    child: AnimationLimiter(
                                      child: ListView.builder(
                                          itemCount: incentiveController
                                              .dynamicList.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return AnimationConfiguration
                                                .staggeredList(
                                              position: index,
                                              duration: const Duration(
                                                  milliseconds: 1000),
                                              child: SlideAnimation(
                                                verticalOffset: 44.0,
                                                child: FadeInAnimation(
                                                  child: InkWell(
                                                    onTap: () {
                                                      var monthDetails =
                                                          incentiveController
                                                                  .dynamicList[
                                                              index]['key'];
                                                      print('data');
                                                      print(monthDetails);
                                                      print('data');
                                                      incentiveController
                                                          .monthinformation(
                                                              monthDetails,
                                                              incentiveController
                                                                      .isYear =
                                                                  '0');

                                                      Navigator.push(
                                                          context,
                                                          PageTransition(
                                                              type:
                                                                  PageTransitionType
                                                                      .fade,
                                                              child:
                                                                  InformationScreen()));
                                                    },
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Divider(
                                                          color: Colors.black,
                                                          height: 0,
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      25),
                                                          height: Textsize
                                                                  .screenHeight *
                                                              0.07,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  incentiveController
                                                                              .dynamicList[
                                                                          index]
                                                                      ['lable'],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          Textsize
                                                                              .subTitle,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700)),
                                                              Text(
                                                                  Corrcontroller
                                                                      .formatCurrency(
                                                                    incentiveController
                                                                        .dynamicList[
                                                                            index]
                                                                            [
                                                                            'value']
                                                                        .toString(),
                                                                  ),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          Textsize
                                                                              .subTitle,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700)),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
        ));
  }
}
