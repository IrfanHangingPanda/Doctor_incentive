import 'package:flutter/material.dart';

class Textsize {
  static double screenWidth = 0.0;
  static double screenHeight = 0.0;
  static double titleSize = 0.0;
  static double subTitle = 0.0;
  static double descriptionSize = 0.0;
  void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    titleSize = MediaQuery.of(context).size.height * 0.016;
    subTitle = MediaQuery.of(context).size.height * 0.014;
    descriptionSize = MediaQuery.of(context).size.height * 0.012;
  }
}
