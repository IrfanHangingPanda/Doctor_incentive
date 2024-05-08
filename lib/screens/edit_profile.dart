import 'package:doctors_incentive/apiController/lockupController.dart';
import 'package:doctors_incentive/apiController/updateProfileController.dart';
import 'package:doctors_incentive/apiController/updateimageController.dart';
import 'package:doctors_incentive/apiController/userDetailController.dart';
import 'package:doctors_incentive/components/profileScreen_effect.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class EditprofileScreen extends StatefulWidget {
  const EditprofileScreen({super.key});

  @override
  State<EditprofileScreen> createState() => _EditprofileScreenState();
}

class _EditprofileScreenState extends State<EditprofileScreen>
    with WidgetsBindingObserver {
  var updateProfilecontroller = Get.put(UpdateProfileController());
  var imageupdatecontroller = Get.put(UpdateProfileImageController());
  var userdetailcontroller = Get.put(UserDetailsController());
  var lockupContoller = Get.put(LockupController());
  var nameCom = '';
  var emailCom = '';
  var phonecom = '';
  var genderCom = '';
  @override
  void initState() {
    initialGetUserData();
    super.initState();
  }

  initialGetUserData() {
    userdetailcontroller.dataSendToServer();
    nameCom = userdetailcontroller.nameController.text;
    emailCom = userdetailcontroller.emailController.text;
    phonecom = userdetailcontroller.phoneController.text;
    setState(() {});
  }

  final ImagePicker _picker = ImagePicker();
  XFile? cameraFile;

  selectFromCamera() async {
    cameraFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    imageupdatecontroller.sendData(context, cameraFile?.path);

    setState(() {});
  }

  selectFromGellary() async {
    cameraFile = await _picker.pickImage(source: ImageSource.gallery);
    imageupdatecontroller.sendData(context, cameraFile?.path);
    setState(() {});
  }

  Future<void> _showModalBottomSheet() async {
    (showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.camera,
                  color: Color(0XFF64a3c4),
                ),
                title: const Text('Camera'),
                onTap: () {
                  selectFromCamera();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo, color: Color(0XFF64a3c4)),
                title: const Text('Gellary'),
                onTap: () {
                  selectFromGellary();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }));
  }

  String? gender;
  var gendertype = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print(gendertype);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0XFFFDAC2F),
          centerTitle: true,
          title: Text(
            'Edit Profile',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
        body: Obx(() => userdetailcontroller.isDataLoading.value
            ? ProfileScreenEffects()
            : GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: SingleChildScrollView(
                    child: Form(
                  key: _formKey,
                  child: Container(
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.center,
                      child: Column(children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.32,
                          height: MediaQuery.of(context).size.height * 0.16,
                          child: Stack(
                            children: [
                              Obx(
                                () => imageupdatecontroller.isDataLoading.value
                                    ? Shimmer(
                                        colorOpacity: 0.6,
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.155,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Color(0XFF64a3c4)
                                                .withOpacity(0.4),
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.155,
                                        decoration: userdetailcontroller
                                                    .details['profile_image'] ==
                                                ''
                                            ? BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                                image: const DecorationImage(
                                                    image: AssetImage(
                                                        'assets/images/doctor.jpg'),
                                                    fit: BoxFit.cover))
                                            : BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        userdetailcontroller.details['profile_image']),
                                                    fit: BoxFit.cover))),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
                                  width:
                                      MediaQuery.of(context).size.width * 0.06,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(2),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.7),
                                            blurRadius: 1)
                                      ]),
                                  child: InkWell(
                                    onTap: () {
                                      _showModalBottomSheet();
                                    },
                                    child: const Icon(
                                      Icons.camera_alt_outlined,
                                      color: Color(0XFF64a3c4),
                                      size: 18,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Name",
                            style: const TextStyle(
                                fontSize: 14, color: Color(0XFFC4C4C4)),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.057,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 2.0,
                                spreadRadius: 2,
                                offset: const Offset(
                                  0,
                                  0,
                                ),
                              )
                            ],
                          ),
                          child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  userdetailcontroller.nameController.text;
                                });
                              },
                              controller: userdetailcontroller.nameController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(10),
                                  hintText: 'Your Name',
                                  hintStyle: TextStyle(
                                      color: Colors.black, fontSize: 14))),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Gender',
                            style: const TextStyle(
                                fontSize: 14, color: Color(0XFFC4C4C4)),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Obx(
                          () => lockupContoller.isDataLoading.value
                              ? Center(
                                  child: Container(
                                      alignment: Alignment.center,
                                      color: Colors.white,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      child: CircularProgressIndicator(
                                        color: Color(0XFF64a3c4),
                                      )),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    for (var i = 0;
                                        i < lockupContoller.lockupData.length;
                                        i++)
                                      Row(
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.05,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.26,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  blurRadius: 2.0,
                                                  spreadRadius: 2,
                                                  offset: const Offset(
                                                    0,
                                                    0,
                                                  ),
                                                )
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8,
                                                          top: 8,
                                                          bottom: 8,
                                                          right: 2),
                                                  child: SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child: Radio(
                                                        value: lockupContoller
                                                            .lockupData[i]
                                                                ['name']['en']
                                                            .toString(),
                                                        fillColor:
                                                            MaterialStateColor
                                                                .resolveWith(
                                                          (Set<MaterialState>
                                                              states) {
                                                            if (states.contains(
                                                                MaterialState
                                                                    .selected)) {
                                                              return Color(
                                                                  0XFF64a3c4);
                                                            }
                                                            return Colors.grey;
                                                          },
                                                        ),
                                                        groupValue: userdetailcontroller
                                                                        .details[
                                                                    'gender_type'] ==
                                                                null
                                                            ? gender
                                                            : userdetailcontroller
                                                                        .details[
                                                                    'gender_type']
                                                                ['name']['en'],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            userdetailcontroller
                                                                            .details[
                                                                        'gender_type'] ==
                                                                    null
                                                                ? gender = value
                                                                    .toString()
                                                                : userdetailcontroller
                                                                            .details['gender_type']
                                                                        [
                                                                        'name']['en'] =
                                                                    value
                                                                        .toString();

                                                            gendertype =
                                                                lockupContoller
                                                                    .lockupData[
                                                                        i]['id']
                                                                    .toString();
                                                          });
                                                        }),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8,
                                                          top: 8,
                                                          bottom: 8,
                                                          left: 2),
                                                  child: Text(
                                                      lockupContoller
                                                              .lockupData[i]
                                                          ['name']['en'],
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 40,
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Email',
                            style: const TextStyle(
                                fontSize: 14, color: Color(0XFFC4C4C4)),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.057,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 2.0,
                                spreadRadius: 2,
                                offset: const Offset(
                                  0,
                                  0,
                                ),
                              )
                            ],
                          ),
                          child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  userdetailcontroller.emailController.text;
                                });
                              },
                              controller: userdetailcontroller.emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(10),
                                  hintText: 'example@gmail.com',
                                  hintStyle: TextStyle(
                                      color: Colors.black, fontSize: 14))),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Mobile No.",
                            style: const TextStyle(
                                fontSize: 14, color: Color(0XFFC4C4C4)),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.057,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 2.0,
                                spreadRadius: 2,
                                offset: const Offset(
                                  0,
                                  0,
                                ),
                              )
                            ],
                          ),
                          child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  userdetailcontroller.phoneController.text;
                                });
                              },
                              controller: userdetailcontroller.phoneController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(10),
                                  hintText: '96XXXXXXXX',
                                  hintStyle: TextStyle(
                                      color: Colors.black, fontSize: 14))),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.056,
                              width: MediaQuery.of(context).size.width * 0.41,
                              child: TextButton(
                                onPressed: () {
                                  print(
                                      userdetailcontroller.nameController.text);
                                  Get.back();
                                },
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(7.0),
                                        side: BorderSide(
                                            color:
                                                Colors.grey.withOpacity(0.7)))),
                                child: Text("Cancel",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.018,
                                        color: Colors.black)),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.056,
                                width: MediaQuery.of(context).size.width * 0.41,
                                child: TextButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        if (nameCom !=
                                                userdetailcontroller
                                                    .nameController.text ||
                                            emailCom !=
                                                userdetailcontroller
                                                    .emailController.text ||
                                            phonecom !=
                                                userdetailcontroller
                                                    .phoneController.text) {
                                          updateProfilecontroller.sendData(
                                              context,
                                              initialGetUserData,
                                              userdetailcontroller
                                                  .nameController.text,
                                              userdetailcontroller
                                                  .emailController.text,
                                              userdetailcontroller
                                                  .phoneController.text,
                                              gendertype);
                                        }
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                        backgroundColor: nameCom !=
                                                    userdetailcontroller
                                                        .nameController.text ||
                                                emailCom !=
                                                    userdetailcontroller
                                                        .emailController.text ||
                                                phonecom !=
                                                    userdetailcontroller
                                                        .phoneController.text ||
                                                genderCom != gendertype &&
                                                    gendertype != ''
                                            ? Color(0XFFFDAC2F)
                                            : Colors.grey,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(7.0),
                                        )),
                                    child: Obx(
                                      () => updateProfilecontroller
                                              .isDataLoading.value
                                          ? SizedBox(
                                              child:
                                                  const CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 3,
                                              ),
                                              height: 22.0,
                                              width: 22.0,
                                            )
                                          : Text("Save",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.018,
                                                  color: Colors.white)),
                                    ))),
                          ],
                        )
                      ])),
                )),
              )));
  }
}
