import 'dart:convert';

import 'package:bustracking/controllers/admin/admin_controller.dart';
import 'package:bustracking/controllers/auth_controller.dart';
import 'package:bustracking/controllers/parent/parent_controller.dart';
import 'package:bustracking/controllers/splash_controller.dart';
import 'package:bustracking/data/models/body/child_info.dart';
import 'package:bustracking/data/models/body/user_model.dart';
import 'package:bustracking/helper/route_helper.dart';
import 'package:bustracking/layout/screens/ParentsScreens/home/parent_home_screen.dart';
import 'package:bustracking/layout/widgets/custom_button.dart';
import 'package:bustracking/layout/widgets/custom_snackbar.dart';
import 'package:bustracking/layout/widgets/custom_text_field.dart';
import 'package:bustracking/util/app_constants.dart';
import 'package:bustracking/util/dimensions.dart';
import 'package:bustracking/util/images.dart';
import 'package:bustracking/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class AddSchoolScreen extends StatefulWidget {
  @override
  _AddSchoolScreenState createState() => _AddSchoolScreenState();
}

class _AddSchoolScreenState extends State<AddSchoolScreen> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _schoolNameFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _schoolNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Container(
              width: context.width > 700 ? 700 : context.width,
              padding: context.width > 700
                  ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT)
                  : null,
              decoration: context.width > 700
                  ? BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius:
                          BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 5,
                            spreadRadius: 1)
                      ],
                    )
                  : null,
              child:
                  GetBuilder<AdminController>(builder: (adminController) {
                return Column(children: [
                                Image.asset(Images.school, width: 200, height: 150),

                  const SizedBox(
                    height: 15.0,
                  ),
                  Center(
                    child: Text(
                      'Add New School',
                      style: TextStyle(
                          fontSize: 30.0,
                          letterSpacing: 3.0,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.mainColor,
                          fontFamily: 'Cairo'),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  const Center(
                    child: Text(
                      'Increase your schools!',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade200,
                            spreadRadius: 1,
                            blurRadius: 8)
                      ],
                    ),
                    child: Column(children: [
                      CustomTextField(
                        hintText: 'Email',
                        controller: _emailController,
                        focusNode: _emailFocus,
                        nextFocus: _emailFocus,
                        inputType: TextInputType.emailAddress,
                        capitalization: TextCapitalization.words,
                        // prefixIcon: Images.user,
                        divider: true,
                      ),
                      CustomTextField(
                        hintText: 'School Name',
                        controller: _schoolNameController,
                        focusNode: _schoolNameFocus,
                        nextFocus: _schoolNameFocus,
                        inputType: TextInputType.text,
                        divider: true,
                      ),
                      ]),
                  ),
                  const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                  !adminController.isLoading
                      ? Row(children: [
                          Expanded(
                              child: CustomButton(
                            buttonText: 'Save',
                            onPressed: () => _save(adminController),
                          )),
                        ])
                      : Center(child: CircularProgressIndicator()),
                  const SizedBox(height: 20),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Back",
                        style: TextStyle(
                            color: AppConstants.mainColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0),
                      )),
                ]);
              }),
            ),
          ),
        ),
      )),
    );
  }

  void _save(AdminController adminController) async {
    String _email = _emailController.text.trim();
    String _schoolName = _schoolNameController.text.trim();

    if (_email.isEmpty) {
      showCustomSnackBar('Enter email address');
    } else if (_schoolName.isEmpty) {
      showCustomSnackBar('Enter School Name');
    } else {
      adminController
          .addNewSchool(_email, _schoolName)
          .then((response) async {
        if (response) {
          Get.toNamed(RouteHelper.getSchoolsRoute());
          showCustomSnackBar("School Addded Successfully!", isError: false);
        } else {
          print(response);
          showCustomSnackBar("Failed to Add School!", isError: true);
        }
      });
    }
  }

}
