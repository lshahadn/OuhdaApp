import 'package:bustracking/controllers/admin/admin_controller.dart';
import 'package:bustracking/controllers/parent/parent_controller.dart';
import 'package:bustracking/data/app_data.dart';
import 'package:bustracking/data/models/body/bus_model.dart';
import 'package:bustracking/data/models/body/child_info.dart';
import 'package:bustracking/data/models/body/route_model.dart';
import 'package:bustracking/data/models/body/school_model.dart';
import 'package:bustracking/data/models/body/user_model.dart';
import 'package:bustracking/helper/route_helper.dart';
import 'package:bustracking/layout/screens/AdminScreens/bus/edit_bus_modal.dart';
import 'package:bustracking/layout/screens/AdminScreens/routes/edit_route_modal.dart';
import 'package:bustracking/layout/screens/AdminScreens/schools/edit_school_modal.dart';
import 'package:bustracking/layout/widgets/custom_btn.dart';
import 'package:bustracking/layout/widgets/custom_button.dart';
import 'package:bustracking/layout/widgets/custom_empty_box.dart';
import 'package:bustracking/util/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ParentsScreen extends StatefulWidget {
  const ParentsScreen({Key? key}) : super(key: key);

  @override
  State<ParentsScreen> createState() => _ParentsScreenState();
}

class _ParentsScreenState extends State<ParentsScreen> {
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
    return GetBuilder<AdminController>(builder: (adminController) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Parents"),
          actions: [],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              _parentWidget(adminController),
            ],
          ),
        ),
      );
    });
  }

  Widget _parentWidget(AdminController adminController) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.supervised_user_circle_sharp,
                color: AppConstants.mainColor,
                size: 25,
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                "Parents Info",
                style: GoogleFonts.lato(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Get.toNamed(RouteHelper.getSignUpRoute());
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
                        "Add Parent",
                        style: GoogleFonts.lato(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('accountType', isEqualTo: 'parent')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.data!.docs.isEmpty) {
              return Center(child: EmptyBoxWidget());
            }

            return ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                adminController.parents.add(UserModel.fromJson(data));
                return parentInfoBuilder(
                    UserModel.fromJson(data), adminController);
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
  Widget parentInfoBuilder(UserModel model, AdminController controller) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: () {},
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
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://gravatar.com/avatar/cab04dccc1b4ddeedd2d51d133e31a6f?s=400&d=robohash&r=x'),
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
                      model.fullName!,
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${model.phone}",
                      style:
                          GoogleFonts.lato(fontSize: 16, color: Colors.black),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      "${model.email}",
                      style: GoogleFonts.lato(fontSize: 15, color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
            bottom: -5,
            right: 30,
            child: CircleAvatar(
              backgroundColor: Colors.red,
              child: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    print("delete");
                    controller.deleteUser(model.id);
                  },
                  icon: Icon(Icons.delete)),
            )),
        Positioned(
            bottom: -5,
            right: 80,
            child: CircleAvatar(
              backgroundColor: Colors.green,
              child: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    Get.toNamed(RouteHelper.getUpdateParentProfileRoute(model));
                  },
                  icon: Icon(Icons.edit)),
            ))
      ],
    );
  }
}
