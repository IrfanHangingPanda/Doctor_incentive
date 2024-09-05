import 'package:doctors_incentive/apiController/loginController.dart';
import 'package:doctors_incentive/apiController/sendOtpController.dart';
import 'package:doctors_incentive/model/textsize.dart';
import 'package:doctors_incentive/screens/forgetpass.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io' as io;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var logincontroller = Get.put(LoginController());
  var sendotpController = Get.put(SendOtp());
  final _controller1 = SuperTooltipController();
  final _controller2 = SuperTooltipController();
  final LocalAuthentication auth = LocalAuthentication();

  bool isRemember = false;
  bool isVisiblePassword = false;
  String? doctorLocalId;
  String? doctorLocalPassword;
  bool _isAuthenticating = false;
  bool isAuthenticated = false;
  Future<void> _authenticateWithBiometrics() async {
    bool isSupported = await auth.isDeviceSupported();
    if (!isSupported) {
      // Handle device not supported
      return;
    }

    bool authenticated = false;

    try {
      setState(() {
        _isAuthenticating = true;
      });

      while (!authenticated) {
        authenticated = await auth.authenticate(
          localizedReason: 'Authenticate using biometrics or device password',
          options: const AuthenticationOptions(
            stickyAuth: false,
            useErrorDialogs: false,
            biometricOnly: false,
          ),
        );

        if (authenticated) {
          setState(() {
            // Mark as authenticated
          });
          break; // Exit loop if authenticated
        }

        // Handle retry logic using existing dialog
        bool retry = await showDialog<bool>(
              context: context,
              barrierDismissible:
                  false, // Prevent dialog from closing when tapping outside
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('App is Locked'),
                  content: const Text(
                      'Authentication is required to access the App.'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text(
                        'Unlock Now',
                        style: TextStyle(color: Color(0XFF65A4C5)),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pop(true); // User chooses to retry
                      },
                    ),
                  ],
                );
              },
            ) ??
            false;

        if (!retry) {
          break; // Exit loop if user chooses not to retry
        }
      }

      setState(() {
        _isAuthenticating = false;
      });

      if (!authenticated) {
        logincontroller.docIdController.clear();
        logincontroller.passwordController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Not Authorized')),
        );
        SystemNavigator.pop();
        io.exit(0); // Close the app if not authorized
      } else {
        loginOnPressed(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Authorized')),
        );
        // Perform post-authentication actions here
      }
    } on PlatformException catch (e) {
      if (e.code == 'NotAvailable' && e.message == 'Authentication canceled.') {
        // Trigger the existing dialog on Face ID cancellation
        bool retry = await showDialog<bool>(
              context: context,
              barrierDismissible:
                  false, // Prevent dialog from closing when tapping outside
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('App is Locked'),
                  content: const Text(
                      'Authentication is required to access the App.'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text(
                        'Unlock Now',
                        style: TextStyle(color: Color(0XFF65A4C5)),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pop(true); // User chooses to retry
                      },
                    ),
                  ],
                );
              },
            ) ??
            false;

        if (retry) {
          _authenticateWithBiometrics(); // Retry authentication
        } else {
          SystemNavigator.pop(); // Close the app if user doesn't retry
          io.exit(0);
        }
      }

      setState(() {
        _isAuthenticating = false;
      });
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchCredential();
  }

  fetchCredential() async {
    print('FETCH CREDENTIAL');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString('doctor_id') != null ||
        prefs.getString('doctor_password') != null) {
      doctorLocalId = prefs.getString('doctor_id');
      doctorLocalPassword = prefs.getString('doctor_password');
      logincontroller.docIdController.text = doctorLocalId ?? '';
      logincontroller.passwordController.text = doctorLocalPassword ?? '';
      isRemember = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isAuthenticating) {
          _authenticateWithBiometrics();
        }
      });
    }
    // if (prefs.getString('doctor_password') != null) {
    //   isRemember = true;
    // }
    print(doctorLocalId);
    print(doctorLocalPassword);
    setState(() {});
  }

  loginOnPressed(fromAuthorization) {
    print(logincontroller.docIdController.text);
    print(logincontroller.passwordController.text);
    if (logincontroller.docIdController.text.isEmpty) {
      Get.snackbar("", '',
          titleText: Text("Error",
              style: TextStyle(
                  fontSize: Textsize.titleSize,
                  color: Colors.white,
                  fontWeight: FontWeight.w600)),
          messageText: Text('Please enter your doctor id',
              style: TextStyle(
                  fontSize: Textsize.subTitle,
                  color: Colors.white,
                  fontWeight: FontWeight.w500)),
          padding: EdgeInsets.only(left: 30),
          icon: Icon(Icons.error_outline, color: Color(0x15000000), size: 60),
          snackPosition: SnackPosition.TOP,
          borderRadius: 0,
          margin: const EdgeInsets.all(0),
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } else if (logincontroller.passwordController.text.isEmpty) {
      Get.snackbar("", '',
          titleText: Text("Error",
              style: TextStyle(
                  fontSize: Textsize.titleSize,
                  color: Colors.white,
                  fontWeight: FontWeight.w600)),
          messageText: Text('Please enter your password',
              style: TextStyle(
                  fontSize: Textsize.subTitle,
                  color: Colors.white,
                  fontWeight: FontWeight.w500)),
          padding: EdgeInsets.only(left: 30),
          icon: Icon(Icons.error_outline, color: Color(0x15000000), size: 60),
          snackPosition: SnackPosition.TOP,
          borderRadius: 0,
          margin: const EdgeInsets.all(0),
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } else {
      print('islogin4');
      logincontroller.sendData(
          fromAuthorization,
          logincontroller.docIdController.text,
          logincontroller.passwordController.text,
          isRemember,
          context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Textsize().init(context);

    rememberMeCheckBox() {
      return CheckboxListTile(
        activeColor: Color(0XFFFDAC2F),
        value: isRemember,
        onChanged: (value) {
          setState(() {
            isRemember = value!;
            print(isRemember);
          });
        },
        controlAffinity: ListTileControlAffinity.leading,
        // contentPadding: EdgeInsets.only(left: 0, top: 0),
        title: Text(
          "Remember Me",
          style: TextStyle(fontSize: 14),
        ),
      );
    }

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
                                    child: SuperTooltip(
                                      showBarrier: true,
                                      controller: _controller1,
                                      popupDirection: TooltipDirection.up,
                                      backgroundColor: Color(0xff2f2d2f),
                                      constraints: const BoxConstraints(
                                        minHeight: 0.0,
                                        maxHeight: 100,
                                        minWidth: 0.0,
                                        maxWidth: 100,
                                      ),
                                      touchThroughAreaShape:
                                          ClipAreaShape.rectangle,
                                      touchThroughAreaCornerRadius: 30,
                                      barrierColor:
                                          Color.fromARGB(26, 47, 45, 47),
                                      content: InkWell(
                                        onTap: () async {
                                          print('0000');
                                          logincontroller.docIdController.text =
                                              doctorLocalId ?? '';
                                          logincontroller.passwordController
                                              .text = doctorLocalPassword ?? '';
                                          await _controller1.hideTooltip();
                                        },
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          child: ListTile(
                                            title: Text(
                                              doctorLocalId ?? '',
                                              softWrap: true,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            subtitle: Text(
                                              "........",
                                              softWrap: true,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                letterSpacing: 2,
                                              ),
                                            ),
                                            leading: Icon(Icons.language,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      child: TextFormField(
                                        onTap: () async {
                                          print('object');
                                          if (logincontroller
                                              .docIdController.text.isEmpty) {
                                            if (doctorLocalId != null) {
                                              await _controller1.showTooltip();
                                            }
                                          }
                                        },
                                        onChanged: (value) async {
                                          if (value.isNotEmpty) {
                                            await _controller1.hideTooltip();
                                          }
                                        },
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
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: SuperTooltip(
                                      showBarrier: true,
                                      controller: _controller2,
                                      popupDirection: TooltipDirection.up,
                                      backgroundColor: Color(0xff2f2d2f),
                                      constraints: const BoxConstraints(
                                        minHeight: 0.0,
                                        maxHeight: 100,
                                        minWidth: 0.0,
                                        maxWidth: 100,
                                      ),
                                      touchThroughAreaShape:
                                          ClipAreaShape.rectangle,
                                      touchThroughAreaCornerRadius: 30,
                                      barrierColor:
                                          Color.fromARGB(26, 47, 45, 47),
                                      content: InkWell(
                                        onTap: () async {
                                          print('111111');
                                          logincontroller.docIdController.text =
                                              doctorLocalId ?? '';
                                          logincontroller.passwordController
                                              .text = doctorLocalPassword ?? '';
                                          await _controller2.hideTooltip();
                                        },
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          child: ListTile(
                                            title: Text(
                                              doctorLocalId ?? '',
                                              softWrap: true,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            subtitle: Text(
                                              "........",
                                              softWrap: true,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                letterSpacing: 2,
                                                color: Colors.white,
                                              ),
                                            ),
                                            leading: Icon(Icons.language,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      child: TextFormField(
                                        onTap: () async {
                                          print('object');
                                          if (logincontroller.passwordController
                                              .text.isEmpty) {
                                            if (doctorLocalPassword != null) {
                                              await _controller2.showTooltip();
                                            }
                                          }
                                        },
                                        onChanged: (value) async {
                                          if (value.isNotEmpty) {
                                            await _controller2.hideTooltip();
                                          }
                                        },
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
                                                  ? Icons
                                                      .visibility_off_outlined
                                                  : Icons.visibility_outlined),
                                            ),
                                          ),
                                          labelText: "Password",
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Container(
                                  //   padding:
                                  //       EdgeInsets.symmetric(horizontal: 10),
                                  //   child: TextFormField(
                                  //     controller:
                                  //         logincontroller.passwordController,
                                  //     obscureText: !isVisiblePassword,
                                  //     decoration: InputDecoration(
                                  //       border: OutlineInputBorder(
                                  //         borderRadius:
                                  //             BorderRadius.circular(30),
                                  //       ),
                                  //       focusedBorder: OutlineInputBorder(
                                  //         borderRadius:
                                  //             BorderRadius.circular(30.0),
                                  //         borderSide: BorderSide(
                                  //             color: Color(0XFF64a3c4)),
                                  //       ),
                                  //       prefixIcon: Icon(
                                  //         Icons.key,
                                  //         //color: Color(0XFF64a3c4),
                                  //       ),
                                  //       suffixIcon: IconButton(
                                  //         onPressed: () {
                                  //           setState(() {
                                  //             isVisiblePassword =
                                  //                 !isVisiblePassword;
                                  //           });
                                  //         },
                                  //         icon: Icon(
                                  //           (!isVisiblePassword
                                  //               ? Icons.visibility_off_outlined
                                  //               : Icons.visibility_outlined),
                                  //         ),
                                  //       ),
                                  //       labelText: "Password",
                                  //     ),
                                  //   ),
                                  // ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        print('change password');
                                        Get.to(ForgetPassScreen());
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
                                  rememberMeCheckBox(),
                                  // Container(
                                  //   height: MediaQuery.of(context).size.height *
                                  //       0.02,
                                  // ),
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
                                            loginOnPressed(false);
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
