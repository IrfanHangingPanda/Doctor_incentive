import 'package:doctors_incentive/model/textsize.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class IncentiveScreenEffect extends StatefulWidget {
  const IncentiveScreenEffect({super.key});

  @override
  State<IncentiveScreenEffect> createState() => _IncentiveScreenEffectState();
}

class _IncentiveScreenEffectState extends State<IncentiveScreenEffect> {
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      colorOpacity: 0.4,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Card(
          color: Colors.transparent,
          elevation: 0.0,
          child: Column(
            children: [
              SizedBox(
                height: Textsize.screenHeight * 0.02,
              ),
              Container(
                height: Textsize.screenHeight * 0.07,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: 12,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Divider(
                            color: Colors.white.withOpacity(0.2),
                            height: 1,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            height: Textsize.screenHeight * 0.07,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
