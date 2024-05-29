import 'package:doctors_incentive/apiController/sendOtpController.dart';
import 'package:doctors_incentive/screens/ChangePassword.dart';
import 'package:doctors_incentive/screens/landingScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class SendOtpScreen extends StatefulWidget {
  var otpData;
  SendOtpScreen({super.key, this.otpData});

  @override
  State<SendOtpScreen> createState() => _SendOtpScreenState();
}

class _SendOtpScreenState extends State<SendOtpScreen> {
  var sendOtpcontroller = Get.put(SendOtp());
  OtpFieldController otpController = OtpFieldController();
  String otpValue = '';

  @override
  void initState() {
    super.initState();
    widget.otpData = '****';
    // Use a Future to ensure the widget is built before setting the value
    WidgetsBinding.instance.addPostFrameCallback((_) {
      otpController.set(widget.otpData.split(''));
      print("otp after navigate otp screen: ${widget.otpData}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Change your color here
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(0XFFFDAC2F),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(25),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Text('Verification Code',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.black)),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.012,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                    'Please enter the 4-digit code sent to your phone number',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.withOpacity(0.7),
                        fontWeight: FontWeight.w500)),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.07,
              ),
              Align(
                  child: Stack(
                children: [
                  OTPTextField(
                    controller: otpController,
                    length: 4,
                    width: MediaQuery.of(context).size.width,
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldWidth: 45,
                    fieldStyle: FieldStyle.box,
                    otpFieldStyle: OtpFieldStyle(
                      focusBorderColor: Colors.grey.withOpacity(0.7),
                      borderColor: Colors.grey.withOpacity(0.7),
                    ),
                    outlineBorderRadius: 5,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Colors.black),
                    onChanged: (pin) {
                      // print("Changed: " + pin);
                    },
                    onCompleted: (pin) {
                      otpValue = pin;
                    },
                  ),
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              )),
              Container(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.063,
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      print("otp screen");
                      print(widget.otpData);
                      var sendotp = widget.otpData.toString();
                      print(sendotp);
                      print(otpValue);
                      if (otpValue == '') {
                        Toast.show(
                          "Please enter your otp",
                          duration: Toast.lengthShort,
                          gravity: 0,
                        );
                      } else if (sendotp == '') {
                        ToastContext().init(context);
                        Toast.show(
                          "Phone Number Not Found",
                          duration: Toast.lengthShort,
                          gravity: 0,
                        );
                      } else if (sendotp.trim() == otpValue.trim()) {
                        print("object");
                        if (prefs.getString('defaultPass') == '1') {
                          Get.offAll(LandingScreen());
                        } else {
                          Get.offAll(Changepassword());
                        }
                      } else {
                        ToastContext().init(context);
                        Toast.show(
                          "Please enter currect Otp",
                          duration: Toast.lengthShort,
                          gravity: 0,
                        );
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0XFFFDAC2F),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11.0),
                          side: const BorderSide(color: Color(0XFFFDAC2F))),
                    ),
                    child: const Text('Verify',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w700)),
                    //),
                  )),
              Container(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('If you didn’t receive the code,',
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(0XFFC4C4C4),
                            fontWeight: FontWeight.w500)),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                    ),
                    InkWell(
                      onTap: () {
                        sendOtpcontroller.dataSendToServer(context);
                      },
                      child: const Text('Resend',
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0XFFD31901),
                              fontWeight: FontWeight.w500)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
