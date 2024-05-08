import 'dart:io';

import 'package:doctors_incentive/apiController/incentiveController.dart';
import 'package:doctors_incentive/components/informationEffects.dart';
import 'package:doctors_incentive/model/currency.dart';
import 'package:doctors_incentive/model/textsize.dart';
import 'package:doctors_incentive/screens/documentScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:toast/toast.dart';
import 'package:path/path.dart' as p;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

//import 'package:progress_dialog/progress_dialog.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen>
    with SingleTickerProviderStateMixin {
  late ProgressDialog progressDialog;

  String downloadMessage = '';
  File? downloadedFile;

  var incentiveController = Get.put(IncentiveController());
  ScrollController _scrollController = ScrollController();
  late AnimationController _controller;
  late Animation<Offset> _animation;
  bool _isTableVisible = false;
  final Corrcontroller = CorrencyController();
  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset(-1, 0),
      end: Offset.zero,
    ).animate(_controller);

    super.initState();
    progressDialog = ProgressDialog(context);
    progressDialog.style(
        message: 'Downloading...',
        progressWidget: Transform.scale(
          scale: 0.5,
          child: CircularProgressIndicator(),
        ));
  }

  double roundToNearestInteger(double number) {
    double decimalPart =
        number - number.floor(); // Get the decimal part of the number
    if (decimalPart >= 0.5) {
      return number.floorToDouble() + 1;
      // Round up
    } else {
      return number.floorToDouble(); // Round down
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleTableVisibility() {
    setState(() {
      _isTableVisible = !_isTableVisible;
      if (_isTableVisible) {
        _controller.forward();
      } else {
        //_controller.reverse();
      }
    });
  }

  void scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  bool calculativeIncent = false;
  bool invoice = false;
  var itemindex = "";
  Future<void> downloadFile({
    required String url,
    required String filename,
  }) async {
    try {
      final httpClient = HttpClient();
      final request = await httpClient.getUrl(Uri.parse(url));
      final response = await request.close();

      final length = response.contentLength;
      int receivedBytes = 0;
      final bytes = <int>[];

      response.listen(
        (List<int> chunk) {
          bytes.addAll(chunk);
          receivedBytes += chunk.length;
          final progress = receivedBytes / length;
          progressDialog.update(
            message: 'Downloading... ${(progress * 100).toStringAsFixed(2)}%',
            progress: progress,
          );
        },
        onDone: () async {
          progressDialog.hide();
          final appDocumentsDir = await getApplicationDocumentsDirectory();
          final filePathName = "${appDocumentsDir.path}/$filename";
          final savedFile = File(filePathName);

          await savedFile.writeAsBytes(bytes);

          setState(() {
            downloadedFile = savedFile;
            downloadMessage = "Downloaded Successfully!";
          });

          // // Open the downloaded file
          // final result = await OpenFile.open(downloadedFile!.path);

          // if (result.type == ResultType.done) {
          //   print("File opened successfully");
          // } else {
          //   print("Error opening file: ${result.message}");
          // }

          try {
            await Share.shareFiles([downloadedFile!.path]);
          } catch (e) {
            print("Error sharing file: $e");
            // Handle the error gracefully, e.g., show a message to the user
          }
        },
        onError: (error) {
          progressDialog.hide();
          setState(() {
            downloadMessage = "Download Error: $error";
          });
        },
      );
    } catch (error) {
      progressDialog.hide();
      setState(() {
        downloadMessage = "Some error occurred -> $error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Column buildDynamicTable(Map<String, dynamic> data) {
      List<TableRow> rows = [];
      bool isWhite = true; // Flag to track alternating row colors

      data.forEach((key, value) {
        Color rowColor =
            isWhite ? Colors.white : Colors.blueGrey.withOpacity(0.1);

        rows.add(
          TableRow(
            decoration: BoxDecoration(
              color: rowColor,
            ),
            children: [
              Container(
                padding: EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                height: 50,
                child: Text(
                  key,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Textsize.subTitle,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                height: 50,
                child: Text(
                  Corrcontroller.formatCurrency(value.toString()),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Textsize.subTitle,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );

        // Toggle the flag for the next row
        isWhite = !isWhite;
      });

      return Column(
        children: [
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2.3),
              1: FlexColumnWidth(2),
            },
            children: [
              ...rows, // Add dynamically generated rows
            ],
          ),
        ],
      );
    }

// Function to build the entire table dynamically

    void bottomModal(BuildContext context) {
      showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, setState) {
              return SizedBox(
                height: Textsize.screenHeight / 2,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("Documents",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                  ),
                  Expanded(
                      child: incentiveController.documentData.isEmpty
                          ? Center(
                              child: Text("Data not found",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)))
                          : ListView.builder(
                              itemCount:
                                  incentiveController.documentData.length,
                              itemBuilder: (context, index) {
                                String createdDatetime = incentiveController
                                    .documentData[index]['created_at'];
                                DateTime timestamp =
                                    DateTime.parse(createdDatetime);

                                String formattedDateTime =
                                    DateFormat('yyyy-MM-dd \'at\' HH:mm')
                                        .format(timestamp);

                                final fileNameData = incentiveController
                                    .documentData[index]['name'];
                                final fileUrlData = incentiveController
                                    .documentData[index]['file_url'];
                                final path = incentiveController
                                    .documentData[index]['name'];

                                final extension = p.extension(path);
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: InkWell(
                                    onTap: () {
                                      if (extension == '.pdf' ||
                                          extension == '.jpeg' ||
                                          extension == '.png' ||
                                          extension == '.jpg') {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DocumentScreen(
                                                      fileName: fileNameData,
                                                      fileUrl: fileUrlData,
                                                    )));
                                      } else {
                                        ToastContext().init(context);
                                        Toast.show(
                                          "Please download document",
                                          duration: Toast.lengthShort,
                                          gravity: 0,
                                        );
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: ListTile(
                                        tileColor: Colors.white,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        leading: Container(
                                            height:
                                                Textsize.screenHeight * 0.05,
                                            width: Textsize.screenWidth * 0.1,
                                            decoration: BoxDecoration(
                                                color: Color(0XFFFDAC2F),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: extension == '.pdf'
                                                ? Icon(
                                                    Icons.picture_as_pdf,
                                                    size: 28,
                                                    color: Colors.white,
                                                  )
                                                : extension == '.doc'
                                                    ? Icon(
                                                        Icons.description,
                                                        size: 28,
                                                        color: Colors.white,
                                                      )
                                                    : extension == '.jpeg'
                                                        ? Icon(Icons.image,
                                                            size: 28,
                                                            color: Colors.white)
                                                        : extension == '.png'
                                                            ? Icon(Icons.image,
                                                                size: 28,
                                                                color: Colors
                                                                    .white)
                                                            : extension ==
                                                                    '.jpg'
                                                                ? Icon(
                                                                    Icons.image,
                                                                    size: 28,
                                                                    color: Colors
                                                                        .white)
                                                                : Icon(
                                                                    Icons
                                                                        .description,
                                                                    size: 28,
                                                                    color: Colors
                                                                        .white,
                                                                  )),
                                        title: Container(
                                          child: Text(
                                            incentiveController
                                                .documentData[index]['name'],
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        subtitle: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Container(
                                              child: Text(formattedDateTime,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w400))),
                                        ),
                                        trailing: InkWell(
                                          onTap: () async {
                                            String urlFile = incentiveController
                                                .documentData[index]['file_url']
                                                .toString();
                                            String filename =
                                                incentiveController
                                                    .documentData[index]['name']
                                                    .toString();
                                            if (Platform.isAndroid) {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    content: Row(
                                                      children: <Widget>[
                                                        CircularProgressIndicator(),
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        Text("Downloading..."),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                              print(
                                                  'ANDROID DOWNLOAD FILE-->$urlFile , $filename');
                                              FileDownloader.downloadFile(
                                                  name: filename,
                                                  url: urlFile,
                                                  onDownloadCompleted: (path) {
                                                    final File file =
                                                        File(path);
                                                    print(file);
                                                    ToastContext()
                                                        .init(context);
                                                    Toast.show(
                                                      "Document downloaded ",
                                                      duration:
                                                          Toast.lengthLong,
                                                      gravity: 0,
                                                    );
                                                    setState(() {});
                                                    Navigator.pop(
                                                        context); // Close the dialog
                                                  });
                                            } else {
                                              progressDialog.show();
                                              downloadFile(
                                                url: urlFile,
                                                filename: filename,
                                              );
                                            }
                                          },
                                          child: Icon(
                                            Icons.download,
                                            size: 26,
                                            color:
                                                Colors.black.withOpacity(0.6),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }))
                ]),
              );
            });
          });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: Color(0XFFFDAC2F),
        title: const Text(
          'Incentive Details',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        actions: [
          InkWell(
            onTap: () {
              bottomModal(context);
            },
            child: Center(
              widthFactor: 1.1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.fileArrowDown,
                    // size: 28,
                    color: Colors.white,
                  ),
                  Text('Dr invoice & other debit',
                      style: TextStyle(fontSize: 11, color: Colors.white))
                ],
              ),
            ),
            //  Icon(
            //   Icons.insert_drive_file_outlined,
            // size: 28,
            // color: Colors.white,
            // ),
          ),
        ],
      ),
      body: Container(
          padding: const EdgeInsets.all(20),
          height: Textsize.screenHeight,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Obx(
            () => incentiveController.isDataLoading.value
                ? InformationEffects()
                : ScrollConfiguration(
                    behavior: ScrollBehavior(),
                    child: GlowingOverscrollIndicator(
                      axisDirection: AxisDirection.down,
                      color: Color(0XFF64a3c4),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                width: Textsize.screenWidth,
                                // color: Colors.amber,
                                alignment: Alignment.center,
                                child: Text(
                                  incentiveController.infoYearName,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Color(0XFF64a3c4),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Net incentive",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: Textsize.titleSize,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700)),
                                          Text(
                                            Corrcontroller.formatCurrency(
                                              incentiveController.netIncentive
                                                  .toString(),
                                            ),

                                            // int.parse(incentiveController
                                            //         .netIncentive)
                                            //     .toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: Textsize.titleSize,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // incentiveController
                                    //         .netIncentiveList.isNotEmpty
                                    //     ?
                                    Container(
                                      height: 100,
                                      child: AnimationLimiter(
                                        child: ListView.builder(
                                            itemCount: incentiveController
                                                .netIncentiveList.length,
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
                                                    child: Container(
                                                        child: Material(
                                                      animationDuration:
                                                          Duration(
                                                              milliseconds:
                                                                  1000),
                                                      color: index % 2 != 0
                                                          ? Colors.white
                                                          : Colors.blueGrey
                                                              .withOpacity(0.1),
                                                      child: InkWell(
                                                        splashColor: Theme.of(
                                                                context)
                                                            .primaryColorLight,
                                                        onTap: () {
                                                          setState(() {
                                                            itemindex = index
                                                                .toString();

                                                            print(itemindex);
                                                            if (index == 0) {
                                                              _toggleTableVisibility();
                                                              calculativeIncent =
                                                                  true;
                                                            } else {
                                                              scrollToTop();
                                                              _toggleTableVisibility();

                                                              invoice = true;
                                                            }
                                                          });
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          20),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height: 50,
                                                              child: Text(
                                                                incentiveController
                                                                    .netIncentiveList[
                                                                        index][
                                                                        'incentive']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        Textsize
                                                                            .subTitle,
                                                                    color: index %
                                                                                2 !=
                                                                            0
                                                                        ? Colors
                                                                            .red
                                                                        : Colors
                                                                            .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          20),
                                                              alignment:
                                                                  AlignmentDirectional
                                                                      .center,
                                                              height: 50,
                                                              child: Text(
                                                                Corrcontroller
                                                                    .formatCurrency(
                                                                  incentiveController
                                                                      .netIncentiveList[
                                                                          index]
                                                                          [
                                                                          'detail']
                                                                      .toString(),
                                                                ),
                                                                // int.parse(incentiveController
                                                                //             .netIncentiveList[index]
                                                                //         [
                                                                //         'detail'])
                                                                //     .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        Textsize
                                                                            .subTitle,
                                                                    color: index %
                                                                                2 !=
                                                                            0
                                                                        ? Colors
                                                                            .red
                                                                        : Colors
                                                                            .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                    )
                                    // : Text("data not found")
                                  ],
                                ),
                              ),
                              Container(
                                height: Textsize.screenHeight * 0.02,
                              ),
                              if (calculativeIncent == true)
                                SlideTransition(
                                  position: _animation,
                                  child: Card(
                                    borderOnForeground: false,
                                    color: Colors.white,
                                    elevation: 0.5,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.white70, width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: incentiveController
                                            .netincentiveDetails.isEmpty
                                        ? Text('Data Not Found')
                                        : Column(
                                            children: [
                                              Table(columnWidths: const {
                                                0: FlexColumnWidth(3.1),
                                                1: FlexColumnWidth(2),
                                                2: FlexColumnWidth(1.1),
                                                3: FlexColumnWidth(1.6),
                                              }, children: [
                                                TableRow(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0XFF64a3c4),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        15),
                                                                topRight: Radius
                                                                    .circular(
                                                                        15))),
                                                    children: [
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        height: 50,
                                                        child: Text(
                                                            "Calculated Incentive",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: Textsize
                                                                    .titleSize,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700)),
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        height: 50,
                                                        child: Text(
                                                          "Entitlement Revenues",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: Textsize
                                                                  .titleSize,
                                                              color:
                                                                  Colors.white,
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
                                                          "%",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: Textsize
                                                                  .titleSize,
                                                              color:
                                                                  Colors.white,
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
                                                          "Incentive",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: Textsize
                                                                  .titleSize,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      ),
                                                    ])
                                              ]),
                                              Table(
                                                  columnWidths: const {
                                                    0: FlexColumnWidth(3.1),
                                                    1: FlexColumnWidth(2),
                                                    2: FlexColumnWidth(1.1),
                                                    3: FlexColumnWidth(1.6),
                                                  },
                                                  children: List<
                                                          TableRow>.generate(
                                                      incentiveController
                                                          .netincentiveDetails
                                                          .length, (index) {
                                                    double a = double.parse(
                                                        incentiveController
                                                                    .netincentiveDetails[
                                                                index][
                                                            'net_revenue']); // Your input number
                                                    double roundedValueA =
                                                        roundToNearestInteger(
                                                            a);
                                                    String enrevenue =
                                                        roundedValueA
                                                            .toString();
                                                    if (roundedValueA ==
                                                        roundedValueA.toInt()) {
                                                      enrevenue = roundedValueA
                                                          .toInt()
                                                          .toString(); // Convert to int if no decimal part
                                                    }

                                                    print(
                                                        enrevenue); // Output: 11.0
                                                    double b = double.parse(
                                                        incentiveController
                                                                    .netincentiveDetails[
                                                                index][
                                                            'incentive_amt']); // Your input number
                                                    double roundedValueB =
                                                        roundToNearestInteger(
                                                            b);
                                                    String incent =
                                                        roundedValueB
                                                            .toString();
                                                    if (roundedValueB ==
                                                        roundedValueB.toInt()) {
                                                      incent = roundedValueB
                                                          .toInt()
                                                          .toString(); // Convert to int if no decimal part
                                                    }
                                                    // Output: 11.0

                                                    return TableRow(
                                                        decoration: BoxDecoration(
                                                            color: index % 2 !=
                                                                    0
                                                                ? Colors.white
                                                                : Colors
                                                                    .blueGrey
                                                                    .withOpacity(
                                                                        0.1)),
                                                        children: [
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10),
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            height: 50,
                                                            child: Text(
                                                              incentiveController
                                                                  .netincentiveDetails[
                                                                      index][
                                                                      'service_name']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: Textsize
                                                                      .subTitle,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                          Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 50,
                                                            child: Text(
                                                              Corrcontroller
                                                                  .formatCurrency(
                                                                      enrevenue
                                                                          .toString()),
                                                              style: TextStyle(
                                                                  fontSize: Textsize
                                                                      .subTitle,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height: 50,
                                                              child: Text(
                                                                incentiveController
                                                                    .netincentiveDetails[
                                                                        index][
                                                                        'price_or_incentive_percentage']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        Textsize
                                                                            .subTitle,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 50,
                                                            child: Text(
                                                              Corrcontroller
                                                                  .formatCurrency(
                                                                incent
                                                                    .toString(),
                                                              ),
                                                              style: TextStyle(
                                                                  fontSize: Textsize
                                                                      .subTitle,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                        ]);
                                                  })),
                                            ],
                                          ),
                                  ),
                                ),
                              Container(
                                height: Textsize.screenHeight * 0.02,
                              ),
                              if (invoice == true)
                                SlideTransition(
                                  position: _animation,
                                  child: Card(
                                    borderOnForeground: false,
                                    color: Colors.white,
                                    elevation: 0.5,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.white70, width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: incentiveController
                                            .incentives.isEmpty
                                        ? Text('No Data Found')
                                        : Column(
                                            children: [
                                              Table(columnWidths: const {
                                                0: FlexColumnWidth(3.1),
                                                1: FlexColumnWidth(2),
                                              }, children: [
                                                TableRow(
                                                    decoration: BoxDecoration(
                                                      color: Color(0XFF64a3c4),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(15),
                                                              topRight: Radius
                                                                  .circular(
                                                                      15)),
                                                    ),
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        height: 50,
                                                        child: Text(
                                                            "Invoice & other Debits",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: Textsize
                                                                    .titleSize,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700)),
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        height: 50,
                                                        child: Text(
                                                          "Amount",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: Textsize
                                                                  .titleSize,
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      ),
                                                    ])
                                              ]),
                                              buildDynamicTable(
                                                  incentiveController
                                                      .incentives),

                                              // Table(columnWidths: const {
                                              //   0: FlexColumnWidth(3.1),
                                              //   1: FlexColumnWidth(2),
                                              // }, children: [
                                              //   TableRow(
                                              // decoration: BoxDecoration(
                                              //   color: Colors.blueGrey
                                              //       .withOpacity(0.1),
                                              // ),
                                              //       children: [
                                              //         Container(
                                              //           padding:
                                              //               EdgeInsets.only(
                                              //                   left: 10),
                                              //           alignment: Alignment
                                              //               .centerLeft,
                                              //           height: 50,
                                              //           child: Text(
                                              //               "Incentives Amendment",
                                              //               textAlign: TextAlign
                                              //                   .center,
                                              //               style: TextStyle(
                                              //                   fontSize: Textsize
                                              //                       .subTitle,
                                              //                   color: Colors
                                              //                       .black,
                                              //                   fontWeight:
                                              //                       FontWeight
                                              //                           .w500)),
                                              //         ),
                                              //         Container(
                                              //           alignment:
                                              //               Alignment.center,
                                              //           height: 50,
                                              //           child: Text(
                                              //             Corrcontroller
                                              //                 .formatCurrency(
                                              //               incentiveController
                                              //                   .incentives[
                                              //                       'Incentives Amendment ']
                                              //                   .toString(),
                                              //             ),
                                              //             textAlign:
                                              //                 TextAlign.center,
                                              //             style: TextStyle(
                                              //                 fontSize: Textsize
                                              //                     .subTitle,
                                              //                 color: Colors.red,
                                              //                 fontWeight:
                                              //                     FontWeight
                                              //                         .w500),
                                              //           ),
                                              //         ),
                                              //       ])
                                              // ]),
                                              // Table(columnWidths: const {
                                              //   0: FlexColumnWidth(3.1),
                                              //   1: FlexColumnWidth(2),
                                              // }, children: [
                                              //   TableRow(
                                              //       decoration: BoxDecoration(
                                              //           color: Colors.white),
                                              //       children: [
                                              //         Container(
                                              //           padding:
                                              //               EdgeInsets.only(
                                              //                   left: 10),
                                              //           alignment: Alignment
                                              //               .centerLeft,
                                              //           height: 50,
                                              //           child: Text(
                                              //               "Dr Debit Invoice",
                                              //               textAlign: TextAlign
                                              //                   .center,
                                              //               style: TextStyle(
                                              //                   fontSize: Textsize
                                              //                       .subTitle,
                                              //                   color: Colors
                                              //                       .black,
                                              //                   fontWeight:
                                              //                       FontWeight
                                              //                           .w500)),
                                              //         ),
                                              //         Container(
                                              //           alignment:
                                              //               Alignment.center,
                                              //           height: 50,
                                              //           child: Text(
                                              //             Corrcontroller
                                              //                 .formatCurrency(
                                              //               incentiveController
                                              //                   .incentives[
                                              //                       'Doctors invoices and other debits amounts']
                                              //                   .toString(),
                                              //             ),
                                              //             textAlign:
                                              //                 TextAlign.center,
                                              //             style: TextStyle(
                                              //                 fontSize: Textsize
                                              //                     .subTitle,
                                              //                 color: Colors.red,
                                              //                 fontWeight:
                                              //                     FontWeight
                                              //                         .w500),
                                              //           ),
                                              //         ),
                                              //       ])
                                              // ]),
                                              // Table(columnWidths: const {
                                              //   0: FlexColumnWidth(3.1),
                                              //   1: FlexColumnWidth(2),
                                              // }, children: [
                                              //   TableRow(
                                              //       decoration: BoxDecoration(
                                              //         color: Colors.blueGrey
                                              //             .withOpacity(0.1),
                                              //       ),
                                              //       children: [
                                              //         Container(
                                              //           padding:
                                              //               EdgeInsets.only(
                                              //                   left: 10),
                                              //           alignment: Alignment
                                              //               .centerLeft,
                                              //           height: 50,
                                              //           child: Text(
                                              //               "Prepaid Incentive",
                                              //               textAlign: TextAlign
                                              //                   .center,
                                              //               style: TextStyle(
                                              //                   fontSize: Textsize
                                              //                       .subTitle,
                                              //                   color: Colors
                                              //                       .black,
                                              //                   fontWeight:
                                              //                       FontWeight
                                              //                           .w500)),
                                              //         ),
                                              //         Container(
                                              //           alignment:
                                              //               Alignment.center,
                                              //           height: 50,
                                              //           child: Text(
                                              //             Corrcontroller
                                              //                 .formatCurrency(
                                              //               incentiveController
                                              //                   .incentives[
                                              //                       'Prepaid Incentive']
                                              //                   .toString(),
                                              //             ),
                                              //             textAlign:
                                              //                 TextAlign.center,
                                              //             style: TextStyle(
                                              //                 fontSize: Textsize
                                              //                     .subTitle,
                                              //                 color: Colors.red,
                                              //                 fontWeight:
                                              //                     FontWeight
                                              //                         .w500),
                                              //           ),
                                              //         ),
                                              //       ])
                                              // ]),
                                              // Table(columnWidths: const {
                                              //   0: FlexColumnWidth(3.1),
                                              //   1: FlexColumnWidth(2),
                                              // }, children: [
                                              //   TableRow(
                                              // decoration: BoxDecoration(
                                              //   color: Colors.white,
                                              //       ),
                                              //       children: [
                                              //         Container(
                                              //           padding:
                                              //               EdgeInsets.only(
                                              //                   left: 10),
                                              //           alignment: Alignment
                                              //               .centerLeft,
                                              //           height: 50,
                                              //           child: Text("Enty",
                                              //               textAlign: TextAlign
                                              //                   .center,
                                              //               style: TextStyle(
                                              //                   fontSize: Textsize
                                              //                       .subTitle,
                                              //                   color: Colors
                                              //                       .black,
                                              //                   fontWeight:
                                              //                       FontWeight
                                              //                           .w500)),
                                              //         ),
                                              //         Container(
                                              //           alignment:
                                              //               Alignment.center,
                                              //           height: 50,
                                              //           child: Text(
                                              //             Corrcontroller
                                              //                 .formatCurrency(
                                              //               incentiveController
                                              //                   .incentives[
                                              //                       'Entry']
                                              //                   .toString(),
                                              //             ),
                                              //             textAlign:
                                              //                 TextAlign.center,
                                              //             style: TextStyle(
                                              //                 fontSize: Textsize
                                              //                     .subTitle,
                                              //                 color: Colors.red,
                                              //                 fontWeight:
                                              //                     FontWeight
                                              //                         .w500),
                                              //           ),
                                              //         ),
                                              //       ])
                                              // ]),
                                            ],
                                          ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          )),
      // ),
    );
  }
}
