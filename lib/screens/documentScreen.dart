import 'package:doctors_incentive/apiController/userDetailController.dart';
import 'package:doctors_incentive/model/textsize.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DocumentScreen extends StatefulWidget {
  final String fileName;
  final String fileUrl;
  const DocumentScreen(
      {Key? key, required this.fileName, required this.fileUrl})
      : super(key: key);

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  var userdetailscontroller = Get.put(UserDetailsController());
  void initState() {
    super.initState();
    userdetailscontroller.dataSendToServer();
    print(userdetailscontroller.details['attachment_file']);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.fileUrl);
    final extension = p.extension(widget.fileName);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        elevation: 0,
        backgroundColor: Color(0XFFFDAC2F),
        centerTitle: true,
        title: Text(
          '${widget.fileName}',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              height: Textsize.screenHeight,
              width: Textsize.screenWidth,
              child: extension == '.pdf'
                  ? SfPdfViewer.network(widget.fileUrl)
                  : FadeInImage.assetNetwork(
                      placeholder: 'assets/images/placeholder.gif',
                      image: widget.fileUrl,
                      fadeInDuration: const Duration(milliseconds: 1),
                      fadeOutDuration: const Duration(milliseconds: 1),
                      fadeOutCurve: Curves.easeOut,
                      fit: BoxFit.contain,
                    ),

              // Image(
              //     image: NetworkImage(widget.fileUrl),
              //     fit: BoxFit.contain,
              //   ),
            ),
          ),
        ],
      ),
      //   ),
      // ),
    );
  }
}
