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
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class AddChildScreen extends StatefulWidget {
  @override
  _AddChildScreenState createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  final FocusNode _fullNameFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _classNameFocus = FocusNode();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _classNameController = TextEditingController();

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
                      'Add New Child',
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
                      'Join your child with us!',
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
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Center(
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              if (homeParentController.isImageLoading)
                                const CircularProgressIndicator(),
                              if (homeParentController.image != null)
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.white,
                                  backgroundImage:
                                      FileImage(homeParentController.image!),
                                ),
                              if (homeParentController.image == null &&
                                  !homeParentController.isImageLoading)
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
                      CustomTextField(
                        hintText: 'Address',
                        controller: _addressController,
                        focusNode: _addressFocus,
                        nextFocus: _classNameFocus,
                        inputType: TextInputType.text,
                        divider: true,
                      ),
                      Row(children: [
                        Expanded(
                            child: homeParentController.schools != []
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.PADDING_SIZE_SMALL),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.RADIUS_SMALL),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.shade200,
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 5))
                                      ],
                                    ),
                                    child: DropdownButton(
                                      value:
                                          homeParentController.selectedSchool ??
                                              homeParentController.schools[0],
                                      items: homeParentController.schools
                                          .map((value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child:
                                              Text(value.schoolName.toString()),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        homeParentController
                                            .selectSchool(value);
                                      },
                                      isExpanded: true,
                                      underline: SizedBox(),
                                    ),
                                  )
                                : const Center(
                                    child: CircularProgressIndicator())),
                      ]),
                      Row(children: [
                        Expanded(
                            child: homeParentController.buses != []
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.PADDING_SIZE_SMALL),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.RADIUS_SMALL),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.shade200,
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 5))
                                      ],
                                    ),
                                    child: DropdownButton(
                                      value: homeParentController.selectedBus ??
                                          homeParentController.buses[0],
                                      items: homeParentController.buses
                                          .map((value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child:
                                              Text(value.bus_number.toString()),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        homeParentController.selectBus(value);
                                      },
                                      isExpanded: true,
                                      underline: SizedBox(),
                                    ),
                                  )
                                : const Center(
                                    child: CircularProgressIndicator())),
                      ]),
                      CustomTextField(
                        hintText: 'Class Name',
                        controller: _classNameController,
                        focusNode: _classNameFocus,
                        inputType: TextInputType.text,
                        divider: true,
                      ),
                      Row(children: [
                        Expanded(
                            child: homeParentController.drivers != []
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.PADDING_SIZE_SMALL),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.RADIUS_SMALL),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.shade200,
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 5))
                                      ],
                                    ),
                                    child: DropdownButton(
                                      value:
                                          homeParentController.selectedDriver ??
                                              homeParentController.drivers[0],
                                      items: homeParentController.drivers
                                          .map((value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(value.fullName!),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        homeParentController
                                            .selectDriver(value);
                                      },
                                      isExpanded: true,
                                      underline: SizedBox(),
                                    ),
                                  )
                                : const Center(
                                    child: CircularProgressIndicator())),
                      ]),
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

    if (_fullName.isEmpty) {
      showCustomSnackBar('Enter child name');
    } else if (_address.isEmpty) {
      showCustomSnackBar('Enter School Name');
    } else if (_className.isEmpty) {
      showCustomSnackBar('Enter class Name');
    } else if (homeParentController.image == null) {
      showCustomSnackBar('Please choose a child image');
    } else if (homeParentController.selectedDriver == null) {
      showCustomSnackBar('Please choose a driver!');
    } else if (homeParentController.selectedBus!.id == '0') {
      showCustomSnackBar('Please choose a Bus!');
       } else if (homeParentController.selectedSchool!.id == '0') {
      showCustomSnackBar('Please choose a School!');
    } else {
      homeParentController
          .addNewChild(
              _fullName,
              _address,
              _className,
              homeParentController.selectedSchool!,
              homeParentController.selectedDriver!,
              homeParentController.selectedBus!)
          .then((response) async {
        if (response) {
          Get.offAndToNamed(RouteHelper.getParentHomeRoute());
          showCustomSnackBar("Child Addded Successfully!", isError: false);
        } else {
          print(response);
          showCustomSnackBar("Failed to Addded Successfully!", isError: true);
        }
      });
    }
  }
}
