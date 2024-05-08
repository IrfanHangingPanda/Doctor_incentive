import 'dart:async';

import 'package:doctors_incentive/apiController/forgetController.dart';
import 'package:doctors_incentive/apiController/forgetOtpController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

import 'package:toast/toast.dart';

class ForgetSendOtpScreen extends StatefulWidget {
  final doctorId;
  const ForgetSendOtpScreen({super.key, this.doctorId});

  @override
  State<ForgetSendOtpScreen> createState() => _ForgetSendOtpScreenState();
}

class _ForgetSendOtpScreenState extends State<ForgetSendOtpScreen> {
  var forgetOtpController = Get.put(ForgetOtpController());
  var forgetController = Get.put(ForgetController());
  OtpFieldController otpController = OtpFieldController();
  String otpValue = '';
  bool showResendButton = false; // Track whether to show the resend button
  late Timer _timer; // Timer for 30 seconds
  int remainingTime = 30;
  @override
  void initState() {
    super.initState();
    print("doctorId after navigate otp screen ");
    print(widget.doctorId);
    print("doctorId after navigate otp screen ");

    // Start the 30-second timer
    startTimer();
  }

  void startTimer() {
    const duration = Duration(seconds: 1); // Decrease duration to 1 second
    _timer = Timer.periodic(duration, (Timer timer) {
      setState(() {
        remainingTime = 30 - timer.tick;
        // After 30 seconds, set the flag to show the resend button
        if (timer.tick >= 30) {
          showResendButton = true;
          timer.cancel(); // Stop the timer
        }
      });
    });
  }

  @override
  void dispose() {
    // Cancel the timer to avoid memory leaks
    _timer.cancel();
    super.dispose();
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
                    'please enter 4 digit code sent to your phone number',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.withOpacity(0.7),
                        fontWeight: FontWeight.w500)),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.07,
              ),
              Align(
                child: OTPTextField(
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
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.063,
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                    onPressed: () async {
                      // SharedPreferences prefs =
                      //     await SharedPreferences.getInstance();

                      print(otpValue);
                      if (otpValue == '') {
                        Toast.show(
                          "Please enter your otp",
                          duration: Toast.lengthShort,
                          gravity: 0,
                        );
                      } else {
                        forgetOtpController.sendData(context, otpValue);
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0XFFFDAC2F),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11.0),
                          side: const BorderSide(color: Color(0XFFFDAC2F))),
                    ),
                    child: Obx(
                      () => forgetOtpController.isDataLoading.value
                          ? SizedBox(
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                              height: 30,
                              width: 30,
                            )
                          : Text('Verify Otp',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700)),
                    ),
                  )),
              Container(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Visibility(
                  visible: !showResendButton,
                  child: Text('Resend after ' + ('$remainingTime' + ' second'),
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0XFFD31901),
                          fontWeight: FontWeight.w500))),
              Visibility(
                  visible: showResendButton,
                  child: Align(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('If you didn`t receive code,',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0XFFC4C4C4),
                                fontWeight: FontWeight.w500)),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.01,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              showResendButton = false;
                              remainingTime = 30; // Reset the remaining time
                            });
                            forgetController.sendData(context, widget.doctorId);
                            // forgetOtpController.sendData(context, otpController);
                            startTimer(); // Start the timer again
                          },
                          child: const Text('Resend',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0XFFD31901),
                                  fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
