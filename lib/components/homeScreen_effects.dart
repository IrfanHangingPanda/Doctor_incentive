import 'package:doctors_incentive/model/textsize.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class HomeScreenEffects extends StatefulWidget {
  const HomeScreenEffects({super.key});

  @override
  State<HomeScreenEffects> createState() => _HomeScreenEffectsState();
}

class _HomeScreenEffectsState extends State<HomeScreenEffects> {
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      colorOpacity: 0.3,
      child: Column(
        children: [
          Container(
            height: Textsize.screenHeight * 0.15,
            width: Textsize.screenHeight * 0.15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              maxRadius: 15,
              minRadius: 15,
            ),
          ),
          Container(
            width: Textsize.screenWidth * 0.04,
          ),
          Container(
            height: Textsize.screenHeight * 0.01,
          ),
          Text(
            "",
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.w400),
          ),
          Text(
            "Super Speciality",
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: Textsize.subTitle,
                color: Colors.white,
                fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }
}
