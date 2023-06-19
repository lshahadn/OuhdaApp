import 'package:bustracking/controllers/auth_controller.dart';
import 'package:bustracking/controllers/parent/parent_controller.dart';

import 'package:bustracking/data/models/body/child_info.dart';
import 'package:bustracking/data/models/body/user_model.dart';
import 'package:bustracking/helper/route_helper.dart';
import 'package:bustracking/layout/screens/DriverScreens/qr_generator_screen.dart';
import 'package:bustracking/layout/widgets/custom_btn.dart';
import 'package:bustracking/layout/widgets/custom_button.dart';
import 'package:bustracking/layout/widgets/custom_empty_box.dart';
import 'package:bustracking/layout/widgets/custom_snackbar.dart';
import 'package:bustracking/util/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomeParentScreen extends StatefulWidget {
  const HomeParentScreen({Key? key}) : super(key: key);

  @override
  State<HomeParentScreen> createState() => _HomeParentScreenState();
}

class _HomeParentScreenState extends State<HomeParentScreen> {
  UserModel? user;
  @override
  void initState() {
    super.initState();
    // user = AppCubit.get(context).userData;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParentController>(builder: (parentController) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              _topBar(parentController),
              const SizedBox(
                height: 20,
              ),
              _childrenWidget(parentController),
            ],
          ),
        ),
      );
    });
  }

  // Top bar
  Widget _topBar(ParentController parentController) {
    return Container(
      color: AppConstants.mainColor,
      padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
      child: Row(
        children: [
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(3.5),
              height: 50,
              width: 50,
              child: const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://gravatar.com/avatar/cab04dccc1b4ddeedd2d51d133e31a6f?s=400&d=robohash&r=x')),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hi,',
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 90,
                        child: Text(
                          '@${parentController.getUsername()}',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 15,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          IconButton(
              onPressed: () {
                Get.toNamed(RouteHelper.getNotificationRoute());
              },
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Icon(Icons.notifications_none)),
                  Positioned(
                    right: 5.0,
                    top: 2,
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              )),
          IconButton(
              onPressed: () {
                Get.toNamed(RouteHelper.getProfileRoute());
              },
              icon: Icon(Icons.person_outline_sharp)),
          GetBuilder<AuthController>(builder: (auth) {
            return IconButton(
                onPressed: () {
                  auth.signOut();
                },
                icon: Icon(Icons.logout));
          }),
        ],
      ),
    );
  }

  // Children information
  Widget _childrenWidget(ParentController parentController) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.child_care,
                color: AppConstants.mainColor,
                size: 25,
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                "Your Children Info",
                style: GoogleFonts.lato(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              InkWell(
                onTap: () async {
                  await parentController.getDrivers();
                  await parentController.getSchools();
                  await parentController.getBuses().then((value) async {
                    Get.toNamed(RouteHelper.getAddChildRoute());
                  });
                },
                child: Container(
                  // height: 20,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),

                  decoration: BoxDecoration(
                      color: AppConstants.mainColor,
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 3),
                          color: Color.fromARGB(155, 158, 158, 158),
                          blurRadius: 3.0,
                        ),
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        "Add Child",
                        style: GoogleFonts.lato(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              // IconButton(onPressed: () {}, icon: Icon(Icons.add, size: 25, color: AppConstants.mainColor,)),
            ],
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("children")
              .where('parentId', isEqualTo: parentController.getCurrentUserID())
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            print(parentController.getCurrentUserID());

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.data!.docs.isEmpty) {
              return const Center(child: EmptyBoxWidget());
            }

            // return ListView.separated(
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   itemCount: snapshot.data!.docs.length,
            //   itemBuilder: ((context, index) {
            //     snapshot.data!.docs.map((DocumentSnapshot document) {
            //       Map<String, dynamic> data =
            //           document.data() as Map<String, dynamic>;
            //       return childInfoBuilder(ChildModel.fromJson(data));
            //     });
            //   }),
            //   separatorBuilder: ((context, index) {
            //     return const SizedBox(
            //       height: 1,
            //     );
            //   }),
            // );

            return ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                final today = DateTime.now();
                final dateOnly = DateTime(today.year, today.month, today.day);
                var dateAsString =
                    '${dateOnly.day}/${dateOnly.month}/${dateOnly.year}';
                print(dateAsString);
                // update status if next day is came!
                if ((data['status'] != 'at_home' &&
                        data['dateDrop'] != dateAsString &&
                        data['dateDrop'] != '') ||
                    (data['dateAbsent'] != dateAsString &&
                        data['dateAbsent'] != '')) {
                  final DocumentReference documentRef = FirebaseFirestore
                      .instance
                      .collection('children')
                      .doc(document.id);
                  documentRef.update({
                    'status': 'at_home',
                    'dateDrop': '',
                    'dateAbsent': '',
                    'datePicked': '',
                    'goOrReturn': 'at_home',
                  }).then((_) {
                    print('Document updated successfully.');
                  }).catchError((error) {
                    print('Error updating document: $error');
                  });
                }
                return Column(
                  children: [
                    childInfoBuilder(
                        ChildModel.fromJson(data), parentController),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }

  // Child information
  Widget childInfoBuilder(ChildModel model, ParentController parentController) {
    print(" ----------------- model.id -----------------");
    print(model.id);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: () async {
            showCupertinoModalBottomSheet(
                expand: false,
                context: context,
                enableDrag: true,
                topRadius: Radius.circular(20),
                builder: (context) {
                  return QRCodeGenerator(
                    model: model,
                  );
                });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                offset: Offset(0, 3),
                color: Color.fromARGB(155, 214, 212, 212),
                blurRadius: 5.0,
              ),
            ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                      image: NetworkImage(model.image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name!,
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${model.school!.schoolName}",
                      style:
                          GoogleFonts.lato(fontSize: 16, color: Colors.black),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      "${model.className}",
                      style: GoogleFonts.lato(fontSize: 15, color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: model.status == 'absent'
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                            "${model.status!.replaceAll("_", " ").toUpperCase()} (${model.goOrReturn!.replaceAll("_", " ")})",
                            style: GoogleFonts.lato(
                                fontSize: 12, color: Colors.grey)),
                        // Spacer(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (model.status == 'at_home')
          Positioned(
              bottom: -5,
              right: 30,
              child: CustomBtn(
                title: model.status != 'absent'
                    ? "Mark as absent"
                    : 'Already absent',
                onPressed: () {
                  print(model.id);
                  if (model.status != 'absent') {
                    parentController.markAsAbsent(
                        model.id, model.name, model.driverId);
                  } else {
                    showCustomSnackBar("Already absent!", isError: true);
                  }
                },
                fullWidth: false,
                height: 37,
                bg: model.status != 'absent'
                    ? AppConstants.mainColor
                    : Colors.redAccent,
                radius: 30.0,
                fontSize: 17,
              )),
        Positioned(
            top: -5,
            right: 30,
            child: CustomBtn(
              title: 'View',
              onPressed: () async {
                print(model.id);
                parentController.getDriver(model.driverId);
                await parentController.getAllHistoryOfStudent(model.id);
                Get.toNamed(RouteHelper.getLiveStatusRoute(model));
              },
              fullWidth: false,
              height: 37,
              bg: Colors.blue,
              radius: 30.0,
              fontSize: 17,
            )),
      ],
    );
  }
}
