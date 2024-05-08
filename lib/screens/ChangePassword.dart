import 'package:doctors_incentive/apiController/changePasswordController.dart';
import 'package:doctors_incentive/apiController/sendOtpController.dart';
import 'package:doctors_incentive/model/textsize.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Changepassword extends StatefulWidget {
  const Changepassword({super.key});

  @override
  State<Changepassword> createState() => _ChangepasswordState();
}

class _ChangepasswordState extends State<Changepassword> {
  var changePasswordcontroller = Get.put(ChangePasswordController());
  var otpcontroller = Get.put(SendOtp());
  final _formKey = GlobalKey<FormState>();
  bool isVisiblePassword = false;
  @override
  void initState() {
    super.initState();
    isVisiblePassword = false;
  }

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
          'Change Password',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 100,
            padding: EdgeInsets.all(25),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    //  height: 52,
                    child: TextFormField(
                      controller:
                          changePasswordcontroller.oldPasswordController,
                      obscureText: !isVisiblePassword,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.7))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.7))),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.withOpacity(0.7)),
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.grey.withOpacity(0.7),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisiblePassword = !isVisiblePassword;
                              });
                            },
                            icon: Icon(
                              (!isVisiblePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined),
                              color: Colors.grey.withOpacity(0.7),
                            ),
                          ),
                          labelText: "Old Password",
                          labelStyle:
                              TextStyle(color: Colors.grey.withOpacity(0.7)),
                          fillColor: Colors.white70),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  SizedBox(
                    //  height: 52,
                    child: TextFormField(
                      controller:
                          changePasswordcontroller.newPasswordController,
                      obscureText: !isVisiblePassword,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.7))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.7))),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.withOpacity(0.7)),
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.grey.withOpacity(0.7),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisiblePassword = !isVisiblePassword;
                              });
                            },
                            icon: Icon(
                              (!isVisiblePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined),
                              color: Colors.grey.withOpacity(0.7),
                            ),
                          ),
                          labelText: "New - Password",
                          labelStyle:
                              TextStyle(color: Colors.grey.withOpacity(0.7)),
                          fillColor: Colors.white70),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                  ),
                  // Spacer(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.063,
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                        onPressed: () {
                          if (changePasswordcontroller
                              .oldPasswordController.text.isEmpty) {
                            Get.snackbar("", '',
                                titleText: Text("Failed",
                                    style: TextStyle(
                                        fontSize: Textsize.titleSize,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
                                messageText: Text('Old password field required',
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
                          } else if (changePasswordcontroller
                              .newPasswordController.text.isEmpty) {
                            Get.snackbar("", '',
                                titleText: Text("Failed",
                                    style: TextStyle(
                                        fontSize: Textsize.titleSize,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
                                messageText: Text('New password field required',
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
                            changePasswordcontroller.sendData(
                                context,
                                changePasswordcontroller
                                    .oldPasswordController.text,
                                changePasswordcontroller
                                    .newPasswordController.text);
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0XFFFDAC2F),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11.0),
                              side: const BorderSide(color: Color(0XFFFDAC2F))),
                        ),
                        child: Obx(
                          () => changePasswordcontroller.isDataLoading.value ||
                                  otpcontroller.isDataLoading.value
                              ? SizedBox(
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                  height: 30,
                                  width: 30,
                                )
                              : Text('Save Change',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white)),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
