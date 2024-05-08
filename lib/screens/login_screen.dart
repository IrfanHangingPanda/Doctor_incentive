import 'package:doctors_incentive/apiController/loginController.dart';
import 'package:doctors_incentive/apiController/sendOtpController.dart';
import 'package:doctors_incentive/model/textsize.dart';
import 'package:doctors_incentive/screens/forgetpass.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var logincontroller = Get.put(LoginController());
  var sendotpController = Get.put(SendOtp());

  bool isVisiblePassword = false;

  @override
  Widget build(BuildContext context) {
    Textsize().init(context);
    return Scaffold(
      // backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height - 250,
                  // color: Color(0XFF65A4C5),
                  child: Stack(children: [
                    // First background image
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/doctor.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Second background image
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/loginImage.png',
                        fit: BoxFit.cover,
                        // color: Colors.black.withOpacity(
                        //     0.5), // Add opacity or any other color effects
                        colorBlendMode: BlendMode.darken,
                      ),
                    ),
                  ])),
              Positioned(
                bottom: 0,
                child: Container(
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                ),
              ),
              Positioned(
                  bottom: 50,
                  left: 30,
                  right: 30,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2 + 110,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 0,
                          left: 10,
                          right: 10,
                          child: Container(
                            height: MediaQuery.of(context).size.height / 2 + 30,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                new BoxShadow(
                                  color: Color.fromARGB(255, 235, 234, 234),
                                  blurRadius: 5.0,
                                  blurStyle: BlurStyle.solid,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              //alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    new BoxShadow(
                                      color: Color.fromARGB(255, 235, 233, 233),
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(100)),
                              padding: EdgeInsets.all(25),
                              child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/splaceImage.png"),
                                      fit: BoxFit.contain,
                                    ),
                                  )),
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 30,
                            left: 10,
                            right: 10,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  Text(
                                    'Login Account',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.03,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: TextFormField(
                                      controller:
                                          logincontroller.docIdController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              borderSide: BorderSide(
                                                  color: Colors.black)),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            borderSide: BorderSide(
                                                color: Color(0XFF64a3c4)),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.person_2_outlined,
                                          ),
                                          labelText: "Doctor Id",
                                          fillColor: Color(0XFF64a3c4)),
                                    ),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: TextFormField(
                                      controller:
                                          logincontroller.passwordController,
                                      obscureText: !isVisiblePassword,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          borderSide: BorderSide(
                                              color: Color(0XFF64a3c4)),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.key,
                                          //color: Color(0XFF64a3c4),
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              isVisiblePassword =
                                                  !isVisiblePassword;
                                            });
                                          },
                                          icon: Icon(
                                            (!isVisiblePassword
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined),
                                          ),
                                        ),
                                        labelText: "Password",
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        print('change password');
                                        Get.offAll(ForgetPassScreen());
                                      },
                                      child: Container(
                                          padding: EdgeInsets.only(right: 20),
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            'Forget Password ?',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700),
                                          ))),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.03,
                                  ),
                                  Column(children: [
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.060,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: TextButton(
                                          onPressed: () {
                                            print(logincontroller
                                                .docIdController.text);
                                            print(logincontroller
                                                .passwordController.text);
                                            if (logincontroller
                                                .docIdController.text.isEmpty) {
                                              Get.snackbar("", '',
                                                  titleText: Text("Error",
                                                      style: TextStyle(
                                                          fontSize: Textsize
                                                              .titleSize,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  messageText: Text(
                                                      'Please enter your doctor id',
                                                      style: TextStyle(
                                                          fontSize:
                                                              Textsize.subTitle,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  padding:
                                                      EdgeInsets.only(left: 30),
                                                  icon: Icon(
                                                      Icons.error_outline,
                                                      color: Color(0x15000000),
                                                      size: 60),
                                                  snackPosition:
                                                      SnackPosition.TOP,
                                                  borderRadius: 0,
                                                  margin:
                                                      const EdgeInsets.all(0),
                                                  backgroundColor: Colors.red,
                                                  colorText: Colors.white);
                                            } else if (logincontroller
                                                .passwordController
                                                .text
                                                .isEmpty) {
                                              Get.snackbar("", '',
                                                  titleText: Text("Error",
                                                      style: TextStyle(
                                                          fontSize: Textsize
                                                              .titleSize,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  messageText: Text(
                                                      'Please enter your password',
                                                      style: TextStyle(
                                                          fontSize:
                                                              Textsize.subTitle,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  padding:
                                                      EdgeInsets.only(left: 30),
                                                  icon: Icon(
                                                      Icons.error_outline,
                                                      color: Color(0x15000000),
                                                      size: 60),
                                                  snackPosition:
                                                      SnackPosition.TOP,
                                                  borderRadius: 0,
                                                  margin:
                                                      const EdgeInsets.all(0),
                                                  backgroundColor: Colors.red,
                                                  colorText: Colors.white);
                                            } else {
                                              print('islogin4');
                                              logincontroller.sendData(
                                                  logincontroller
                                                      .docIdController.text,
                                                  logincontroller
                                                      .passwordController.text,
                                                  context);
                                            }
                                            setState(() {});
                                          },
                                          style: TextButton.styleFrom(
                                            backgroundColor: Color(0XFFFDAC2F),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                          ),
                                          child: Obx(
                                            () => logincontroller
                                                        .isDataLoading.value ||
                                                    sendotpController
                                                        .isDataLoading.value
                                                ? SizedBox(
                                                    child:
                                                        const CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 3,
                                                    ),
                                                    height: 30,
                                                    width: 30,
                                                  )
                                                : Text('Login',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                          ),
                                        ))
                                  ])
                                ],
                              ),
                            ))
                      ],
                    ),
                  ))
            ],
          ),
        ),
      )),
    );
  }
}
