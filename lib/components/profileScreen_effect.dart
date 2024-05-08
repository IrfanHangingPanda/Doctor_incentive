import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ProfileScreenEffects extends StatefulWidget {
  const ProfileScreenEffects({super.key});

  @override
  State<ProfileScreenEffects> createState() => _ProfileScreenEffectsState();
}

class _ProfileScreenEffectsState extends State<ProfileScreenEffects> {
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      colorOpacity: 0.6,
      child: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Column(children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.32,
                  height: MediaQuery.of(context).size.height * 0.16,
                  child: Stack(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.height * 0.155,
                          color: Colors.grey.withOpacity(0.1)),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.03,
                          width: MediaQuery.of(context).size.width * 0.06,
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    //  spreadRadius: 0.5,
                                    blurRadius: 1)
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.057,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.grey.withOpacity(0.1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 2.0,
                        spreadRadius: 2,
                        offset: const Offset(
                          0,
                          0,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.044,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (var i = 0; i < 3; i++)
                      Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.26,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.grey.withOpacity(0.1),
                          // border:
                          //     Border.all(color: Colors.grey.withOpacity(0.9)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 2.0,
                              spreadRadius: 2,
                              offset: const Offset(
                                0,
                                0,
                              ),
                            )
                          ],
                        ),
                      ),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.044,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.057,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.grey.withOpacity(0.1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 2.0,
                        spreadRadius: 2,
                        offset: const Offset(
                          0,
                          0,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.044,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.057,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.grey.withOpacity(0.1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 2.0,
                        spreadRadius: 2,
                        offset: const Offset(
                          0,
                          0,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.056,
                        width: MediaQuery.of(context).size.width * 0.41,
                        color: Colors.grey.withOpacity(0.1)),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.056,
                        width: MediaQuery.of(context).size.width * 0.41,
                        color: Colors.grey.withOpacity(0.1)),
                  ],
                )
              ]))),
    );
  }
}
