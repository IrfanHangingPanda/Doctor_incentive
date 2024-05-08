import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:doctors_incentive/screens/bottombar.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();

    // Create the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    // Create the animation
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 1.8,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/bording.png'))),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    child: AnimatedOpacity(
                      opacity: _isVisible ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 1000),
                      child: ScaleTransition(
                        scale: _animation,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                new BoxShadow(
                                  color: Color.fromARGB(255, 211, 210, 210),
                                  blurRadius: 20.0,
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
                                image:
                                    AssetImage("assets/images/splaceImage.png"),
                                fit: BoxFit.contain,
                              ),
                            ),
                            child: Container(
                                width: 50,
                                height: 50,
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
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 70,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: DefaultTextStyle(
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                              child: AnimatedTextKit(
                                isRepeatingAnimation: false,
                                animatedTexts: [
                                  TyperAnimatedText(
                                    'Financial Department ',
                                  ),
                                ],
                                onTap: () {},
                              ),
                            ),
                          ),
                          Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            alignment: Alignment.center,
                            child: DefaultTextStyle(
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 168, 168, 168),
                              ),
                              child: AnimatedTextKit(
                                isRepeatingAnimation: false,
                                animatedTexts: [
                                  TyperAnimatedText(
                                      'Welcome to our mobile app designed to help you stay on top of your incentives and statistics.',
                                      textAlign: TextAlign.center),
                                ],
                                onTap: () {},
                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.063,
                              width: MediaQuery.of(context).size.width,
                              child: TextButton(
                                onPressed: () {
                                  Get.offAll(Bottombar());
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Color(0XFFFDAC2F),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Text('Let’s Go',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700)),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
