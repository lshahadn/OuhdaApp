import 'package:bustracking/controllers/admin/admin_controller.dart';
import 'package:bustracking/controllers/parent/parent_controller.dart';
import 'package:bustracking/data/app_data.dart';
import 'package:bustracking/data/models/body/child_info.dart';
import 'package:bustracking/data/models/body/school_model.dart';
import 'package:bustracking/data/models/body/user_model.dart';
import 'package:bustracking/helper/route_helper.dart';
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

class SchoolsScreen extends StatefulWidget {
  const SchoolsScreen({Key? key}) : super(key: key);

  @override
  State<SchoolsScreen> createState() => _SchoolsScreenState();
}

class _SchoolsScreenState extends State<SchoolsScreen> {
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
          title: Text("Schools"),
          actions: [
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              _schoolsWidget(adminController),
            ],
          ),
        ),
      );
    });
  }

  // Children information
  Widget _schoolsWidget(AdminController adminController) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.house,
                color: AppConstants.mainColor,
                size: 25,
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                "Schools Info",
                style: GoogleFonts.lato(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Get.toNamed(RouteHelper.getAddNewSchoolRoute());
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
                        "Add School",
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
          stream: FirebaseFirestore.instance.collection('schools').snapshots(),
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
                return schoolInfoBuilder(
                    SchoolModel.fromJson(data), adminController);
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
  Widget schoolInfoBuilder(SchoolModel model, AdminController controller) {
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
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.schoolName!,
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
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
            right: 12,
            child: CircleAvatar(
              backgroundColor: Colors.green,
              child: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    print("delete");
                    showCupertinoModalBottomSheet(
                        expand: false,
                        context: context,
                        enableDrag: true,
                        topRadius: Radius.circular(20),
                        builder: (context) {
                          return EditSchoolModal(
                            model: model,
                          );
                        });
                  },
                  icon: Icon(Icons.edit)),
            )),
        Positioned(
            bottom: -5,
            right: 60,
            child: CircleAvatar(
              backgroundColor: Colors.red,
              child: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    print("delete");
                    controller.deleteSchool(model.id);
                  },
                  icon: Icon(Icons.delete)),
            ))
      ],
    );
  }
}
