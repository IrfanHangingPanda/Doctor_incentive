import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class NotificationEffects extends StatefulWidget {
  const NotificationEffects({super.key});

  @override
  State<NotificationEffects> createState() => _NotificationEffectsState();
}

class _NotificationEffectsState extends State<NotificationEffects> {
  @override
  Widget build(BuildContext context) {
    return Shimmer(
        colorOpacity: 0.6,
        child: Container(
          color: Colors.white,
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: ListTile(
                        tileColor: Colors.grey.withOpacity(0.2),
                        leading: Icon(
                          Icons.circle_notifications_sharp,
                          color: Colors.grey.withOpacity(0.2),
                          size: 50,
                        ),
                        title: Text(""),
                        subtitle: Text(""),
                        trailing: Text(""),
                      ),
                    ),
                  ],
                );
              }),
        ));
  }
}
