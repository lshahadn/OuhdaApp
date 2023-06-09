import 'dart:convert';

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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class UpdateChildScreen extends StatefulWidget {
  ChildModel model;
  UpdateChildScreen({required this.model});
  @override
  _UpdateChildScreenState createState() => _UpdateChildScreenState();
}

class _UpdateChildScreenState extends State<UpdateChildScreen> {
  final FocusNode _fullNameFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _classNameFocus = FocusNode();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _classNameController = TextEditingController();

  @override
  void initState() {
    print("widget.model.id");
    print(widget.model.id);
    _fullNameController = TextEditingController(text: widget.model.name);
    _addressController = TextEditingController(text: widget.model.address);
    _classNameController = TextEditingController(text: widget.model.className);
    _fullNameController = TextEditingController(text: widget.model.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.model.image);
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
                  GetBuilder<ParentController>(builder: (homeParentController) {
                // homeParentController.getDrivers();
                return Column(children: [
                  LottieBuilder.asset(Images.children,
                      height: MediaQuery.of(context).size.height * 0.2),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Center(
                    child: Text(
                      'Update Child',
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
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Center(
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              if (homeParentController.image == null &&
                                  widget.model.image != '')
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.white,
                                  backgroundImage:
                                      NetworkImage(widget.model.image!),
                                ),
                              if (homeParentController.isImageLoading)
                                const CircularProgressIndicator(),
                              if (homeParentController.image != null &&
                                  widget.model.image != '')
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.white,
                                  backgroundImage:
                                      FileImage(homeParentController.image!),
                                ),
                              if (homeParentController.image == null &&
                                  !homeParentController.isImageLoading &&
                                  widget.model.image == '')
                                const CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.white,
                                  backgroundImage:
                                      AssetImage('assets/images/child.jpg'),
                                ),
                              if (!homeParentController.isImageLoading)
                                Positioned(
                                  left: -10,
                                  top: 45,
                                  child: InkWell(
                                    onTap: () {
                                      homeParentController.selectImage();
                                    },
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: AppConstants.mainColor,
                                      child: const Icon(
                                        FontAwesomeIcons.camera,
                                        color: Colors.white,
                                        size: 17,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      CustomTextField(
                        hintText: 'Full Name',
                        controller: _fullNameController,
                        focusNode: _fullNameFocus,
                        nextFocus: _fullNameFocus,
                        inputType: TextInputType.name,
                        capitalization: TextCapitalization.words,
                        // prefixIcon: Images.user,
                        divider: true,
                      ),
                      // CustomTextField(
                      //   hintText: 'School Name',
                      //   controller: _addressController,
                      //   focusNode: _addressFocus,
                      //   nextFocus: _classNameFocus,
                      //   inputType: TextInputType.text,
                      //   divider: true,
                      // ),
                      CustomTextField(
                        hintText: 'Class Name',
                        controller: _classNameController,
                        focusNode: _classNameFocus,
                        nextFocus: _classNameFocus,
                        inputType: TextInputType.text,
                        divider: true,
                      ),
                    ]),
                  ),
                  const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                  !homeParentController.isLoading
                      ? Row(children: [
                          Expanded(
                              child: CustomButton(
                            buttonText: 'Save',
                            onPressed: () => _save(homeParentController),
                          )),
                        ])
                      : Center(child: CircularProgressIndicator()),
                  const SizedBox(height: 20),
                  TextButton(
                      onPressed: () {
                        Get.toNamed(RouteHelper.getParentHomeRoute());
                      },
                      child: Text(
                        "back to Home",
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

  void _save(ParentController homeParentController) async {
    String _fullName = _fullNameController.text.trim();
    String _address = _addressController.text.trim();
    String _className = _classNameController.text.trim();
    print(widget.model.image);
    if (_fullName.isEmpty) {
      showCustomSnackBar('Enter child name');
    // } else if (_address.isEmpty) {
    //   showCustomSnackBar('Enter School Name');
    } else if (_className.isEmpty) {
      showCustomSnackBar('Enter class Name');
    } else {


      homeParentController
          .updateChild(widget.model.id, _fullName, _address, _className)
          .then((response) async {
        if (response) {
          Get.offAndToNamed(RouteHelper.getParentHomeRoute());
          showCustomSnackBar("Child Updated Successfully!", isError: false);
        } else {
          print(response);
          showCustomSnackBar("Failed to Updated Successfully!", isError: true);
        }
      });
    }
  }
}
