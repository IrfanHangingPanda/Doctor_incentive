import 'package:doctors_incentive/model/textsize.dart';

import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class StatisticsEffects extends StatefulWidget {
  const StatisticsEffects({super.key});

  @override
  State<StatisticsEffects> createState() => _StatisticsEffectsState();
}

class _StatisticsEffectsState extends State<StatisticsEffects> {
  @override
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      colorOpacity: 0.6,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 40, bottom: 20),
                height: Textsize.screenHeight * 0.28,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 167, 203, 222).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20)),
              ),
            ],
          ),
          Container(
            height: Textsize.screenHeight * 0.02,
          ),
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 40, bottom: 20),
                height: Textsize.screenHeight * 0.28,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 167, 203, 222).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
