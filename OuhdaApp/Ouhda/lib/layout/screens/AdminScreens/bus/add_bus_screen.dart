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

class AddBusScreen extends StatefulWidget {
  @override
  _AddBusScreenState createState() => _AddBusScreenState();
}

class _AddBusScreenState extends State<AddBusScreen> {
  final FocusNode _busNumberFocus = FocusNode();
  final FocusNode _routeFocus = FocusNode();
  final TextEditingController _busNumberController = TextEditingController();
  final TextEditingController _routeController = TextEditingController();

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
              child: GetBuilder<AdminController>(builder: (adminController) {
                return Column(children: [
                  Image.asset(Images.bus_logo_image, width: 200, height: 150),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Center(
                    child: Text(
                      'Add New Bus',
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
                      'Increase your Bus!',
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
                        hintText: 'Bus Number',
                        controller: _busNumberController,
                        focusNode: _busNumberFocus,
                        nextFocus: _busNumberFocus,
                        inputType: TextInputType.number,
                        capitalization: TextCapitalization.words,
                        // prefixIcon: Images.user,
                        divider: true,
                      ),
                      Row(children: [
                        Expanded(
                            child: adminController.routes != []
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
                                      value: adminController.selectedRoute ??
                                          adminController.routes[0],
                                      items:
                                          adminController.routes.map((value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(value.route!),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        adminController.selectRoute(value);
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
    String _busNum = _busNumberController.text.trim();

    if (_busNum.isEmpty) {
      showCustomSnackBar('Enter Bus Number');
    } else if (adminController.selectedRoute == null) {
      showCustomSnackBar('Select Route');
    } else if (adminController.selectedRoute!.id == "0") {
        showCustomSnackBar('Select Route');
    } else {
      print("object");
      adminController
          .addNewBus(_busNum, adminController.selectedRoute!)
          .then((response) async {
        if (response) {
          Get.toNamed(RouteHelper.getBusRoute());
          showCustomSnackBar("Bus Addded Successfully!", isError: false);
        } else {
          print(response);
          showCustomSnackBar("Failed to Add Bus!", isError: true);
        }
      });
    }
  }
}
