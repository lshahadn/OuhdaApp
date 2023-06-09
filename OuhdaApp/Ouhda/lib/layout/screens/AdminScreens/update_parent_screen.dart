import 'dart:convert';

import 'package:bustracking/controllers/auth_controller.dart';
import 'package:bustracking/controllers/splash_controller.dart';
import 'package:bustracking/data/models/body/user_model.dart';
import 'package:bustracking/helper/route_helper.dart';
import 'package:bustracking/layout/widgets/custom_button.dart';
import 'package:bustracking/layout/widgets/custom_snackbar.dart';
import 'package:bustracking/layout/widgets/custom_text_field.dart';
import 'package:bustracking/util/app_constants.dart';
import 'package:bustracking/util/dimensions.dart';
import 'package:bustracking/util/images.dart';
import 'package:bustracking/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateParentScreen extends StatefulWidget {
  final UserModel userModel;
  UpdateParentScreen({required this.userModel});
  @override
  _UpdateParentScreenState createState() => _UpdateParentScreenState();
}

class _UpdateParentScreenState extends State<UpdateParentScreen> {
  final FocusNode _fullNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    _fullNameController = TextEditingController(text: widget.userModel.fullName);
    _emailController = TextEditingController(text: widget.userModel.email);
    _phoneController = TextEditingController(text: widget.userModel.phone);
    _passwordController = TextEditingController(text: widget.userModel.password);
    _confirmPasswordController = TextEditingController(text: widget.userModel.password);
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
              child: GetBuilder<AuthController>(builder: (authController) {
                return Column(children: [
                  Image.asset(
                    Images.bus_logo_image,
                    width: 200,
                    height: 80,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Center(
                    child: Text(
                      'Update Parent',
                      style: TextStyle(
                          fontSize: 30.0,
                          letterSpacing: 3.0,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.mainColor,
                          fontFamily: 'Cairo'),
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
                        hintText: 'email',
                        controller: _emailController,
                        focusNode: _emailFocus,
                        nextFocus: _phoneFocus,
                        inputType: TextInputType.emailAddress,
                        divider: true,
                      ),
                      CustomTextField(
                        hintText: 'phone',
                        controller: _phoneController,
                        focusNode: _phoneFocus,
                        nextFocus: _passwordFocus,
                        inputType: TextInputType.phone,
                        divider: false,
                      ),
               
                    ]),
                  ),
                 
                  const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                  !authController.isLoading
                      ? Row(children: [
                          Expanded(
                              child: CustomButton(
                            buttonText: 'Save',
                            onPressed: () => _save(authController),
                          )),
                        ])
                      : Center(child: CircularProgressIndicator()),
                  const SizedBox(height: 20),
                  
                ]);
              }),
            ),
          ),
        ),
      )),
    );
  }

  void _save(AuthController authController) async {
    String _fullName = _fullNameController.text.trim();
    String _email = _emailController.text.trim();
    String _number = _phoneController.text.trim();

    if (_fullName.isEmpty) {
      showCustomSnackBar('Enter your first name');
    } else if (_email.isEmpty) {
      showCustomSnackBar('Enter email address');
    } else if (!GetUtils.isEmail(_email)) {
      showCustomSnackBar('Enter a valid email address');
    } else if (_number.isEmpty) {
      showCustomSnackBar('Enter phone number');
    
    } else {
      print(widget.userModel.id);
      print(_number);

      authController.updateProfile(widget.userModel.id!, _fullName, _email, _number).then((response) async {
        if (response['status']) {
            Navigator.pop(context);
          

          showCustomSnackBar("Information Updated Successfully!", isError: false);
        } else {
          showCustomSnackBar(response['error']);
        }
      });
    }
  }
}
