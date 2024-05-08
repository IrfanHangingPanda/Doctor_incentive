import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class InformationEffects extends StatefulWidget {
  const InformationEffects({super.key});

  @override
  State<InformationEffects> createState() => _InformationEffectsState();
}

class _InformationEffectsState extends State<InformationEffects> {
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      colorOpacity: 0.4,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Card(
              borderOnForeground: false,
              color: Colors.white,
              elevation: 0.5,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: AlignmentDirectional.centerStart,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                  ),
                  Container(
                    height: 100,
                    child: ListView.builder(
                        itemCount: 2,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              child: Material(
                            animationDuration: Duration(milliseconds: 1000),
                            color: index % 2 != 0
                                ? Colors.grey.withOpacity(0.1)
                                : Colors.grey.withOpacity(0.1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  alignment: Alignment.center,
                                  height: 50,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  alignment: AlignmentDirectional.center,
                                  height: 50,
                                ),
                              ],
                            ),
                          ));
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
