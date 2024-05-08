import 'dart:io';

import 'package:doctors_incentive/apiController/userDetailController.dart';
import 'package:doctors_incentive/model/textsize.dart';
import 'package:doctors_incentive/screens/documentScreen.dart';

import 'package:flutter/material.dart';

import 'package:flutter_file_downloader/flutter_file_downloader.dart';

import 'package:get/get.dart';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class DocumentViewScreen extends StatefulWidget {
  const DocumentViewScreen({super.key});

  @override
  State<DocumentViewScreen> createState() => _DocumentViewScreenState();
}

class _DocumentViewScreenState extends State<DocumentViewScreen> {
  var userdetailcontroller = Get.put(UserDetailsController());
  late ProgressDialog progressDialog;

  String downloadMessage = '';
  File? downloadedFile;
  @override
  void initState() {
    userdetailcontroller.dataSendToServer();

    super.initState();
    progressDialog = ProgressDialog(context);
    progressDialog.style(
        message: 'Downloading...',
        progressWidget: Transform.scale(
          scale: 0.5,
          child: CircularProgressIndicator(),
        ));
  }

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

          try {
            await Share.shareFiles([downloadedFile!.path]);
          } catch (e) {}
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
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          elevation: 0,
          backgroundColor: Color(0XFFFDAC2F),
          centerTitle: true,
          title: const Text(
            'Documents',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
        body: Obx(() => userdetailcontroller.isDataLoading.value
            ? Center(
                child: CircularProgressIndicator(
                color: Color(0XFFFDAC2F),
              ))
            : Container(
                height: Textsize.screenHeight,
                child: ScrollConfiguration(
                  behavior: ScrollBehavior(),
                  child: GlowingOverscrollIndicator(
                    axisDirection: AxisDirection.down,
                    color: Color(0XFF64a3c4),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: Textsize.screenHeight,
                            width: Textsize.screenWidth,
                            child: userdetailcontroller.documentData.isEmpty
                                ? Center(child: Text("Document not available"))
                                : ListView.builder(
                                    itemCount: userdetailcontroller
                                        .documentData.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final fileNameData = userdetailcontroller
                                          .documentData[index]['name'];
                                      final fileUrlData = userdetailcontroller
                                          .documentData[index]['download_url'];
                                      final path = userdetailcontroller
                                          .documentData[index]['name'];

                                      final extension = p.extension(path);
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: InkWell(
                                          onTap: () {
                                            print(fileUrlData);
                                            if (extension == '.pdf' ||
                                                extension == '.jpeg' ||
                                                extension == '.png' ||
                                                extension == '.jpg') {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DocumentScreen(
                                                            fileName:
                                                                fileNameData,
                                                            fileUrl:
                                                                fileUrlData,
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
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: ListTile(
                                              tileColor: Colors.white,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              leading: Container(
                                                  height: Textsize
                                                          .screenHeight *
                                                      0.05,
                                                  width: Textsize
                                                          .screenWidth *
                                                      0.1,
                                                  decoration: BoxDecoration(
                                                      color: Color(0XFFFDAC2F),
                                                      borderRadius: BorderRadius
                                                          .circular(5)),
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
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          : extension == '.jpeg'
                                                              ? Icon(
                                                                  Icons.image,
                                                                  size: 28,
                                                                  color: Colors
                                                                      .white)
                                                              : extension ==
                                                                      '.png'
                                                                  ? Icon(
                                                                      Icons
                                                                          .image,
                                                                      size: 28,
                                                                      color: Colors
                                                                          .white)
                                                                  : extension ==
                                                                          '.jpg'
                                                                      ? Icon(
                                                                          Icons
                                                                              .image,
                                                                          size:
                                                                              28,
                                                                          color:
                                                                              Colors.white)
                                                                      : Icon(
                                                                          Icons
                                                                              .description,
                                                                          size:
                                                                              28,
                                                                          color:
                                                                              Colors.white,
                                                                        )),
                                              title: Container(
                                                child: Text(
                                                  userdetailcontroller
                                                          .documentData[index]
                                                      ['name'],
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              subtitle: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: Container(
                                                    child: Text("date and time",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400))),
                                              ),
                                              trailing: InkWell(
                                                onTap: () {
                                                  String urlFile =
                                                      userdetailcontroller
                                                          .documentData[index]
                                                              ['file_url']
                                                          .toString();
                                                  String filename =
                                                      userdetailcontroller
                                                          .documentData[index]
                                                              ['name']
                                                          .toString();
                                                  if (Platform.isAndroid) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          content: Row(
                                                            children: <Widget>[
                                                              CircularProgressIndicator(),
                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                              Text(
                                                                  "Downloading..."),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                    FileDownloader.downloadFile(
                                                        name: filename,
                                                        url: urlFile,
                                                        onDownloadCompleted:
                                                            (path) {
                                                          final File file =
                                                              File(path);
                                                          print(file);
                                                          ToastContext()
                                                              .init(context);
                                                          Toast.show(
                                                            "Document downloaded ",
                                                            duration: Toast
                                                                .lengthLong,
                                                            gravity: 0,
                                                          );
                                                          setState(() {});
                                                          Navigator.pop(
                                                              context);
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
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                          )
                        ],
                      ),
                    ),
                  ),
                ))));
  }
}
