import 'package:doctors_incentive/apiController/forgetController.dart';
import 'package:doctors_incentive/apiController/forgetOtpController.dart';
import 'package:doctors_incentive/model/textsize.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPassScreen extends StatefulWidget {
  const ForgetPassScreen({super.key});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  final _formKey = GlobalKey<FormState>();
  final forgetOtpController = Get.put(ForgetOtpController());
  final forgetController = Get.put(ForgetController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          elevation: 0,
          backgroundColor: Color(0XFFFDAC2F),
          centerTitle: true,
          title: const Text(
            'Forget Password',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height - 100,
                padding: EdgeInsets.all(30),
                child: Form(
                    key: _formKey,
                    child: Column(children: [
                      SizedBox(
                        //  height: 52,
                        child: TextFormField(
                          controller: forgetController.docIdController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                  borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(0.7))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(0.7))),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.7)),
                              ),
                              prefixIcon: Icon(
                                Icons.person_2_outlined,
                              ),
                              labelText: "Doctor Id",
                              fillColor: Color(0XFF64a3c4)),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      // Spacer(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.063,
                        width: MediaQuery.of(context).size.width,
                        child: TextButton(
                            onPressed: () {
                              print('ontap');
                              if (forgetController
                                  .docIdController.text.isEmpty) {
                                Get.snackbar("", '',
                                    titleText: Text("Failed",
                                        style: TextStyle(
                                            fontSize: Textsize.titleSize,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600)),
                                    messageText: Text(
                                        'Doctor id field required',
                                        style: TextStyle(
                                            fontSize: Textsize.subTitle,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500)),
                                    padding: EdgeInsets.only(left: 30),
                                    icon: Icon(Icons.error_outline,
                                        color: Color(0x15000000), size: 60),
                                    snackPosition: SnackPosition.TOP,
                                    borderRadius: 0,
                                    margin: const EdgeInsets.all(0),
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white);
                              } else {
                                forgetController.sendData(
                                  context,
                                  forgetController.docIdController.text,
                                );
                              }
                              //Get.offAll(ForgetChangePass());
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Color(0XFFFDAC2F),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11.0),
                                  side: const BorderSide(
                                      color: Color(0XFFFDAC2F))),
                            ),
                            child: Obx(
                              () => forgetController.isDataLoading.value
                                  ? SizedBox(
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                      height: 30,
                                      width: 30,
                                    )
                                  : Text('Submit',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white)),
                            )),
                      ),
                    ])))));
  }
}
