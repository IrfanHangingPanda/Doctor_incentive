import 'package:doctors_incentive/model/textsize.dart';

import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class SettingScreenEffects extends StatefulWidget {
  const SettingScreenEffects({super.key});

  @override
  State<SettingScreenEffects> createState() => _SettingScreenEffectsState();
}

class _SettingScreenEffectsState extends State<SettingScreenEffects> {
  bool status = false;
  bool status2 = false;
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        height: Textsize.screenHeight * 0.25,
        width: Textsize.screenWidth,
        color: Color(0XFFFDAC2F),
        child: ListTile(
          leading: Container(
              height: 60,
              width: 60,
              child: CircleAvatar(
                backgroundColor: Colors.white,
              )),
          title: Text('Loading....',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: Textsize.titleSize,
                  fontWeight: FontWeight.w500)),
          subtitle: Text("Tap to edit profile",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: Textsize.subTitle,
                  fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }
}
