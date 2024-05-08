// import 'package:doctors_incentive/apiController/adminChatController.dart';
// import 'package:doctors_incentive/apiController/contactAdminController.dart';
// import 'package:doctors_incentive/model/textsize.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// class ContactAdminChat extends StatefulWidget {
//   const ContactAdminChat({super.key});

//   @override
//   State<ContactAdminChat> createState() => _ContactAdminChatState();
// }

// class _ContactAdminChatState extends State<ContactAdminChat> {
//   var contactadmincontroller = Get.put(ContactAdminController());
//   var adminchatGetController = Get.put(AdminChatController());

//   @override
//   void initState() {
//     adminchatGetController.dataSendToServer();

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           iconTheme: IconThemeData(
//             color: Colors.white, //change your color here
//           ),
//           elevation: 0,
//           backgroundColor: Color(0XFFFDAC2F),
//           centerTitle: true,
//           title: const Text(
//             'Admin',
//             style: TextStyle(fontSize: 18, color: Colors.white),
//           ),
//           actions: [
//             InkWell(
//               onTap: () {
//                 adminchatGetController.dataSendToServer();
//                 print("Refresh");
//               },
//               child: Icon(
//                 Icons.refresh,
//                 color: Colors.white,
//               ),
//             )
//           ],
//         ),
//         body: Obx(
//           () => adminchatGetController.isDataLoading.value
//               ? Center(
//                   child: CircularProgressIndicator(
//                   color: Color(0XFFFDAC2F),
//                 ))
//               : Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Container(
//                     width: Textsize.screenWidth,
//                     height: Textsize.screenHeight,
//                     child: Column(
//                       children: [
//                         Expanded(
//                             child: ListView.builder(
//                           // reverse: true,
//                           itemCount:
//                               adminchatGetController.chatGetDetails.length,

//                           itemBuilder: (context, index) {
//                             final isMe = adminchatGetController
//                                     .chatGetDetails[index]['type'] ==
//                                 2;
//                             final currentMessageDate = DateTime.parse(
//                                 adminchatGetController.chatGetDetails[index]
//                                     ['date']);
//                             final prevMessageDate = index > 0
//                                 ? DateTime.parse(adminchatGetController
//                                     .chatGetDetails[index - 1]['date'])
//                                 : null;
//                             var timeData = adminchatGetController
//                                         .chatGetDetails[index]['time'] !=
//                                     null
//                                 ? adminchatGetController.chatGetDetails[index]
//                                     ['time']
//                                 : '00:00:00';
//                             DateFormat inputFormat = DateFormat('HH:mm:ss');
//                             DateTime dateTime = inputFormat.parse(timeData);

//                             // Formatting the time as "10:12"
//                             DateFormat outputFormat = DateFormat('HH:mm');
//                             String formattedTime =
//                                 outputFormat.format(dateTime);
//                             // Check if the date has changed
//                             final showDate = prevMessageDate == null ||
//                                 currentMessageDate.day != prevMessageDate.day ||
//                                 currentMessageDate.month !=
//                                     prevMessageDate.month ||
//                                 currentMessageDate.year != prevMessageDate.year;
//                             return Column(
//                               children: [
//                                 if (showDate)
//                                   Padding(
//                                     padding: const EdgeInsets.all(10.0),
//                                     child: Text(
//                                       DateFormat('d MMM y')
//                                           .format(currentMessageDate),
//                                       style: TextStyle(
//                                         //fontSize: Textsize.subTitle,
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                   ),
//                                 Padding(
//                                   padding: EdgeInsets.symmetric(
//                                     vertical: 2.0,
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment: isMe
//                                         ? MainAxisAlignment.end
//                                         : MainAxisAlignment.start,
//                                     children: [
//                                       Container(
//                                         width: 250,
//                                         decoration: BoxDecoration(
//                                           // color: Colors.grey,
//                                           // color: Color(0XFF65A4C5),
//                                           color: isMe
//                                               ? Color(0XFF65A4C5)
//                                               : Colors.grey,
//                                           borderRadius:
//                                               BorderRadius.circular(5.0),
//                                         ),
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 10.0, vertical: 10.0),
//                                         child: Container(
//                                           child: Column(
//                                             children: [
//                                               Align(
//                                                 alignment: Alignment.centerLeft,
//                                                 child: Text(
//                                                   adminchatGetController
//                                                           .chatGetDetails[index]
//                                                       ['messages'],
//                                                   style: TextStyle(
//                                                     fontSize:
//                                                         Textsize.titleSize,
//                                                     color: Colors.white,
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 height: 5,
//                                               ),
//                                               Align(
//                                                 alignment:
//                                                     Alignment.bottomRight,
//                                                 child: Text(
//                                                   adminchatGetController
//                                                                   .chatGetDetails[
//                                                               index]['time'] !=
//                                                           null
//                                                       ? formattedTime
//                                                       : '',
//                                                   style: TextStyle(
//                                                     fontSize: Textsize.subTitle,
//                                                     color: Colors.white,
//                                                   ),
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             );
//                           },
//                         )),
//                         Container(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 10.0, vertical: 3.0),
//                           color: Colors.white,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: TextField(
//                                   controller:
//                                       contactadmincontroller.messageController,
//                                   decoration: InputDecoration(
//                                     hintText: 'Type a message',
//                                   ),
//                                 ),
//                               ),
//                               IconButton(
//                                 icon: Icon(
//                                   Icons.send,
//                                   color: Color(0XFFFDAC2F),
//                                 ),
//                                 onPressed: () {
//                                   contactadmincontroller.sendData(
//                                       contactadmincontroller
//                                           .messageController.text);
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//         ));
//   }
// }
